import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/popup_buttons/popup_toolbar_button.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/operations.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class PopupActionButton extends StatefulWidget {
  final PopupActionType type;
  final QuillController controller;

  PopupActionButton({
    Key? key,
    required this.type,
    required this.controller,
  }) : super(key: key);

  @override
  PopupActionButtonState createState() => PopupActionButtonState();
}

class PopupActionButtonState extends State<PopupActionButton> {
  late Attribute? _currentValue;
  late final String attributeKey;
  late final IconData _iconData;
  late final String _tooltip;

  Style get _selectionStyle => widget.controller.getSelectionStyle();
  Attribute? get currentAttribute => _currentValue;

  void _assignCurrentValue() {
    _currentValue = _selectionStyle.attributes[attributeKey];
  }

  @override
  void initState() {
    switch (widget.type) {
      case PopupActionType.sizePlus:
        attributeKey = Attribute.header.key!;
        _iconData = Icons.arrow_upward;
        _tooltip = kSizePlusTooltip;
        break;
      case PopupActionType.indentPlus:
        attributeKey = Attribute.indent.key!;
        _iconData = Icons.arrow_forward;
        _tooltip = kIndentPlusTooltip;
        break;
      case PopupActionType.sizeMinus:
        attributeKey = Attribute.header.key!;
        _iconData = Icons.arrow_downward;
        _tooltip = kSizeMinusTooltip;
        break;
      case PopupActionType.indentMinus:
        attributeKey = Attribute.indent.key!;
        _iconData = Icons.arrow_back;
        _tooltip = kIndentMinusTooltip;
        break;
    }
    _assignCurrentValue();
    widget.controller.addListener(_didChangeEditingValue);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PopupActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _assignCurrentValue();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  void _didChangeEditingValue() {
    setState(() {
      _assignCurrentValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupToolbarButton(
      onPressed: _onPressedHandler(),
      iconData: _iconData,
      tooltip: _tooltip,
    );
  }

  VoidCallback? _onPressedHandler() {
    switch (widget.type) {
      case PopupActionType.sizePlus:
        return getOnPressed(incrementSize(_currentValue));
      case PopupActionType.sizeMinus:
        return getOnPressed(decrementSize(_currentValue));
      case PopupActionType.indentPlus:
        return getOnPressed(incrementIndent(_currentValue));
      case PopupActionType.indentMinus:
        return getOnPressed(decrementIndent(_currentValue));
    }
  }

  VoidCallback? getOnPressed(Attribute? attribute) {
    return attribute == null
        ? null
        : () => widget.controller.formatSelection(attribute);
  }
}
