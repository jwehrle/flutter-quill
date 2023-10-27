import 'package:flutter/foundation.dart';
import 'package:flutter_quill/controllers/buttons/quill_item_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/models/toggles/toggle.dart';

/// Translates QuillController to quote and code
class BlockController extends QuillItemController<Set<String>> {
  BlockController(QuillController controller) : super(controller) {
    _quoteStateNotifier = ValueNotifier(data.contains(Attribute.blockQuote.key)
        ? ToggleState.on
        : ToggleState.off);
    _codeStateNotifier = ValueNotifier(data.contains(Attribute.codeBlock.key)
        ? ToggleState.on
        : ToggleState.off);
  }

  static final Set<String> _quoteCodeAttrs = Set.unmodifiable({
    Attribute.blockQuote.key,
    Attribute.codeBlock.key,
  });

  late final ValueNotifier<ToggleState> _quoteStateNotifier;
  ValueListenable<ToggleState> get quoteListenable => _quoteStateNotifier;
  ToggleState get quote => quoteListenable.value;

  late final ValueNotifier<ToggleState> _codeStateNotifier;
  ValueListenable<ToggleState> get codeListenable => _codeStateNotifier;
  ToggleState get code => codeListenable.value;

  @override
  Set<String> get data {
    Set<String> attrSet = {};
    final Style style = controller.getSelectionStyle();
    attrSet.addAll(style.attributes.keys
        .where((attrKey) => _quoteCodeAttrs.contains(attrKey)));
    return attrSet;
  }

  @override
  void onChanged(Set<String> data) {
    _quoteStateNotifier.value = data.contains(Attribute.blockQuote.key)
        ? ToggleState.on
        : ToggleState.off;
    _codeStateNotifier.value = data.contains(Attribute.codeBlock.key)
        ? ToggleState.on
        : ToggleState.off;
  }

  @override
  void dispose() {
    _quoteStateNotifier.dispose();
    _codeStateNotifier.dispose();
    super.dispose();
  }
}