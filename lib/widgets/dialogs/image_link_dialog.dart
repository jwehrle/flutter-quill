import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/buttons/insert_controller.dart';

/// AlertDialog for inserting an image
class ImageLinkDialog extends StatefulWidget {
  final ImageLink imageLink;
  final String title;
  final String urlLabel;
  final String cancelLabel;
  final String acceptLabel;

  const ImageLinkDialog({
    required this.imageLink,
    required this.title,
    required this.urlLabel,
    required this.cancelLabel,
    required this.acceptLabel,
  });

  @override
  State<StatefulWidget> createState() => ImageLinkDialogState();
}

class ImageLinkDialogState extends State<ImageLinkDialog> {
  late final TextEditingController _urlController;
  late final ValueNotifier<bool> _urlIsNotEmpty;

  bool get _isNotEmpty => _urlController.text.isNotEmpty;

  void _emptyListener() => _urlIsNotEmpty.value = _isNotEmpty;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController()..text = widget.imageLink.url ?? '';
    _urlIsNotEmpty = ValueNotifier(_isNotEmpty);
    _urlController.addListener(_emptyListener);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _urlController,
        decoration: InputDecoration(labelText: widget.urlLabel),
        autofocus: true,
        // onChanged: _urlChanged,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _urlIsNotEmpty,
          builder: (context, hasLink, _) {
            return TextButton(
              onPressed: hasLink ? _applyUrl : null,
              child: Text(widget.acceptLabel),
            );
          },
        ),
      ],
    );
  }

  void _applyUrl() {
    if (!_urlController.text.startsWith('https://')) {
      _urlController.text = 'https://' + _urlController.text;
    }
    Navigator.of(context).pop(ImageLink(_urlController.text));
  }

  @override
  void dispose() {
    _urlIsNotEmpty.dispose();
    _urlController.removeListener(_emptyListener);
    _urlController.dispose();
    super.dispose();
  }
}