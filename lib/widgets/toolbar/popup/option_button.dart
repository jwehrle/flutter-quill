import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/popup/popup_option.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

enum OptionType {
  sizePlus,
  sizeMinus,
  indentPlus,
  indentMinus,
}

class OptionButton extends StatefulWidget {
  final OptionType type;
  final QuillController controller;

  OptionButton({
    Key? key,
    required this.type,
    required this.controller,
  }) : super(key: key);

  @override
  OptionState createState() => OptionState();
}

class OptionState extends State<OptionButton> {
  late Attribute? _currentValue;
  late final String attributeKey;
  late final IconData iconData;

  Style get _selectionStyle => widget.controller.getSelectionStyle();
  Attribute? get currentAttribute => _currentValue;

  void _assignCurrentValue() {
    _currentValue = _selectionStyle.attributes[attributeKey];
  }

  @override
  void initState() {
    switch (widget.type) {
      case OptionType.sizePlus:
        attributeKey = Attribute.header.key!;
        iconData = Icons.arrow_upward;
        break;
      case OptionType.indentPlus:
        attributeKey = Attribute.indent.key!;
        iconData = Icons.arrow_forward;
        break;
      case OptionType.sizeMinus:
        attributeKey = Attribute.header.key!;
        iconData = Icons.arrow_downward;
        break;
      case OptionType.indentMinus:
        attributeKey = Attribute.indent.key!;
        iconData = Icons.arrow_back;
        break;
    }
    _assignCurrentValue();
    widget.controller.addListener(_didChangeEditingValue);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OptionButton oldWidget) {
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
    return PopupOption(
      onPressed: _onPressedHandler(),
      iconData: iconData,
    );
  }

  VoidCallback? _onPressedHandler() {
    switch (widget.type) {
      case OptionType.sizePlus:
        return getOnPressed(incrementSize(_currentValue));
      case OptionType.sizeMinus:
        return getOnPressed(decrementSize(_currentValue));
      case OptionType.indentPlus:
        return getOnPressed(incrementIndent(_currentValue));
      case OptionType.indentMinus:
        return getOnPressed(decrementIndent(_currentValue));
    }
  }

  VoidCallback? getOnPressed(Attribute? attribute) {
    return attribute == null
        ? null
        : () => widget.controller.formatSelection(attribute);
  }
}
