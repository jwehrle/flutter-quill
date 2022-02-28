import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/attribute_toggle_mixin.dart';
import 'package:flutter_quill/widgets/toolbar/richtext_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/toolbar_tile.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

const String kLinkItemKey = 'toolbar_item_key_link';

class LinkToolbarButton extends StatefulWidget {
  final QuillController controller;

  const LinkToolbarButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _LinkToolbarButtonState createState() => _LinkToolbarButtonState();
}

class _LinkToolbarButtonState extends State<LinkToolbarButton> {
  late final ValueNotifier<ToggleState> _toggleStateNotifier;
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

  void _didChangeSelection() {
    _toggleStateNotifier.value = widget.controller.selection.isCollapsed
        ? ToggleState.disabled
        : ToggleState.off;
  }

  @override
  void initState() {
    super.initState();
    _toggleStateNotifier = ValueNotifier(widget.controller.selection.isCollapsed
        ? ToggleState.disabled
        : ToggleState.off);
    widget.controller.addListener(_didChangeSelection);
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
  void didUpdateWidget(covariant LinkToolbarButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeSelection);
      widget.controller.addListener(_didChangeSelection);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeSelection);
    _toolbar.alignmentNotifier.removeListener(_alignmentListener);
    _toolbar.foregroundColor.removeListener(_foregroundListener);
    _toolbar.backgroundColor.removeListener(_backgroundListener);
    _toolbar.disabledColor.removeListener(_disabledListener);
    _toggleStateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToggleState>(
      valueListenable: _toggleStateNotifier,
      builder: (context, value, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap:
              value == ToggleState.off ? () => _openLinkDialog(context) : null,
          child: ToolbarTile(
            iconData: Icons.link,
            label: 'Link',
            state: value,
            accent: _foreground,
            background: _background,
            disabled: _disabled,
            direction: toolbarAxisFromAlignment(_alignment),
          ),
        );
      },
    );
  }

  void _openLinkDialog(BuildContext context) {
    _toggleStateNotifier.value = ToggleState.on;
    showDialog<String>(
      context: context,
      builder: (ctx) {
        return _LinkDialog();
      },
    ).then(_linkSubmitted);
  }

  void _linkSubmitted(String? value) {
    _toggleStateNotifier.value = widget.controller.selection.isCollapsed
        ? ToggleState.disabled
        : ToggleState.off;
    if (value == null || value.isEmpty) {
      return;
    }
    widget.controller.formatSelection(LinkAttribute(value));
  }
}

class _LinkDialog extends StatefulWidget {
  const _LinkDialog({Key? key}) : super(key: key);

  @override
  _LinkDialogState createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  String _link = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        decoration: InputDecoration(labelText: 'Paste a link'),
        autofocus: true,
        onChanged: _linkChanged,
      ),
      actions: [
        TextButton(
          onPressed: _link.isNotEmpty ? _applyLink : null,
          child: Text('Apply'),
        ),
      ],
    );
  }

  void _linkChanged(String value) {
    setState(() {
      _link = value;
    });
  }

  void _applyLink() {
    Navigator.pop(context, _link);
  }
}
