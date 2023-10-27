import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/controllers/buttons/quill_item_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/nodes/embeddable.dart';
import 'package:flutter_quill/models/toggles/toggle.dart';
import 'package:flutter_quill/utils/insert.dart';
import 'package:flutter_quill/widgets/editor/link.dart';

/// Contains information about text URL.
class TextLink {
  final String text;
  final String? link;

  TextLink(
    this.text,
    this.link,
  );

  static TextLink prepare(QuillController controller) {
    final link =
        controller.getSelectionStyle().attributes[Attribute.link.key]?.value;
    final index = controller.selection.start;

    var text;
    if (link != null) {
      // text should be the link's corresponding text, not selection
      final leaf = controller.document.querySegmentLeafNode(index).leaf;
      if (leaf != null) {
        text = leaf.toPlainText();
      }
    }

    final len = controller.selection.end - index;
    text ??= len == 0 ? '' : controller.document.getPlainText(index, len);

    return TextLink(text, link);
  }

  void submit(QuillController controller) {
    var index = controller.selection.start;
    var length = controller.selection.end - index;
    final linkValue =
        controller.getSelectionStyle().attributes[Attribute.link.key]?.value;

    if (linkValue != null) {
      // text should be the link's corresponding text, not selection
      final leaf = controller.document.querySegmentLeafNode(index).leaf;
      if (leaf != null) {
        final range = getLinkRange(leaf);
        index = range.start;
        length = range.end - range.start;
      }
    }
    controller
      ..replaceText(index, length, text, null)
      ..formatText(index, text.length, LinkAttribute(link));
  }
}

class ImageLink {
  final String? url;

  ImageLink(this.url);

  static bool _isImageOp(op) =>
      op.data is Map && (op.data as Map).containsKey(Attribute.image.key);

  static ImageLink prepare(QuillController controller) {
    String? link;

    // Image urls are stored in node data, so get the current node
    final node =
        controller.document.queryChild(controller.selection.baseOffset).node;
    if (node == null) {
      return ImageLink(null);
    }

    // Pull the first, if any, image url from node operations
    final op = node.toDelta().toList().firstWhereOrNull(_isImageOp);
    if (op == null) {
      return ImageLink(null);
    }
    link = (op.data as Map)[Attribute.image.key];

    return ImageLink(link);
  }

  void submit(QuillController controller) {
    if (url == null) {
      return;
    }
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;
    controller.replaceText(
      index,
      length,
      BlockEmbed.image(url!),
      null,
    );
  }
}

/// Translates QuillController to link and image
class InsertController extends QuillItemController<InsertData> {
  InsertController(QuillController controller) : super(controller) {
    _linkStateNotifier = ValueNotifier(ToggleState.off);
    _imageStateNotifier = ValueNotifier(ToggleState.disabled);
  }

  late final ValueNotifier<ToggleState> _linkStateNotifier;
  ValueListenable<ToggleState> get linkListenable => _linkStateNotifier;
  ToggleState get link => linkListenable.value;

  late final ValueNotifier<ToggleState> _imageStateNotifier;
  ValueListenable<ToggleState> get imageListenable => _imageStateNotifier;
  ToggleState get image => imageListenable.value;

  set toggleLink(ToggleState state) => _linkStateNotifier.value = state;

  @override
  InsertData get data {
    final attributes = controller.getSelectionStyle().attributes;
    return InsertData(
      isBlockQuote: attributes.containsKey(Attribute.blockQuote.key),
      isCodeBlock: attributes.containsKey(Attribute.codeBlock.key),
      isLink: attributes.containsKey(Attribute.link.key),
      isImage: !controller.selection.isCollapsed && (attributes.containsKey(Attribute.image.key) || attributes.containsKey(Attribute.width.key)),
    );
  }

  @override
  void onChanged(InsertData data) {
    _linkStateNotifier.value =
        data.isBlock ? ToggleState.disabled : data.isLink ? ToggleState.on : ToggleState.off;
    _imageStateNotifier.value =
        data.isBlock ? ToggleState.disabled : data.isImage ? ToggleState.on : ToggleState.off;
  }

  @override
  void dispose() {
    _linkStateNotifier.dispose();
    _imageStateNotifier.dispose();
    super.dispose();
  }
}