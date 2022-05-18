import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/models/constants.dart';

final Set<String> _inlineAttrs = Set.unmodifiable({
  Attribute.bold.key!,
  Attribute.italic.key!,
  Attribute.strikeThrough.key!,
  Attribute.underline.key!,
});

final Set<String> _quoteCodeAttrs = Set.unmodifiable({
  Attribute.blockQuote.key!,
  Attribute.codeBlock.key!,
});

final Set<String> _blockAttrs = Set.unmodifiable({
  Attribute.ol.value!,
  Attribute.ul.value!,
});

class _ControllerData {
  final Set<String> toggledAttrSet;
  final Attribute? sizeAttribute;
  final Attribute? indentAttribute;
  final Attribute? alignmentAttribute;
  final bool isCollapsed;
  final bool canEmbedImage;

  _ControllerData({
    required this.toggledAttrSet,
    required this.sizeAttribute,
    required this.indentAttribute,
    required this.alignmentAttribute,
    required this.isCollapsed,
    required this.canEmbedImage,
  });
}

class ControllerUtility {
  final QuillController controller;

  ControllerUtility({required this.controller}) {
    _ControllerData data = _controllerData;
    _boldStateNotifier = ValueNotifier(
        data.toggledAttrSet.contains(Attribute.bold.key!)
            ? ToggleState.on
            : ToggleState.off);
    _strikeStateNotifier = ValueNotifier(
        data.toggledAttrSet.contains(Attribute.strikeThrough.key!)
            ? ToggleState.on
            : ToggleState.off);
    _underStateNotifier = ValueNotifier(
        data.toggledAttrSet.contains(Attribute.underline.key!)
            ? ToggleState.on
            : ToggleState.off);
    _italicStateNotifier = ValueNotifier(
        data.toggledAttrSet.contains(Attribute.italic.key!)
            ? ToggleState.on
            : ToggleState.off);
    _quoteStateNotifier = ValueNotifier(
        data.toggledAttrSet.contains(Attribute.blockQuote.key!)
            ? ToggleState.on
            : ToggleState.off);
    _codeStateNotifier = ValueNotifier(
        data.toggledAttrSet.contains(Attribute.codeBlock.key!)
            ? ToggleState.on
            : ToggleState.off);
    _bulletStateNotifier = ValueNotifier(
        data.toggledAttrSet.contains(Attribute.ul.value!)
            ? ToggleState.on
            : ToggleState.off);
    _numberStateNotifier = ValueNotifier(
        data.toggledAttrSet.contains(Attribute.ol.value!)
            ? ToggleState.on
            : ToggleState.off);
    _sizeNotifier = ValueNotifier(data.sizeAttribute);
    _indentNotifier = ValueNotifier(data.indentAttribute);
    _alignmentNotifier = ValueNotifier(data.alignmentAttribute);
    _linkStateNotifier = ValueNotifier(ToggleState.disabled);
    _imageStateNotifier = ValueNotifier(ToggleState.disabled);
    controller.addListener(_controllerListener);
  }

  /// ToggleState Notifiers
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

  late final ValueNotifier<ToggleState> _quoteStateNotifier;
  ValueListenable<ToggleState> get quoteListenable => _quoteStateNotifier;
  ToggleState get quote => quoteListenable.value;

  late final ValueNotifier<ToggleState> _codeStateNotifier;
  ValueListenable<ToggleState> get codeListenable => _codeStateNotifier;
  ToggleState get code => codeListenable.value;

  late final ValueNotifier<ToggleState> _numberStateNotifier;
  ValueListenable<ToggleState> get numberListenable => _numberStateNotifier;
  ToggleState get number => numberListenable.value;

  late final ValueNotifier<ToggleState> _bulletStateNotifier;
  ValueListenable<ToggleState> get bulletListenable => _bulletStateNotifier;
  ToggleState get bullet => bulletListenable.value;

  late final ValueNotifier<ToggleState> _linkStateNotifier;
  ValueListenable<ToggleState> get linkListenable => _linkStateNotifier;
  ToggleState get link => linkListenable.value;

  late final ValueNotifier<ToggleState> _imageStateNotifier;
  ValueListenable<ToggleState> get imageListenable => _imageStateNotifier;
  ToggleState get image => imageListenable.value;

  late final ValueNotifier<Attribute?> _sizeNotifier;
  ValueListenable<Attribute?> get sizeListenable => _sizeNotifier;
  Attribute? get size => sizeListenable.value;

