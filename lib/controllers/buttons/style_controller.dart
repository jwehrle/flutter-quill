import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/buttons/quill_item_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/models/toggles/toggle.dart';

/// Translates QuillController to bold, strike, under, italic
class StyleController extends QuillItemController<Set<String>> {
  StyleController(QuillController controller) : super(controller) {
    _boldStateNotifier = ValueNotifier(
        data.contains(Attribute.bold.key) ? ToggleState.on : ToggleState.off);
    _strikeStateNotifier = ValueNotifier(
        data.contains(Attribute.strikeThrough.key)
            ? ToggleState.on
            : ToggleState.off);
    _underStateNotifier = ValueNotifier(data.contains(Attribute.underline.key)
        ? ToggleState.on
        : ToggleState.off);
    _italicStateNotifier = ValueNotifier(
        data.contains(Attribute.italic.key) ? ToggleState.on : ToggleState.off);
  }

  static final Set<String> _styleAttrs = Set.unmodifiable({
    Attribute.bold.key,
    Attribute.italic.key,
    Attribute.strikeThrough.key,
    Attribute.underline.key,
  });

  late final ValueNotifier<ToggleState> _boldStateNotifier;
  ValueListenable<ToggleState> get boldListenable => _boldStateNotifier;
  ToggleState get bold => boldListenable.value;

  late final ValueNotifier<ToggleState> _italicStateNotifier;
  ValueListenable<ToggleState> get italicListenable => _italicStateNotifier;
  ToggleState get italic => italicListenable.value;

  late final ValueNotifier<ToggleState> _underStateNotifier;
  ValueListenable<ToggleState> get underListenable => _underStateNotifier;
  ToggleState get under => underListenable.value;

  late final ValueNotifier<ToggleState> _strikeStateNotifier;
  ValueListenable<ToggleState> get strikeListenable => _strikeStateNotifier;
  ToggleState get strike => strikeListenable.value;

  @override
  Set<String> get data {
    Set<String> attrSet = {};
    final Style style = controller.getSelectionStyle();
    TextSelection selection = controller.selection;
    if (selection.isCollapsed) {
      int cursorPos = selection.start;
      if (cursorPos > 0) {
        Style prevStyle = controller.getStyleAt(cursorPos - 1);
        attrSet.addAll(prevStyle.attributes.keys
            .where((attrKey) => _styleAttrs.contains(attrKey)));
      } else {
        final Style curStyle = controller.getStyleAt(cursorPos);
        attrSet.addAll(curStyle.attributes.keys
            .where((attrKey) => _styleAttrs.contains(attrKey)));
      }
    } else {
      attrSet.addAll(style.attributes.keys
          .where((attrKey) => _styleAttrs.contains(attrKey)));
    }
    return attrSet;
  }

  @override
  void onChanged(Set<String> data) {
    _boldStateNotifier.value =
        data.contains(Attribute.bold.key) ? ToggleState.on : ToggleState.off;
    _strikeStateNotifier.value = data.contains(Attribute.strikeThrough.key)
        ? ToggleState.on
        : ToggleState.off;
    _underStateNotifier.value = data.contains(Attribute.underline.key)
        ? ToggleState.on
        : ToggleState.off;
    _italicStateNotifier.value =
        data.contains(Attribute.italic.key) ? ToggleState.on : ToggleState.off;
  }

  @override
  void dispose() {
    _boldStateNotifier.dispose();
    _italicStateNotifier.dispose();
    _underStateNotifier.dispose();
    _strikeStateNotifier.dispose();
    super.dispose();
  }
}