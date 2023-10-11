import 'dart:math';

import 'package:flutter_quill/models/documents/nodes/leaf.dart';
import 'package:flutter_quill/models/structs/offset_value.dart';
import 'package:flutter_quill/controllers/controller.dart';

OffsetValue<Embed> getEmbedNode(QuillController controller, int offset) {
  var offset = controller.selection.start;
  var embedNode = controller.queryNode(offset);
  if (embedNode == null || !(embedNode is Embed)) {
    offset = max(0, offset - 1);
    embedNode = controller.queryNode(offset);
  }
  if (embedNode != null && embedNode is Embed) {
    return OffsetValue(offset, embedNode);
  }

  return throw 'Embed node not found by offset $offset';
}