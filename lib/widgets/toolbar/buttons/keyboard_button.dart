import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/attribute_toggle_mixin.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/toolbar_tile.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

const String kKeyboardItemKey = 'keyboard_toolbar_item';

class KeyboardButton extends StatefulWidget {
  final FocusNode focusNode;

  const KeyboardButton({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => KeyboardButtonState();
}

class KeyboardButtonState extends State<KeyboardButton> {
  late ToggleState _toggleState;
  late ToolbarAlignment _alignment;
  late Color _foreground;
  late Color _background;
  late final ToolbarState _toolbar;

  void _alignmentListener() =>
      setState(() => _alignment = _toolbar.alignmentNotifier.value);
  void _foregroundListener() =>
      setState(() => _foreground = _toolbar.foregroundColor.value);
  void _backgroundListener() =>
      setState(() => _background = _toolbar.backgroundColor.value);
  void _focusListener() => setState(() => _toggleState =
      widget.focusNode.hasFocus ? ToggleState.off : ToggleState.disabled);

  @override
  void initState() {
    super.initState();
    _toggleState =
        widget.focusNode.hasFocus ? ToggleState.off : ToggleState.disabled;
    widget.focusNode.addListener(_focusListener);
    _toolbar = Toolbar.of(context);
    _alignment = _toolbar.alignmentNotifier.value;
    _toolbar.alignmentNotifier.addListener(_alignmentListener);
    _foreground = _toolbar.foregroundColor.value;
    _toolbar.foregroundColor.addListener(_foregroundListener);
    _background = _toolbar.backgroundColor.value;
    _toolbar.backgroundColor.addListener(_backgroundListener);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => widget.focusNode.unfocus(),
      child: ToolbarTile(
        iconData: Icons.keyboard_hide,
        label: 'Done',
        state: _toggleState,
        accent: _foreground,
        background: _background,
        disabled: _foreground,
        direction: toolbarAxisFromAlignment(_alignment),
      ),
    );
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusListener);
    _toolbar.alignmentNotifier.removeListener(_alignmentListener);
    _toolbar.foregroundColor.removeListener(_foregroundListener);
    _toolbar.backgroundColor.removeListener(_backgroundListener);
    super.dispose();
  }
}
