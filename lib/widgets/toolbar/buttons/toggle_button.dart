import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/attribute_toggle_mixin.dart';
import 'package:flutter_quill/widgets/toolbar/richtext_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/toolbar_button.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

enum ToggleToolbarType {
  bold,
  italic,
  under,
  strike,
  quote,
  code,
  number,
  bullet
}

const String kBoldItemKey = 'toolbar_item_key_bold';
const String kItalicItemKey = 'toolbar_item_key_italic';
const String kUnderItemKey = 'toolbar_item_key_underline';
const String kStrikeItemKey = 'toolbar_item_key_strike';
const String kQuoteItemKey = 'toolbar_item_key_quote';
const String kCodeItemKey = 'toolbar_item_key_code';
const String kNumberItemKey = 'toolbar_item_key_number';
const String kBulletItemKey = 'toolbar_item_key_bullet';

const String kBoldLabel = 'Bold';
const String kItalicLabel = 'Italic';
const String kUnderLabel = 'Under';
const String kStrikeLabel = 'Strike';
const String kQuoteLabel = 'Quote';
const String kCodeLabel = 'Code';
const String kNumberLabel = 'Number';
const String kBulletLabel = 'Bullet';

class ToggleButton extends StatefulWidget {
  final ToggleToolbarType type;
  final QuillController controller;

  const ToggleButton.bold({required this.controller})
      : this.type = ToggleToolbarType.bold,
        super(key: const ValueKey(kBoldItemKey + '_button'));

  const ToggleButton.italic({required this.controller})
      : this.type = ToggleToolbarType.italic,
        super(key: const ValueKey(kItalicItemKey + '_button'));

  const ToggleButton.under({required this.controller})
      : this.type = ToggleToolbarType.under,
        super(key: const ValueKey(kUnderItemKey + '_button'));

  const ToggleButton.strike({required this.controller})
      : this.type = ToggleToolbarType.strike,
        super(key: const ValueKey(kStrikeItemKey + '_button'));

  const ToggleButton.quote({required this.controller})
      : this.type = ToggleToolbarType.quote,
        super(key: const ValueKey(kQuoteItemKey + '_button'));

  const ToggleButton.code({required this.controller})
      : this.type = ToggleToolbarType.code,
        super(key: const ValueKey(kCodeItemKey + '_button'));

  const ToggleButton.number({required this.controller})
      : this.type = ToggleToolbarType.number,
        super(key: const ValueKey(kNumberItemKey + '_button'));

  const ToggleButton.bullet({required this.controller})
      : this.type = ToggleToolbarType.bullet,
        super(key: const ValueKey(kBulletItemKey + '_button'));

  @override
  ToggleButtonState createState() => ToggleButtonState();
}

class ToggleButtonState extends State<ToggleButton> with AttributeToggle {
  late final Attribute _attribute;
  late final String _itemKey;
  late final IconData _iconData;
  late final String _label;
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
      case ToggleToolbarType.bold:
        _attribute = Attribute.bold;
        _itemKey = kBoldItemKey;
        _iconData = Icons.format_bold;
        _label = kBoldLabel;
        break;
      case ToggleToolbarType.italic:
        _attribute = Attribute.italic;
        _itemKey = kItalicItemKey;
        _iconData = Icons.format_italic;
        _label = kItalicLabel;
        break;
      case ToggleToolbarType.under:
        _attribute = Attribute.underline;
        _itemKey = kBoldItemKey;
        _iconData = Icons.format_underline;
        _label = kUnderLabel;
        break;
      case ToggleToolbarType.strike:
        _attribute = Attribute.strikeThrough;
        _itemKey = kBoldItemKey;
        _iconData = Icons.format_strikethrough;
        _label = kStrikeLabel;
        break;
      case ToggleToolbarType.quote:
        _attribute = Attribute.blockQuote;
        _itemKey = kBoldItemKey;
        _iconData = Icons.format_quote;
        _label = kQuoteLabel;
        break;
      case ToggleToolbarType.code:
        _attribute = Attribute.codeBlock;
        _itemKey = kBoldItemKey;
        _iconData = Icons.code;
        _label = kCodeLabel;
        break;
      case ToggleToolbarType.number:
        _attribute = Attribute.ol;
        _itemKey = kNumberItemKey;
        _iconData = Icons.format_list_numbered;
        _label = kNumberLabel;
        break;
      case ToggleToolbarType.bullet:
        _attribute = Attribute.ul;
        _itemKey = kBulletItemKey;
        _iconData = Icons.format_list_bulleted;
        _label = kBulletLabel;
        break;
    }
    attributeInit(widget.controller, _attribute);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ToggleButton oldWidget) {
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
      foreground: _foreground,
      background: _background,
      toggleState: state,
      onPressed: _onPressed,
      disabled: _disabled,
      direction: toolbarAxisFromAlignment(_alignment),
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
