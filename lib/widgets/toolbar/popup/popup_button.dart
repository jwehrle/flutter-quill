import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/toolbar_button.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';
import 'package:mdi/mdi.dart';

import '../attribute_toggle_mixin.dart';

const String kSizeItemKey = 'toolbar_item_key_size';
const String kIndentItemKey = 'toolbar_item_key_indent';
const String kStyleItemKey = 'toolbar_item_key_style';
const String kBlockItemKey = 'toolbar_item_key_section';
const String kListItemKey = 'toolbar_item_key_list';

enum PopupButtonType { size, indent, style, block, list }

class PopupButton extends StatefulWidget {
  final PopupButtonType type;
  final QuillController controller;

  const PopupButton({
    Key? key,
    required this.type,
    required this.controller,
  }) : super(key: key);

  const PopupButton.size({required this.controller})
      : this.type = PopupButtonType.size,
        super(key: const ValueKey(kSizeItemKey + '_button'));

  const PopupButton.indent({required this.controller})
      : this.type = PopupButtonType.indent,
        super(key: const ValueKey(kIndentItemKey + '_button'));

  const PopupButton.style({required this.controller})
      : this.type = PopupButtonType.style,
        super(key: const ValueKey(kStyleItemKey + '_button'));

  const PopupButton.block({required this.controller})
      : this.type = PopupButtonType.block,
        super(key: const ValueKey(kBlockItemKey + '_button'));

  const PopupButton.list({required this.controller})
      : this.type = PopupButtonType.list,
        super(key: const ValueKey(kListItemKey + '_button'));

  @override
  State<PopupButton> createState() => PopupButtonState();
}

class PopupButtonState extends State<PopupButton> {
  late final ValueNotifier<ToggleState> _toggleState;
  late final ValueNotifier<String?> _selectionNotifier;
  late final ValueNotifier<ToolbarAlignment> _alignmentNotifier;
  late ToolbarAlignment _alignment;
  late final String _itemKey;
  late final String _label;
  late final IconData _iconData;
  late Color _foreground;
  late Color _background;
  late Color _disabled;
  late final ToolbarState _toolbar;

  ToggleState get toggleState =>
      _selectionNotifier.value == _itemKey ? ToggleState.on : ToggleState.off;

  void _selectionListener() {
    if (mounted) {
      _toggleState.value = toggleState;
    }
  }

  void _alignmentListener() =>
      setState(() => _alignment = _alignmentNotifier.value);
  void _foregroundListener() =>
      setState(() => _foreground = _toolbar.foregroundColor.value);
  void _backgroundListener() =>
      setState(() => _background = _toolbar.backgroundColor.value);
  void _disabledListener() =>
      setState(() => _disabled = _toolbar.disabledColor.value);

  @override
  void initState() {
    switch (widget.type) {
      case PopupButtonType.size:
        _itemKey = kSizeItemKey;
        _label = 'Size';
        _iconData = Icons.format_size;
        break;
      case PopupButtonType.indent:
        _itemKey = kIndentItemKey;
        _label = 'Indent';
        _iconData = Icons.format_indent_increase;
        break;
      case PopupButtonType.style:
        _itemKey = kStyleItemKey;
        _label = 'Style';
        _iconData = Mdi.formatFont;
        break;
      case PopupButtonType.block:
        _itemKey = kBlockItemKey;
        _label = 'Block';
        _iconData = Mdi.formatPilcrow;
        break;
      case PopupButtonType.list:
        _itemKey = kListItemKey;
        _label = 'List';
        _iconData = Mdi.viewList;
        break;
    }
    _toolbar = Toolbar.of(context);
    _selectionNotifier = _toolbar.selectionNotifier;
    _toggleState = ValueNotifier(toggleState);
    _selectionNotifier.addListener(_selectionListener);
    _alignmentNotifier = _toolbar.alignmentNotifier;
    _alignment = _alignmentNotifier.value;
    _alignmentNotifier.addListener(_alignmentListener);
    _foreground = _toolbar.foregroundColor.value;
    _toolbar.foregroundColor.addListener(_foregroundListener);
    _background = _toolbar.backgroundColor.value;
    _toolbar.backgroundColor.addListener(_backgroundListener);
    _disabled = _toolbar.disabledColor.value;
    _toolbar.disabledColor.addListener(_disabledListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ToolbarButton(
      itemKey: _itemKey,
      iconData: _iconData,
      label: _label,
      foreground: _foreground,
      background: _background,
      direction: toolbarAxisFromAlignment(_alignment),
      toggleState: _toggleState,
      onPressed: () {
        final popupNotifier = Toolbar.of(context).selectionNotifier;
        if (popupNotifier.value == _itemKey) {
          popupNotifier.value = null;
        } else {
          popupNotifier.value = _itemKey;
        }
      },
      disabled: _disabled,
    );
  }

  @override
  void dispose() {
    _toggleState.dispose();
    _selectionNotifier.removeListener(_selectionListener);
    _alignmentNotifier.removeListener(_alignmentListener);
    _toolbar.foregroundColor.removeListener(_foregroundListener);
    _toolbar.backgroundColor.removeListener(_backgroundListener);
    _toolbar.disabledColor.removeListener(_disabledListener);
    super.dispose();
  }
}
