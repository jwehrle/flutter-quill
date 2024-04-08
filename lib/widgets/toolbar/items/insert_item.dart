import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/buttons/insert_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/widgets/dialogs/image_link_dialog.dart';
import 'package:flutter_quill/widgets/dialogs/text_link_dialog.dart';
import 'package:flutter_quill/models/toggles/toggle.dart';
import 'package:flutter_quill/utils/labels.dart';
import 'package:flutter_quill/widgets/toolbar/items/quill_item.dart';
import 'package:iconic_button/iconic_button.dart';

/// Makes a [FloatingToolbarItem] with link and image popups
class InsertItem extends QuillItem with ToggleMixin {
  InsertItem({
    required QuillController controller,
    required Disposer disposer,
    required super.style,
    super.onFinished,
    super.iconData = Icons.attachment_sharp,
    super.label = kInsertLabel,
    super.tooltip = kInsertTooltip,
    super.preferBelow = false,
    this.textLinkIconData = Icons.link,
    this.textLinkLabel,
    this.textLinkTooltip = kLinkTooltip,
    this.textLinkDialogTitle = kLinkTitle,
    this.textLinkDialogTextLabel = kLinkTextLabel,
    this.textLinkDialogUrlLabel = kUrlLabel,
    this.textLinkDialogCancelLabel = kDialogCancelLabel,
    this.textLinkDialogAcceptLabel = kDialogAcceptLabel,
    this.imageLinkIconData = Icons.image,
    this.imageLinkLabel,
    this.imageLinkTooltip = kImageTooltip,
    this.imageLinkDialogTitle = kImageTitle,
    this.imageLinkDialogUrlLabel = kUrlLabel,
    this.imageLinkDialogCancelLabel = kDialogCancelLabel,
    this.imageLinkDialogAcceptLabel = kDialogAcceptLabel,
  }) {
    _controller = controller;
    _insertController = InsertController(controller);
    _linkController = ButtonController(
      value: initButtonStateFromToggleState(_insertController.link),
    );
    _imageController = ButtonController(
      value: initButtonStateFromToggleState(_insertController.image),
    );
    _insertController.linkListenable.addListener(_linkListen);
    _insertController.imageListenable.addListener(_imageListen);
    disposer.onDispose.then(_dispose);
  }

  late final InsertController _insertController;
  late final ButtonController _linkController;
  late final ButtonController _imageController;
  late final QuillController _controller;

  /// Text link popup button IconData, defaults to [Icons.link]
  final IconData textLinkIconData;

  /// Text link popup button label, defaults to [Null]
  final String? textLinkLabel;

  /// Text link popup button tooltip, defaults to 'Format text as a link'
  final String textLinkTooltip;

  /// Image link popup button IconData, defaults to [Icons.image]
  final IconData imageLinkIconData;

  /// Image link popup button label, defaults to [Null]
  final String? imageLinkLabel;

  /// Image link popup button tooltip, defaults to 'Insert web image'
  final String imageLinkTooltip;

  /// Link dialog title, defaults to 'Text Link'
  final String textLinkDialogTitle;

  /// Link dialog text field label, defaults to 'Display text'
  final String textLinkDialogTextLabel;

  /// Link dialog url field label, defaults to 'Link'
  final String textLinkDialogUrlLabel;

  /// Link dialog cancel button label, defaults to 'Cancel'
  final String textLinkDialogCancelLabel;

  /// Link dialog accept button label, defaults to 'OK'
  final String textLinkDialogAcceptLabel;

  /// Image dialog title, defaults to 'Image Link'
  final String imageLinkDialogTitle;

  /// Image dialog url field label, defaults to 'Link'
  final String imageLinkDialogUrlLabel;

  /// Image dialog cancel button label, defaults to 'Cancel'
  final String imageLinkDialogCancelLabel;

  /// Image dialog accept button label, defaults to 'OK'
  final String imageLinkDialogAcceptLabel;

  void _linkListen() => toggleListener(
        _insertController.link,
        _linkController,
      );

  void _imageListen() => toggleListener(
        _insertController.image,
        _imageController,
      );

  void _dispose(_) {
    _insertController.dispose();
    _linkController.dispose();
    _imageController.dispose();
  }

  VoidCallback _onPressedFromType(BuildContext context, InsertPopup type) {
    switch (type) {
      case InsertPopup.image:
        return () {
          showDialog<ImageLink>(
            context: context,
            builder: (context) {
              return ImageLinkDialog(
                imageLink: ImageLink.prepare(_controller),
                title: imageLinkDialogTitle,
                urlLabel: imageLinkDialogUrlLabel,
                cancelLabel: imageLinkDialogCancelLabel,
                acceptLabel: imageLinkDialogAcceptLabel,
              );
            },
          ).then((imageLink) {
            if (imageLink != null) {
              imageLink.submit(_controller);
            }
            if (onFinished != null) {
              onFinished!();
            }
          });
        };
      case InsertPopup.text:
        return () {
          showDialog<TextLink>(
            context: context,
            builder: (context) => TextLinkDialog(
              textLink: TextLink.prepare(_controller),
              title: textLinkDialogTitle,
              textLabel: textLinkDialogTextLabel,
              urlLabel: textLinkDialogUrlLabel,
              cancelLabel: textLinkDialogCancelLabel,
              acceptLabel: textLinkDialogAcceptLabel,
            ),
          ).then((textLink) {
            if (textLink != null) {
              textLink.submit(_controller);
            }
            if (onFinished != null) {
              onFinished!();
            }
          });
        };
    }
  }

  PopupData popupData(
      BuildContext context, InsertPopup type, Set<ButtonState> state) {
    final icon;
    final label;
    final tooltip;
    final onPressed = _onPressedFromType(context, type);
    switch (type) {
      case InsertPopup.image:
        icon = imageLinkIconData;
        label = imageLinkLabel;
        tooltip = imageLinkTooltip;
        break;
      case InsertPopup.text:
        icon = textLinkIconData;
        label = textLinkLabel;
        tooltip = textLinkTooltip;
        break;
    }
    return PopupData(
      isSelectable: false,
      isSelected: state.contains(ButtonState.selected),
      isEnabled: state.contains(ButtonState.enabled),
      iconData: icon,
      label: label,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }

  @override
  FloatingToolbarItem build() {
    return FloatingToolbarItem.buttonWithPopups(
      item: toolbarButton,
      popups: [
        PopupItemBuilder(
          controller: _linkController,
          builder: (context, state, _) =>
              popupFrom(popupData(context, InsertPopup.text, state)),
        ),
        PopupItemBuilder(
          controller: _imageController,
          builder: (context, state, _) =>
              popupFrom(popupData(context, InsertPopup.image, state)),
        ),
      ],
    );
  }
}
