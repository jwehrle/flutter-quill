import 'package:community_material_icon/community_material_icon.dart';
import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/buttons/list_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/toggles/toggle.dart';
import 'package:flutter_quill/utils/labels.dart';
import 'package:flutter_quill/widgets/toolbar/items/quill_item.dart';
import 'package:iconic_button/iconic_button.dart';

/// Makes a [FloatingToolbarItem] with bullet and number popups
class ListItem extends QuillItem with ToggleMixin {
  ListItem({
    required QuillController controller,
    required Disposer disposer,
    required super.style,
    super.onFinished,
    super.iconData = CommunityMaterialIcons.view_list,
    super.label = kListLabel,
    super.tooltip = kListTooltip,
    this.numberedListIconData = Icons.format_list_numbered,
    this.numberedListLabel,
    this.numberedListTooltip = kNumberTooltip,
    this.bulletedListIconData = Icons.format_list_bulleted,
    this.bulletedListLabel,
    this.bulletedListTooltip = kBulletTooltip,
  }) {
    _listController = ListController(controller);
    _numberController = ButtonController(
        value: initButtonStateFromToggleState(_listController.number));
    _bulletController = ButtonController(
        value: initButtonStateFromToggleState(_listController.bullet));
    _listController.numberListenable.addListener(() => toggleListener(
          _listController.number,
          _numberController,
        ));
    _listController.bulletListenable.addListener(() => toggleListener(
          _listController.bullet,
          _bulletController,
        ));
    disposer.onDispose.then((_) {
      _listController.dispose();
      _numberController.dispose();
      _bulletController.dispose();
    });
  }

  late final ListController _listController;
  late final ButtonController _numberController;
  late final ButtonController _bulletController;

  /// Numbered list popup button IconData, defaults to [Icons.format_list_numbered]
  final IconData numberedListIconData;

  /// Numbered list popup button label, defaults to [Null]
  final String? numberedListLabel;

  /// Numbered list popup button tooltip, defaults to 'Format text as numbered list'
  final String numberedListTooltip;

  /// Bulleted list popup button IconData, defaults to [Icons.format_list_bulleted]
  final IconData bulletedListIconData;

  /// Bulleted list popup button label, defaults to [Null]
  final String? bulletedListLabel;

  /// Bulleted list popup button tooltip, defaults to 'Format text as bulleted list'
  final String bulletedListTooltip;

  PopupData popupData(ListPopup type, Set<ButtonState> state) {
    final icon;
    final label;
    final tooltip;
    final attribute;
    switch (type) {
      case ListPopup.bulleted:
        icon = bulletedListIconData;
        label = bulletedListLabel;
        tooltip = bulletedListTooltip;
        attribute = Attribute.ul;
        break;
      case ListPopup.numbered:
        icon = numberedListIconData;
        label = numberedListLabel;
        tooltip = numberedListTooltip;
        attribute = Attribute.ol;
        break;
    }
    final onPressed = () {
      toggle(
        state: _listController.number,
        attribute: attribute,
        controller: _listController.controller,
      );
      if (onFinished != null) {
        onFinished!();
      }
    };
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
    return FloatingToolbarItem.popup(
      toolbarButton,
      [
        PopupItemBuilder(
          controller: _numberController,
          builder: (context, state, _) =>
              popupFrom(popupData(ListPopup.numbered, state)),
        ),
        PopupItemBuilder(
          controller: _bulletController,
          builder: (context, state, _) =>
              popupFrom(popupData(ListPopup.bulleted, state)),
        ),
      ],
    );
  }
}
