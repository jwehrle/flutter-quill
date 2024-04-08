import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/buttons/indent_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/utils/labels.dart';
import 'package:flutter_quill/widgets/toolbar/items/quill_item.dart';
import 'package:iconic_button/iconic_button.dart';

/// Makes a [FloatingToolbarItem] with indentPlus and indentMinus popups
class IndentItem extends QuillItem {
  IndentItem({
    required QuillController controller,
    required Disposer disposer,
    required super.style,
    super.onFinished,
    super.iconData = Icons.format_indent_increase,
    super.label = kIndentLabel,
    super.tooltip = kIndentTooltip,
    super.preferBelow = false,
    this.indentPlusIconData = Icons.arrow_forward,
    this.indentPlusLabel,
    this.indentPlusTooltip = kIndentPlusTooltip,
    this.indentMinusIconData = Icons.arrow_back,
    this.indentMinusLabel,
    this.indentMinusTooltip = kIndentMinusTooltip,
  }) {
    _indentController = IndentController(controller);
    _indentPlusController = ButtonController(
      value: _indentPlusStateFromAttribute(_indentController.indent),
    );
    _indentMinusController = ButtonController(
      value: _indentMinusStateFromAttribute(_indentController.indent),
    );
    _indentController.indentListenable.addListener(() => _onIndentChanged(
          indent: _indentController.indent,
          plusController: _indentPlusController,
          minusController: _indentMinusController,
        ));
    disposer.onDispose.then((_) {
      _indentController.dispose();
      _indentPlusController.dispose();
      _indentMinusController.dispose();
    });
  }

  late final IndentController _indentController;
  late final ButtonController _indentPlusController;
  late final ButtonController _indentMinusController;

  /// Indent plus popup button IconData, defaults to [Icons.arrow_forward]
  final IconData indentPlusIconData;

  /// Indent plus popup button label, defaults to [Null]
  final String? indentPlusLabel;

  /// Indent plus popup button tooltip, defaults to 'Increase indentation'
  final String indentPlusTooltip;

  /// Indent plus popup button IconData, defaults to [Icons.arrow_back]
  final IconData indentMinusIconData;

  /// Indent plus popup button label, defaults to [Null]
  final String? indentMinusLabel;

  /// Indent plus popup button tooltip, defaults to 'Decrease indentation'
  final String indentMinusTooltip;

  Set<ButtonState> _indentPlusStateFromAttribute(Attribute? attribute) {
    if (attribute?.value == 3) {
      return {};
    } else {
      return {ButtonState.enabled};
    }
  }

  Set<ButtonState> _indentMinusStateFromAttribute(Attribute? attribute) {
    if (attribute?.value == null) {
      return {};
    } else {
      return {ButtonState.enabled};
    }
  }

  void _onIndentChanged({
    required Attribute? indent,
    required ButtonController plusController,
    required ButtonController minusController,
  }) {
    if (_indentPlusStateFromAttribute(indent).contains(ButtonState.enabled)) {
      plusController.enable();
    } else {
      plusController.disable();
    }
    if (_indentMinusStateFromAttribute(indent).contains(ButtonState.enabled)) {
      minusController.enable();
    } else {
      minusController.disable();
    }
  }

  /// indentL3 > indentL2 > indentL1
  Attribute? _incrementIndent(Attribute? attribute) {
    if (attribute == null || attribute.value == null) {
      return Attribute.indentL1;
    }
    if (attribute == Attribute.indentL3) {
      return null;
    }
    return Attribute.getIndentLevel(attribute.value + 1);
  }

  /// indentL1 < indentL2 < indentL3
  Attribute? _decrementIndent(Attribute? attribute) {
    if (attribute == null || attribute.value == null) {
      return null;
    }
    if (attribute == Attribute.indentL1) {
      return Attribute.clone(Attribute.indentL1, null);
    }
    return Attribute.getIndentLevel(attribute.value - 1);
  }

  Attribute? _alterIndent(IndentPopup type) {
    switch (type) {
      case IndentPopup.minus:
        return _decrementIndent(_indentController.indent);
      case IndentPopup.plus:
        return _incrementIndent(_indentController.indent);
    }
  }

  PopupData popupData(IndentPopup type, Set<ButtonState> state) {
    final icon;
    final label;
    final tooltip;
    final onPressed = () {
      final attr = _alterIndent(type);
      if (attr != null) {
        _indentController.controller.formatSelection(attr);
      }
      if (onFinished != null) {
        onFinished!();
      }
    };
    switch (type) {
      case IndentPopup.minus:
      icon = indentMinusIconData;
        label = indentMinusLabel;
        tooltip = indentMinusTooltip;
        break;
      case IndentPopup.plus:
        icon = indentPlusIconData;
        label = indentPlusLabel;
        tooltip = indentPlusTooltip;
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
            controller: _indentPlusController,
            builder: (context, state, _) =>
                popupFrom(popupData(IndentPopup.plus, state))
            ),
        PopupItemBuilder(
            controller: _indentMinusController,
            builder: (context, state, _) =>
                popupFrom(popupData(IndentPopup.minus, state))
            ),
      ],
    );
  }
}
