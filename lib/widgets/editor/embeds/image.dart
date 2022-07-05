import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/nodes/leaf.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/controllers/controller.dart';

const List<String> imageFileExtensions = [
  '.jpeg',
  '.png',
  '.jpg',
  '.gif',
  '.webp',
  '.tif',
  '.heic'
];

RegExp _base64 = RegExp(
    r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');

bool isImageBase64(String imageUrl) {
  return !imageUrl.startsWith('http') && _base64.hasMatch(imageUrl);
}

Tuple2<int, Embed> getImageNode(QuillController controller, int offset) {
  var offset = controller.selection.start;
  var imageNode = controller.queryNode(offset);
  if (imageNode == null || !(imageNode is Embed)) {
    offset = max(0, offset - 1);
    imageNode = controller.queryNode(offset);
  }
  if (imageNode != null && imageNode is Embed) {
    return Tuple2(offset, imageNode);
  }

  return throw 'Image node not found by offset $offset';
}

String getImageStyleString(QuillController controller) {
  final String? s = controller
      .getAllSelectionStyles()
      .firstWhere((s) => s.attributes.containsKey(Attribute.style.key),
          orElse: () => Style())
      .attributes[Attribute.style.key]
      ?.value;
  return s ?? '';
}

Image? imageByUrl(
  String imageUrl, {
  double? width,
  double? height,
  AlignmentGeometry alignment = Alignment.center,
}) {
  if (isImageBase64(imageUrl)) {
    return Image.memory(base64.decode(imageUrl),
        width: width, height: height, alignment: alignment);
  }

  if (imageUrl.startsWith('http')) {
    return Image.network(imageUrl,
        width: width, height: height, alignment: alignment);
  }
  return null;
}

String standardizeImageUrl(String url) {
  if (url.contains('base64')) {
    return url.split(',')[1];
  }
  return url;
}
