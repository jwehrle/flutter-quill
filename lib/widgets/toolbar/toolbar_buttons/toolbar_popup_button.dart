import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/rich_text_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_buttons/toolbar_button.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';
import 'package:mdi/mdi.dart';

class ToolbarPopupButton extends StatefulWidget {
  final ToolbarPopupType type;
  final QuillController controller;

  const ToolbarPopupButton({
    Key? key,
    required this.type,
    required this.controller,
  }) : super(key: key);

  const ToolbarPopupButton.size({required this.controller})
      : this.type = ToolbarPopupType.size,
        super(key: const ValueKey(kSizeItemKey + '_button'));

  const ToolbarPopupButton.indent({required this.controller})
      : this.type = ToolbarPopupType.indent,
        super(key: const ValueKey(kIndentItemKey + '_button'));

  const ToolbarPopupButton.style({required this.controller})
      : this.type = ToolbarPopupType.style,
        super(key: const ValueKey(kStyleItemKey + '_button'));

  const ToolbarPopupButton.block({required this.controller})
      : this.type = ToolbarPopupType.block,
        super(key: const ValueKey(kBlockItemKey + '_button'));

  const ToolbarPopupButton.list({required this.controller})
      : this.type = ToolbarPopupType.list,
        super(key: const ValueKey(kListItemKey + '_button'));

  @override
  State<ToolbarPopupButton> createState() => ToolbarPopupButtonState();
}

class ToolbarPopupButtonState extends State<ToolbarPopupButton> {
  late final ValueNotifier<ToggleState> _toggleState;
  late final ValueNotifier<String?> _selectionNotifier;
  late final ValueNotifier<ToolbarAlignment> _alignmentNotifier;
  late ToolbarAlignment _alignment;
  late final String _itemKey;
  late final String _label;
  late final String _tooltip;
  late final IconData _iconData;
  late Color _foreground;
  late Color _background;
  late Color _disabled;
  late final RichTextToolbarState _toolbar;

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
      case ToolbarPopupType.size:
        _itemKey = kSizeItemKey;
        _label = kSizeLabel;
        _tooltip = kSizeTooltip;
        _iconData = Icons.format_size;
        break;
      case ToolbarPopupType.indent:
        _itemKey = kIndentItemKey;
        _label = kIndentLabel;
        _tooltip = kIndentTooltip;
        _iconData = Icons.format_indent_increase;
        break;
      case ToolbarPopupType.style:
        _itemKey = kStyleItemKey;
        _label = kStyleLabel;
        _tooltip = kStyleTooltip;
        _iconData = Mdi.formatFont;
        break;
      case ToolbarPopupType.block:
        _itemKey = kBlockItemKey;
        _label = kBlockLabel;
        _tooltip = kBlockTooltip;
        _iconData = Mdi.formatPilcrow;
        break;
      case ToolbarPopupType.list:
        _itemKey = kListItemKey;
        _label = kListLabel;
        _tooltip = kListTooltip;
        _iconData = Mdi.viewList;
        break;
    }
    _toolbar = RichTextToolbar.of(context);
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
      tooltip: _tooltip,
      foreground: _foreground,
      background: _background,
      alignment: _alignment,
      toggleState: _toggleState,
      onPressed: () {
        final popupNotifier = RichTextToolbar.of(context).selectionNotifier;
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
