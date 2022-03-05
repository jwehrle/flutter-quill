import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/attributes/attribute_toggle_mixin.dart';
import 'package:flutter_quill/widgets/toolbar/rich_text_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_buttons/toolbar_button.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class ToolbarToggleButton extends StatefulWidget {
  final ToggleType type;
  final QuillController controller;

  const ToolbarToggleButton.bold({required this.controller})
      : this.type = ToggleType.bold,
        super(key: const ValueKey(kBoldItemKey + '_button'));

  const ToolbarToggleButton.italic({required this.controller})
      : this.type = ToggleType.italic,
        super(key: const ValueKey(kItalicItemKey + '_button'));

  const ToolbarToggleButton.under({required this.controller})
      : this.type = ToggleType.under,
        super(key: const ValueKey(kUnderItemKey + '_button'));

  const ToolbarToggleButton.strike({required this.controller})
      : this.type = ToggleType.strike,
        super(key: const ValueKey(kStrikeItemKey + '_button'));

  const ToolbarToggleButton.quote({required this.controller})
      : this.type = ToggleType.quote,
        super(key: const ValueKey(kQuoteItemKey + '_button'));

  const ToolbarToggleButton.code({required this.controller})
      : this.type = ToggleType.code,
        super(key: const ValueKey(kCodeItemKey + '_button'));

  const ToolbarToggleButton.number({required this.controller})
      : this.type = ToggleType.number,
        super(key: const ValueKey(kNumberItemKey + '_button'));

  const ToolbarToggleButton.bullet({required this.controller})
      : this.type = ToggleType.bullet,
        super(key: const ValueKey(kBulletItemKey + '_button'));

  @override
  ToolbarToggleButtonState createState() => ToolbarToggleButtonState();
}

class ToolbarToggleButtonState extends State<ToolbarToggleButton>
    with AttributeToggle {
  late final Attribute _attribute;
  late final String _itemKey;
  late final IconData _iconData;
  late final String _label;
  late final String _tooltip;
  late ToolbarAlignment _alignment;
  late final ValueNotifier<String?> _selectionNotifier;
  late Color _foreground;
  late Color _background;
  late Color _disabled;
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
    _toolbar = RichTextToolbar.of(context);
    _selectionNotifier = _toolbar.selectionNotifier;
    _foreground = _toolbar.foregroundColor.value;
    _toolbar.foregroundColor.addListener(_foregroundListener);
    _background = _toolbar.backgroundColor.value;
    _toolbar.backgroundColor.addListener(_backgroundListener);
    _disabled = _toolbar.disabledColor.value;
    _toolbar.disabledColor.addListener(_disabledListener);
    _alignment = _toolbar.alignmentNotifier.value;
    _toolbar.alignmentNotifier.addListener(_alignmentListener);
    widget.controller.addListener(_controllerListener);
    switch (widget.type) {
      case ToggleType.code:
        _attribute = Attribute.codeBlock;
        _itemKey = kBoldItemKey;
        _iconData = Icons.code;
        _label = kCodeLabel;
        _tooltip = kCodeToolTip;
        break;
      case ToggleType.bold:
        _attribute = Attribute.bold;
        _itemKey = kBoldItemKey;
        _iconData = Icons.format_bold;
        _label = kBoldLabel;
        _tooltip = kBoldToolTip;
        break;
      case ToggleType.bullet:
        _attribute = Attribute.ul;
        _itemKey = kBulletItemKey;
        _iconData = Icons.format_list_bulleted;
        _label = kBulletLabel;
        _tooltip = kBulletToolTip;
        break;
      case ToggleType.italic:
        _attribute = Attribute.italic;
        _itemKey = kItalicItemKey;
        _iconData = Icons.format_italic;
        _label = kItalicLabel;
        _tooltip = kItalicToolTip;
        break;
      case ToggleType.number:
        _attribute = Attribute.ol;
        _itemKey = kNumberItemKey;
        _iconData = Icons.format_list_numbered;
        _label = kNumberLabel;
        _tooltip = kNumberToolTip;
        break;
      case ToggleType.quote:
        _attribute = Attribute.blockQuote;
        _itemKey = kBoldItemKey;
        _iconData = Icons.format_quote;
        _label = kQuoteLabel;
        _tooltip = kQuoteToolTip;
        break;
      case ToggleType.strike:
        _attribute = Attribute.strikeThrough;
        _itemKey = kBoldItemKey;
        _iconData = Icons.format_strikethrough;
        _label = kStrikeLabel;
        _tooltip = kStrikeToolTip;
        break;
      case ToggleType.under:
        _attribute = Attribute.underline;
        _itemKey = kBoldItemKey;
        _iconData = Icons.format_underline;
        _label = kUnderLabel;
        _tooltip = kUnderToolTip;
        break;
    }
    attributeInit(widget.controller, _attribute);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ToolbarToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_controllerListener);
      widget.controller.addListener(_controllerListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToolbarButton(
      itemKey: _itemKey,
      iconData: _iconData,
      label: _label,
      tooltip: _tooltip,
      foreground: _foreground,
      background: _background,
      toggleState: state,
      onPressed: _onPressed,
      disabled: _disabled,
      alignment: _alignment,
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

  void _controllerListener() {
    setState(() {
      onEditingValueChanged(widget.controller, _attribute);
    });
  }

  void _onPressed() {
    setState(() {
      _selectionNotifier.value = null;
      toggleAttribute(widget.controller, _attribute);
    });
  }
}
