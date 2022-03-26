import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
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
  late final ValueNotifier<ToggleState> _toggleStateNotifier;
  late final String _itemKey;
  late final String _label;
  late final String _tooltip;
  late final IconData _iconData;
  late final FloatingToolbarState _toolbar;

  ToggleState get toggleState => _toolbar.selectionNotifier.value == _itemKey
      ? ToggleState.on
      : ToggleState.off;

  void _selectionListener() {
    if (mounted) {
      _toggleStateNotifier.value = toggleState;
    }
  }

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
    _toolbar = FloatingToolbar.of(context);
    _toggleStateNotifier = ValueNotifier(toggleState);
    _toolbar.selectionNotifier.addListener(_selectionListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarData>(
      valueListenable: _toolbar.toolbarDataNotifier,
      builder: (context, data, child) {
        return ToolbarButton(
          itemKey: _itemKey,
          iconData: _iconData,
          label: _label,
          tooltip: _tooltip,
          alignment: data.alignment,
          toggleStateNotifier: _toggleStateNotifier,
          onPressed: () {
            final popupNotifier = FloatingToolbar.of(context).selectionNotifier;
            if (popupNotifier.value == _itemKey) {
              popupNotifier.value = null;
            } else {
              popupNotifier.value = _itemKey;
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _toggleStateNotifier.dispose();
    _toolbar.selectionNotifier.removeListener(_selectionListener);
    super.dispose();
  }
}
