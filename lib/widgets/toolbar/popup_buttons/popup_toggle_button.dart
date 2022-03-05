import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/attributes/attribute_toggle_mixin.dart';
import 'package:flutter_quill/widgets/toolbar/popup_buttons/popup_button.dart';
import 'package:flutter_quill/widgets/toolbar/rich_text_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';

class PopupToggleButton extends StatefulWidget {
  final ToggleType type;
  final QuillController controller;

  const PopupToggleButton({
    Key? key,
    required this.type,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PopupToggleButtonState();
}

class PopupToggleButtonState extends State<PopupToggleButton>
    with AttributeToggle {
  late final Attribute _attribute;
  late final IconData _iconData;
  late ToolbarAlignment _alignment;
  late Color _foreground;
  late Color _background;
  late Color _disabled;
  late final String _tooltip;
  late final RichTextToolbarState _toolbar;

  void _alignmentListener() =>
      setState(() => _alignment = _toolbar.alignmentNotifier.value);
  void _foregroundListener() =>
      setState(() => _foreground = _toolbar.foregroundColor.value);
  void _backgroundListener() =>
      setState(() => _background = _toolbar.backgroundColor.value);
  void _disabledListener() =>
      setState(() => _disabled = _toolbar.disabledColor.value);

  @override
  void initState() {
    switch (widget.type) {
      case ToggleType.code:
        _attribute = Attribute.codeBlock;
        _iconData = Icons.code;
        _tooltip = kCodeToolTip;
        break;
      case ToggleType.bold:
        _attribute = Attribute.bold;
        _iconData = Icons.format_bold;
        _tooltip = kBoldToolTip;
        break;
      case ToggleType.bullet:
        _attribute = Attribute.ul;
        _iconData = Icons.format_list_bulleted;
        _tooltip = kBulletToolTip;
        break;
      case ToggleType.italic:
        _attribute = Attribute.italic;
        _iconData = Icons.format_italic;
        _tooltip = kItalicToolTip;
        break;
      case ToggleType.number:
        _attribute = Attribute.ol;
        _iconData = Icons.format_list_numbered;
        _tooltip = kNumberToolTip;
        break;
      case ToggleType.quote:
        _attribute = Attribute.blockQuote;
        _iconData = Icons.format_quote;
        _tooltip = kQuoteToolTip;
        break;
      case ToggleType.strike:
        _attribute = Attribute.strikeThrough;
        _iconData = Icons.format_strikethrough;
        _tooltip = kStrikeToolTip;
        break;
      case ToggleType.under:
        _attribute = Attribute.underline;
        _iconData = Icons.format_underline;
        _tooltip = kUnderToolTip;
        break;
    }
    attributeInit(widget.controller, _attribute);
    widget.controller.addListener(_controllerListener);
    _toolbar = RichTextToolbar.of(context);
    _alignment = _toolbar.alignmentNotifier.value;
    _toolbar.alignmentNotifier.addListener(_alignmentListener);
    _foreground = _toolbar.foregroundColor.value;
    _toolbar.foregroundColor.addListener(_foregroundListener);
    _background = _toolbar.backgroundColor.value;
    _toolbar.backgroundColor.addListener(_backgroundListener);
    _disabled = _toolbar.disabledColor.value;
    _toolbar.disabledColor.addListener(_disabledListener);
    super.initState();
  }

  void _onPressed() {
    setState(() {
      toggleAttribute(widget.controller, _attribute);
    });
  }

  void _controllerListener() {
    setState(() {
      onEditingValueChanged(widget.controller, _attribute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToggleState>(
      valueListenable: state,
      builder: (context, value, child) {
        return PopupButton(
          iconData: _iconData,
          background: _background,
          foreground: _foreground,
          disabled: _disabled,
          state: value,
          onPressed: _onPressed,
          alignment: _alignment,
          tooltip: _tooltip,
        );
      },
    );
  }

  @override
  void dispose() {
    toggleDispose();
    widget.controller.removeListener(_controllerListener);
    _toolbar.alignmentNotifier.removeListener(_alignmentListener);
    _toolbar.foregroundColor.removeListener(_foregroundListener);
    _toolbar.backgroundColor.removeListener(_backgroundListener);
    _toolbar.disabledColor.removeListener(_disabledListener);
    super.dispose();
  }
}