  late final ValueNotifier<Attribute?> _indentNotifier;
  ValueListenable<Attribute?> get indentListenable => _indentNotifier;
  Attribute? get indent => indentListenable.value;

  late final ValueNotifier<Attribute?> _alignmentNotifier;
  ValueListenable<Attribute?> get alignmentListenable => _alignmentNotifier;
  Attribute? get alignment => alignmentListenable.value;

  void formatSelection(Attribute<dynamic> attribute) {
    controller.formatSelection(attribute);
  }

  TextSelection get selection => controller.selection;
  set selection(TextSelection value) => controller.selection = value;

  _ControllerData get _controllerData {
    Set<String> attrSet = {};
    final Style style = controller.getSelectionStyle();
    TextSelection selection = controller.selection;
    if (selection.isCollapsed) {
      int cursorPos = selection.start;
      if (cursorPos > 0) {
        Style prevStyle = controller.getStyleAt(cursorPos - 1);
        attrSet.addAll(prevStyle.attributes.keys
            .where((attrKey) => _inlineAttrs.contains(attrKey)));
      } else {
        final Style curStyle = controller.getStyleAt(cursorPos);
        attrSet.addAll(curStyle.attributes.keys
            .where((attrKey) => _inlineAttrs.contains(attrKey)));
      }
    } else {
      attrSet.addAll(style.attributes.keys
          .where((attrKey) => _inlineAttrs.contains(attrKey)));
    }
    attrSet.addAll(style.attributes.keys
        .where((attrKey) => _quoteCodeAttrs.contains(attrKey)));
    attrSet.addAll(style.attributes.values
        .where((attr) => _blockAttrs.contains(attr.value))
        .map((attr) => attr.value));
    return _ControllerData(
      toggledAttrSet: attrSet,
      isCollapsed: selection.isCollapsed,
      canEmbedImage: attrSet.intersection(_quoteCodeAttrs).isEmpty,
      sizeAttribute: style.attributes[Attribute.header.key!],
      indentAttribute: style.attributes[Attribute.indent.key!],
      alignmentAttribute: style.attributes[Attribute.align.key!],
    );
  }

  void _controllerListener() {
    final data = _controllerData;
    _boldStateNotifier.value = data.toggledAttrSet.contains(Attribute.bold.key!)
        ? ToggleState.on
        : ToggleState.off;
    _strikeStateNotifier.value =
        data.toggledAttrSet.contains(Attribute.strikeThrough.key!)
            ? ToggleState.on
            : ToggleState.off;
    _underStateNotifier.value =
        data.toggledAttrSet.contains(Attribute.underline.key!)
            ? ToggleState.on
            : ToggleState.off;
    _italicStateNotifier.value =
        data.toggledAttrSet.contains(Attribute.italic.key!)
            ? ToggleState.on
            : ToggleState.off;
    _quoteStateNotifier.value =
        data.toggledAttrSet.contains(Attribute.blockQuote.key!)
            ? ToggleState.on
            : ToggleState.off;
    _codeStateNotifier.value =
        data.toggledAttrSet.contains(Attribute.codeBlock.key!)
            ? ToggleState.on
            : ToggleState.off;
    _bulletStateNotifier.value =
        data.toggledAttrSet.contains(Attribute.ul.value!)
            ? ToggleState.on
            : ToggleState.off;
    _numberStateNotifier.value =
        data.toggledAttrSet.contains(Attribute.ol.value!)
            ? ToggleState.on
            : ToggleState.off;
    _sizeNotifier.value = data.sizeAttribute;
    _indentNotifier.value = data.indentAttribute;
    _alignmentNotifier.value = data.alignmentAttribute;
    _linkStateNotifier.value =
        data.isCollapsed ? ToggleState.disabled : ToggleState.off;
    _imageStateNotifier.value =
        data.canEmbedImage ? ToggleState.off : ToggleState.disabled;
  }

  void dispose() {
    controller.removeListener(_controllerListener);
    _boldStateNotifier.dispose();
    _italicStateNotifier.dispose();
    _underStateNotifier.dispose();
    _strikeStateNotifier.dispose();
    _quoteStateNotifier.dispose();
    _codeStateNotifier.dispose();
    _numberStateNotifier.dispose();
    _bulletStateNotifier.dispose();
    _alignmentNotifier.dispose();
    _linkStateNotifier.dispose();
    _imageStateNotifier.dispose();
  }
}
