import 'package:flutter/foundation.dart';
import 'package:flutter_quill/controllers/buttons/quill_item_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';

/// Translates QuillController to indent
class IndentController extends QuillItemController<Attribute?> {
  IndentController(QuillController controller) : super(controller) {
    _indentNotifier = ValueNotifier(data);
  }

  late final ValueNotifier<Attribute?> _indentNotifier;
  ValueListenable<Attribute?> get indentListenable => _indentNotifier;
  Attribute? get indent => indentListenable.value;

  @override
  Attribute? get data =>
      controller.getSelectionStyle().attributes[Attribute.indent.key] ??
      Attribute.indent;

  @override
  void onChanged(Attribute? data) => _indentNotifier.value = data;

  @override
  void dispose() {
    _indentNotifier.dispose();
    super.dispose();
  }
}