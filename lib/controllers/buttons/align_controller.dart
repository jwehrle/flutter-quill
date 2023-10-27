import 'package:flutter/foundation.dart';
import 'package:flutter_quill/controllers/buttons/quill_item_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';

/// Translates QuillController states to Alignment attribue states
class AlignController extends QuillItemController<Attribute?> {
  AlignController(QuillController controller) : super(controller) {
    _alignmentNotifier = ValueNotifier(data);
  }

  late final ValueNotifier<Attribute?> _alignmentNotifier;
  ValueListenable<Attribute?> get alignmentListenable => _alignmentNotifier;
  Attribute? get alignment => alignmentListenable.value;

  @override
  Attribute? get data =>
      controller.getSelectionStyle().attributes[Attribute.align.key];

  @override
  void onChanged(Attribute? data) => _alignmentNotifier.value = data;

  @override
  dispose() {
    _alignmentNotifier.dispose();
    super.dispose();
  }
}
