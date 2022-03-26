import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_buttons/buttons.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class ToolbarLinkButton extends StatefulWidget {
  final QuillController controller;

  const ToolbarLinkButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _ToolbarLinkButtonState createState() => _ToolbarLinkButtonState();
}

class _ToolbarLinkButtonState extends State<ToolbarLinkButton> {
  late final ValueNotifier<ToggleState> _toggleStateNotifier;

  void _didChangeSelection() =>
      _toggleStateNotifier.value = widget.controller.selection.isCollapsed
          ? ToggleState.disabled
          : ToggleState.off;

  @override
  void initState() {
    super.initState();
    _toggleStateNotifier = ValueNotifier(widget.controller.selection.isCollapsed
        ? ToggleState.disabled
        : ToggleState.off);
    widget.controller.addListener(_didChangeSelection);
  }

  @override
  void didUpdateWidget(covariant ToolbarLinkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeSelection);
      widget.controller.addListener(_didChangeSelection);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeSelection);
    _toggleStateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarData>(
      valueListenable: FloatingToolbar.of(context).toolbarDataNotifier,
      builder: (context, data, child) {
        return ToolbarButton(
          itemKey: kLinkItemKey,
          iconData: Icons.link,
          label: 'Link',
          tooltip: 'Format text as a link',
          toggleStateNotifier: _toggleStateNotifier,
          onPressed: () => _openLinkDialog(context),
          alignment: data.alignment,
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
