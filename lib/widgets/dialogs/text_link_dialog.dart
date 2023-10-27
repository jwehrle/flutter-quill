import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/buttons/insert_controller.dart';

/// AlertDialog for inserting a link
class TextLinkDialog extends StatefulWidget {
  TextLinkDialog({
    Key? key,
    required this.textLink,
    required this.title,
    required this.textLabel,
    required this.urlLabel,
    required this.cancelLabel,
    required this.acceptLabel,
  }) : super(key: key);

  final TextLink textLink;
  final String title;
  final String textLabel;
  final String urlLabel;
  final String cancelLabel;
  final String acceptLabel;

  @override
  TextLinkDialogState createState() => TextLinkDialogState();
}

class TextLinkDialogState extends State<TextLinkDialog> {
  late final TextEditingController _textController;
  late final TextEditingController _urlController;
  late final ValueNotifier<bool> _validFields;

  bool get _hasValidFields =>
      _textController.text.isNotEmpty && _urlController.text.isNotEmpty;

  void _fieldListener() => _validFields.value = _hasValidFields;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController()..text = widget.textLink.text;
    _urlController = TextEditingController()..text = widget.textLink.link ?? '';
    _textController.addListener(_fieldListener);
    _urlController.addListener(_fieldListener);
    _validFields = ValueNotifier(_hasValidFields);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: InputDecoration(labelText: widget.textLabel),
          ),
          TextField(
            controller: _urlController,
            decoration: InputDecoration(labelText: widget.urlLabel),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _validFields,
          builder: (context, isValid, _) {
            return TextButton(
              onPressed: isValid ? _applyLink : null,
              child: Text(widget.acceptLabel),
            );
          },
        ),
      ],
    );
  }

  void _applyLink() {
    if (!_urlController.text.startsWith('https://')) {
      _urlController.text = 'https://' + _urlController.text;
    }
    Navigator.of(context).pop(
      TextLink(
        _textController.text.trim(),
        _urlController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _textController.removeListener(_fieldListener);
    _urlController.removeListener(_fieldListener);
    _textController.dispose();
    _urlController.dispose();
    _validFields.dispose();
    super.dispose();
  }
}