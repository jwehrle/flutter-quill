import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';

import 'package:flutter_quill/models/documents/nodes/leaf.dart' as leaf;
import 'package:flutter_quill/models/themes/quill_dialog_theme.dart';
import 'package:flutter_quill/models/themes/quill_icon_theme.dart';
import 'package:flutter_quill/controllers/controller.dart';

abstract class EmbedBuilder {
  const EmbedBuilder();

  String get key;

  bool get expanded => true;

  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: widget);
  }

  Widget build(
    BuildContext context,
    QuillController controller,
    leaf.Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  );
}

typedef EmbedButtonBuilder = Widget Function(
    QuillController controller,
    double toolbarIconSize,
    QuillIconTheme? iconTheme,
    QuillDialogTheme? dialogTheme);

RegExp _base64 = RegExp(
    r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');

bool isImageBase64(String imageUrl) {
  return !imageUrl.startsWith('http') && _base64.hasMatch(imageUrl);
}

const List<String> imageFileExtensions = [
  '.jpeg',
  '.png',
  '.jpg',
  '.gif',
  '.webp',
  '.tif',
  '.heic'
];

Image imageByUrl(String imageUrl,
    {double? width,
      double? height,
      AlignmentGeometry alignment = Alignment.center}) {
  if (isImageBase64(imageUrl)) {
    return Image.memory(base64.decode(imageUrl),
        width: width, height: height, alignment: alignment);
  }

  if (imageUrl.startsWith('http')) {
    return Image.network(imageUrl,
        width: width, height: height, alignment: alignment);
  }
  return Image.file(io.File(imageUrl),
      width: width, height: height, alignment: alignment);
}

String standardizeImageUrl(String url) {
  if (url.contains('base64')) {
    return url.split(',')[1];
  }
  return url;
}

// todo implement the most basic image widget builder possible. Use old code as inspiration
class ImageEmbedBuilder extends EmbedBuilder {

  const ImageEmbedBuilder();

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    leaf.Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return imageByUrl(standardizeImageUrl(node.value.data));
  }

  @override
  String get key => "image";
}
