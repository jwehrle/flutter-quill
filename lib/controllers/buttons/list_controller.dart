import 'package:flutter/foundation.dart';
import 'package:flutter_quill/controllers/buttons/quill_item_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/models/toggles/toggle.dart';

/// Translates QuillController to bullet and number
class ListController extends QuillItemController<Set<String>> {
  ListController(QuillController controller) : super(controller) {
    _bulletStateNotifier = ValueNotifier(
        data.contains(Attribute.ul.value!) ? ToggleState.on : ToggleState.off);
    _numberStateNotifier = ValueNotifier(
        data.contains(Attribute.ol.value!) ? ToggleState.on : ToggleState.off);
  }

  static final Set<String> _listAttrs = Set.unmodifiable({
    Attribute.ol.value!,
    Attribute.ul.value!,
  });

  late final ValueNotifier<ToggleState> _numberStateNotifier;
  ValueListenable<ToggleState> get numberListenable => _numberStateNotifier;
  ToggleState get number => numberListenable.value;

  late final ValueNotifier<ToggleState> _bulletStateNotifier;
  ValueListenable<ToggleState> get bulletListenable => _bulletStateNotifier;
  ToggleState get bullet => bulletListenable.value;

  @override
  Set<String> get data {
    Set<String> attrSet = {};
    final Style style = controller.getSelectionStyle();
    attrSet.addAll(style.attributes.values
        .where((attr) => _listAttrs.contains(attr.value))
        .map((attr) => attr.value));
    return attrSet;
  }

  @override
  void onChanged(Set<String> data) {
    _bulletStateNotifier.value =
        data.contains(Attribute.ul.value!) ? ToggleState.on : ToggleState.off;
    _numberStateNotifier.value =
        data.contains(Attribute.ol.value!) ? ToggleState.on : ToggleState.off;
  }

  @override
  void dispose() {
    _bulletStateNotifier.dispose();
    _numberStateNotifier.dispose();
    super.dispose();
  }
}