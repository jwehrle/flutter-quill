import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/buttons/align_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/utils/labels.dart';
import 'package:flutter_quill/widgets/toolbar/items/quill_item.dart';
import 'package:iconic_button/iconic_button.dart';

/// A [FloatingToolbarItem] with left, right, center, and justify
/// alignment popups that show the current state of the ducument
/// under the cursor and toggle alignment for the current selection
class AlignItem extends QuillItem {
  /// Creates a [FloatingToolbarItem] with left, right, center, and justify
  /// alignment popups that show the current state of the ducument
  /// under the cursor and toggle alignment for the current selection
  AlignItem({
    required QuillController controller,
    required Disposer disposer,
    required super.style,
    super.onFinished,
    super.iconData = Icons.format_align_left,
    super.label = kAlignLabel,
    super.tooltip = kAlignTooltip,
    super.preferBelow = false,
    this.leftAlignIconData = Icons.format_align_left,
    this.leftAlignLabel,
    this.leftAlignTooltip = kLeftAlignTooltip,
    this.rightAlignIconData = Icons.format_align_right,
    this.rightAlignLabel,
    this.rightAlignTooltip = kRightAlignTooltip,
    this.centerAlignIconData = Icons.format_align_center,
    this.centerAlignLabel,
    this.centerAlignTooltip = kCenterAlignTooltip,
    this.justifyAlignIconData = Icons.format_align_justify,
    this.justifyAlignLabel,
    this.justifyAlignTooltip = kJustifyAlignTooltip,
  }) {
    _alignController = AlignController(controller);
    _leftController = ButtonController(
        value: _alignController.alignment == Attribute.leftAlignment
            ? {ButtonState.selected, ButtonState.enabled}
            : {ButtonState.enabled});
    _rightController = ButtonController(
        value: _alignController.alignment == Attribute.rightAlignment
            ? {ButtonState.selected, ButtonState.enabled}
            : {ButtonState.enabled});
    _centerController = ButtonController(
        value: _alignController.alignment == Attribute.centerAlignment
            ? {ButtonState.selected, ButtonState.enabled}
            : {ButtonState.enabled});
    _justifyController = ButtonController(
        value: _alignController.alignment == Attribute.justifyAlignment
            ? {ButtonState.selected, ButtonState.enabled}
            : {ButtonState.enabled});
    _alignController.alignmentListenable.addListener(
        () => _alignmentListener(attribute: _alignController.alignment));
    disposer.onDispose.then((_) {
      _alignController.dispose();
      _leftController.dispose();
      _rightController.dispose();
      _centerController.dispose();
      _justifyController.dispose();
    });
  }

  late final AlignController _alignController;
  late final ButtonController _leftController;
  late final ButtonController _rightController;
  late final ButtonController _centerController;
  late final ButtonController _justifyController;

  /// Left align popup button IconData, defaults to [Icons.format_align_left]
  final IconData leftAlignIconData;

  /// Left align popup button label, defaults to [Null]
  final String? leftAlignLabel;

  /// Left align popup button tooltip, defaults to 'Left align text'
  final String leftAlignTooltip;

  /// Right align popup button IconData, defaults to [Icons.format_align_right]
  final IconData rightAlignIconData;

  /// Right align popup button label, defaultst to [Null]
  final String? rightAlignLabel;

  /// Right align popup button tooltip, defaults to 'Right align text'
  final String rightAlignTooltip;

  /// Center align popup button IconData, defaults to [Icons.format_align_center]
  final IconData centerAlignIconData;

  /// Center align popup button label, defaultst to [Null]
  final String? centerAlignLabel;

  /// Center align popup button tooltip, defaults to 'Center align text'
  final String centerAlignTooltip;

  /// Justify align popup button IconData, defaults to [Icons.format_align_justify]
  final IconData justifyAlignIconData;

  /// Justify align popup button label, defaultst to [Null]
  final String? justifyAlignLabel;

  /// Justify align popup button tooltip, defaults to 'Justify align text'
  final String justifyAlignTooltip;

  Attribute get _noAlignment => Attribute('align', AttributeScope.BLOCK, null);

  void _alignmentListener({required Attribute? attribute}) {
    if (attribute == Attribute.leftAlignment) {
      _leftController.select();
      _rightController.unSelect();
      _centerController.unSelect();
      _justifyController.unSelect();
    } else if (attribute == Attribute.rightAlignment) {
      _leftController.unSelect();
      _rightController.select();
      _centerController.unSelect();
      _justifyController.unSelect();
    } else if (attribute == Attribute.centerAlignment) {
      _leftController.unSelect();
      _rightController.unSelect();
      _centerController.select();
      _justifyController.unSelect();
    } else if (attribute == Attribute.justifyAlignment) {
      _leftController.unSelect();
      _rightController.unSelect();
      _centerController.unSelect();
      _justifyController.select();
    } else {
      _leftController.unSelect();
      _rightController.unSelect();
      _centerController.unSelect();
      _justifyController.unSelect();
    }
  }

  PopupData popupData(AlignPopup type, Set<ButtonState> state) {
    final icon;
    final label;
    final tooltip;
    final attribute;
    switch (type) {
      case AlignPopup.centerAlign:
        icon = centerAlignIconData;
        label = centerAlignLabel;
        tooltip = centerAlignTooltip;
        attribute = Attribute.centerAlignment;
        break;
      case AlignPopup.justifyAlign:
        icon = justifyAlignIconData;
        label = justifyAlignLabel;
        tooltip = justifyAlignTooltip;
        attribute = Attribute.justifyAlignment;
        break;
      case AlignPopup.leftAlign:
        icon = leftAlignIconData;
        label = leftAlignLabel;
        tooltip = leftAlignTooltip;
        attribute = Attribute.leftAlignment;
        break;
      case AlignPopup.rightAlign:
        icon = rightAlignIconData;
        label = rightAlignLabel;
        tooltip = rightAlignTooltip;
        attribute = Attribute.rightAlignment;
        break;
    }
    final onPressed = () {
      if (_alignController.alignment == attribute) {
        _alignController.controller.formatSelection(_noAlignment);
      } else {
        _alignController.controller.formatSelection(attribute);
      }
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
          controller: _leftController,
          builder: (context, state, _) =>
              popupFrom(popupData(AlignPopup.leftAlign, state)),
        ),
        PopupItemBuilder(
          controller: _rightController,
          builder: (context, state, _) =>
              popupFrom(popupData(AlignPopup.rightAlign, state)),
        ),
        PopupItemBuilder(
          controller: _centerController,
          builder: (context, state, _) =>
              popupFrom(popupData(AlignPopup.centerAlign, state)),
        ),
        PopupItemBuilder(
          controller: _justifyController,
          builder: (context, state, _) =>
              popupFrom(popupData(AlignPopup.justifyAlign, state)),
        ),
      ],
    );
  }
}
