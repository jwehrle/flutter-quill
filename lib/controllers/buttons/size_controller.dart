import 'package:flutter/foundation.dart';
import 'package:flutter_quill/controllers/buttons/quill_item_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';

/// Translates QuillController to size
class SizeController extends QuillItemController<Attribute?> {
  SizeController(QuillController controller) : super(controller) {
    _sizeNotifier = ValueNotifier(data);
  }

  late final ValueNotifier<Attribute?> _sizeNotifier;
  ValueListenable<Attribute?> get sizeListenable => _sizeNotifier;
  Attribute? get size => sizeListenable.value;

  @override
  Attribute? get data =>
      controller.getSelectionStyle().attributes[Attribute.header.key] ??
      Attribute.header;

  @override
  void onChanged(Attribute? data) => _sizeNotifier.value = data;

  @override
  void dispose() {
    _sizeNotifier.dispose();
    super.dispose();
  }
}