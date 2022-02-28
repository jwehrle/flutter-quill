import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/attribute_toggle_mixin.dart';
import 'package:flutter_quill/widgets/toolbar/popup/base_popup.dart';
import 'package:flutter_quill/widgets/toolbar/richtext_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

class PopupOption extends StatefulWidget {
  final IconData iconData;
  final VoidCallback? onPressed;

  const PopupOption({
    Key? key,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PopupOptionState();
}

class PopupOptionState extends State<PopupOption> {
  late ToolbarAlignment _alignment;
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
    super.initState();
    _toolbar = RichTextToolbar.of(context);
    _alignment = _toolbar.alignmentNotifier.value;
    _toolbar.alignmentNotifier.addListener(_alignmentListener);
    _foreground = _toolbar.foregroundColor.value;
    _toolbar.foregroundColor.addListener(_foregroundListener);
    _background = _toolbar.backgroundColor.value;
    _toolbar.backgroundColor.addListener(_backgroundListener);
    _disabled = _toolbar.disabledColor.value;
    _toolbar.disabledColor.addListener(_disabledListener);
  }

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      iconData: widget.iconData,
      foreground: _foreground,
      background: _background,
      disabled: _disabled,
      onPressed: widget.onPressed,
      state: widget.onPressed == null ? ToggleState.disabled : ToggleState.off,
      alignment: _alignment,
    );
  }

  @override
  void dispose() {
    _toolbar.alignmentNotifier.removeListener(_alignmentListener);
    _toolbar.foregroundColor.removeListener(_foregroundListener);
    _toolbar.backgroundColor.removeListener(_backgroundListener);
    _toolbar.disabledColor.removeListener(_disabledListener);
    super.dispose();
  }
}
