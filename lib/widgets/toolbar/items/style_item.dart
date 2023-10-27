import 'package:community_material_icon/community_material_icon.dart';
import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/buttons/style_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/toggles/toggle.dart';
import 'package:flutter_quill/utils/labels.dart';
import 'package:flutter_quill/widgets/toolbar/items/quill_item.dart';
import 'package:iconic_button/iconic_button.dart';

/// Makes a [FloatingToolbarItem] with bold, italic, under, and strike popups
class StyleItem extends QuillItem with ToggleMixin {
  StyleItem({
    required QuillController controller,
    required Disposer disposer,
    required super.style,
    super.onFinished,
    super.iconData = CommunityMaterialIcons.format_font,
    super.label = kStyleLabel,
    super.tooltip = kStyleTooltip,
    super.preferBelow = false,
    this.boldIconData = Icons.format_bold,
    this.boldLabel,
    this.boldTooltip = kBoldTooltip,
    this.italicIconData = Icons.format_italic,
    this.italicLabel,
    this.italicTooltip = kItalicTooltip,
    this.underlineIconData = Icons.format_underline,
    this.underlineLabel,
    this.underlineTooltip = kUnderTooltip,
    this.strikeThruIconData = Icons.format_strikethrough,
    this.strikeThruLabel,
    this.strikeThruTooltip = kStrikeTooltip,
  }) {
    _styleController = StyleController(controller);
    _boldController = ButtonController(
        value: initButtonStateFromToggleState(_styleController.bold));
    _italicController = ButtonController(
        value: initButtonStateFromToggleState(_styleController.italic));
    _underController = ButtonController(
        value: initButtonStateFromToggleState(_styleController.under));
    _strikeController = ButtonController(
        value: initButtonStateFromToggleState(_styleController.strike));
    _styleController.boldListenable.addListener(() => toggleListener(
          _styleController.bold,
          _boldController,
        ));
    _styleController.italicListenable.addListener(() => toggleListener(
          _styleController.italic,
          _italicController,
        ));
    _styleController.underListenable.addListener(() => toggleListener(
          _styleController.under,
          _underController,
        ));
    _styleController.strikeListenable.addListener(() => toggleListener(
          _styleController.strike,
          _strikeController,
        ));
    disposer.onDispose.then((_) {
      _styleController.dispose();
      _boldController.dispose();
      _italicController.dispose();
      _underController.dispose();
      _strikeController.dispose();
    });
  }

  late final StyleController _styleController;
  late final ButtonController _boldController;
  late final ButtonController _italicController;
  late final ButtonController _underController;
  late final ButtonController _strikeController;

  /// Bold popup button IconData, defaults to [Icons.format_bold]
  final IconData boldIconData;

  /// Bold popup button label, defaults to [Null]
  final String? boldLabel;

  /// Bold popup button tooltip, defaults to 'Make text bold'
  final String boldTooltip;

  /// Italic popup button IconData, defaults to [Icons.format_italic]
  final IconData italicIconData;

  /// Italic popup button label, defaults to [Null]
  final String? italicLabel;

  /// Italic popup button tooltip, defaults to 'Make text italic'
  final String italicTooltip;

  /// Underline popup button IconData, defaults to [Icons.format_underline]
  final IconData underlineIconData;

  /// Underline popup button label, defaults to [Null]
  final String? underlineLabel;

  /// Underline popup button tooltip, defaults to 'Underline text'
  final String underlineTooltip;

  /// Strikethrough popup button IconData, defaults to [Icons.format_strikethrough]
  final IconData strikeThruIconData;

  /// Strikethrough popup button label, defaults to [Null]
  final String? strikeThruLabel;

  /// Strikethrough popup button tooltip, defaults to 'Strike thru text'
  final String strikeThruTooltip;

  PopupData popupData(StylePopup type, Set<ButtonState> state) {
    final icon;
    final label;
    final tooltip;
    final attribute;
    switch (type) {
      case StylePopup.bold:
        icon = boldIconData;
        label = boldLabel;
        tooltip = boldTooltip;
        attribute = Attribute.bold;
        break;
      case StylePopup.italic:
        icon = italicIconData;
        label = italicLabel;
        tooltip = italicTooltip;
        attribute = Attribute.italic;
        break;
      case StylePopup.strikeThru:
        icon = strikeThruIconData;
        label = strikeThruLabel;
        tooltip = strikeThruTooltip;
        attribute = Attribute.strikeThrough;
        break;
      case StylePopup.underline:
        icon = underlineIconData;
        label = underlineLabel;
        tooltip = underlineTooltip;
        attribute = Attribute.underline;
        break;
    }
    final onPressed = () {
      toggle(
        state: _styleController.bold,
        attribute: attribute,
        controller: _styleController.controller,
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
          controller: _boldController,
          builder: (context, state, _) =>
              popupFrom(popupData(StylePopup.bold, state)),
        ),
        PopupItemBuilder(
          controller: _italicController,
          builder: (context, state, _) =>
              popupFrom(popupData(StylePopup.italic, state)),
        ),
        PopupItemBuilder(
          controller: _underController,
          builder: (context, state, _) =>
              popupFrom(popupData(StylePopup.underline, state)),
        ),
        PopupItemBuilder(
          controller: _strikeController,
          builder: (context, state, _) =>
              popupFrom(popupData(StylePopup.strikeThru, state)),
        ),
      ],
    );
  }
}
