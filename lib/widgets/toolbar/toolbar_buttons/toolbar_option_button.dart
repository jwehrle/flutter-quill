import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/rich_text_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/tiles/toolbar_tile.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class ToolbarOptionButton extends StatefulWidget {
  final OptionButtonParameters params;

  const ToolbarOptionButton({
    Key? key,
    required this.params,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ToolbarOptionButtonState();
}

class ToolbarOptionButtonState extends State<ToolbarOptionButton> {
  late ToggleState _toggleState;
  late ToolbarAlignment _alignment;
  late Color _foreground;
  late Color _background;
  late final RichTextToolbarState _toolbar;

  void _toggleListener() =>
      setState(() => _toggleState = widget.params.toggleStateNotifier.value);
  void _alignmentListener() =>
      setState(() => _alignment = _toolbar.alignmentNotifier.value);
  void _foregroundListener() =>
      setState(() => _foreground = _toolbar.foregroundColor.value);
  void _backgroundListener() =>
      setState(() => _background = _toolbar.backgroundColor.value);

  @override
  void initState() {
    super.initState();
    _toggleState = widget.params.toggleStateNotifier.value;
    widget.params.toggleStateNotifier.addListener(_toggleListener);
    _toolbar = RichTextToolbar.of(context);
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
      onTap: widget.params.onPressed,
      child: ToolbarTile(
        iconData: widget.params.iconData,
        label: widget.params.label,
        tooltip: widget.params.tooltip,
        state: _toggleState,
        accent: _foreground,
        background: _background,
        disabled: _foreground,
        alignment: _alignment,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ToolbarOptionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.params != widget.params) {
      oldWidget.params.toggleStateNotifier.removeListener(_toggleListener);
      _toggleState = widget.params.toggleStateNotifier.value;
      widget.params.toggleStateNotifier.addListener(_toggleListener);
    }
  }

  @override
  void dispose() {
    widget.params.toggleStateNotifier.removeListener(_toggleListener);
    _toolbar.alignmentNotifier.removeListener(_alignmentListener);
    _toolbar.foregroundColor.removeListener(_foregroundListener);
    _toolbar.backgroundColor.removeListener(_backgroundListener);
    super.dispose();
  }
}
