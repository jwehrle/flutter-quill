import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/models/toggles/toggle.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/utils/insert.dart';

/// Listens to QuillController, filters out relevant aspects, and propagates
/// those changes to onChanged
abstract class QuillButtonController<T> {
  QuillButtonController(this.controller) {
    controller.addListener(controllerListener);
  }

  final QuillController controller;

  T get data;

  void onChanged(T data);

  void controllerListener() => onChanged(data);

  @mustCallSuper
  void dispose() {
    controller.removeListener(controllerListener);
  }
}

/// Translates QuillController to bold, strike, under, italic
class StyleController extends QuillButtonController<Set<String>> {
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

/// Translates QuillController to bullet and number
class ListController extends QuillButtonController<Set<String>> {
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

/// Translates QuillController to quote and code
class BlockController extends QuillButtonController<Set<String>> {
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

/// Translates QuillController to link and image
class InsertController extends QuillButtonController<InsertData> {
  InsertController(QuillController controller) : super(controller) {
    _linkStateNotifier = ValueNotifier(ToggleState.disabled);
    _imageStateNotifier = ValueNotifier(ToggleState.disabled);
  }

  static final Set<String> _quoteCodeAttrs = Set.unmodifiable({
    Attribute.blockQuote.key,
    Attribute.codeBlock.key,
  });

  late final ValueNotifier<ToggleState> _linkStateNotifier;
  ValueListenable<ToggleState> get linkListenable => _linkStateNotifier;
  ToggleState get link => linkListenable.value;

  late final ValueNotifier<ToggleState> _imageStateNotifier;
  ValueListenable<ToggleState> get imageListenable => _imageStateNotifier;
  ToggleState get image => imageListenable.value;

  @override
  InsertData get data {
    Set<String> attrSet = {};
    final Style style = controller.getSelectionStyle();
    attrSet.addAll(style.attributes.keys
        .where((attrKey) => _quoteCodeAttrs.contains(attrKey)));
    return InsertData(
      isCollapsed: controller.selection.isCollapsed,
      canEmbedImage: attrSet.intersection(_quoteCodeAttrs).isEmpty,
    );
  }

  @override
  void onChanged(InsertData data) {
    _linkStateNotifier.value =
        data.isCollapsed ? ToggleState.disabled : ToggleState.off;
    _imageStateNotifier.value =
        data.canEmbedImage ? ToggleState.off : ToggleState.disabled;
  }

  @override
  void dispose() {
    _linkStateNotifier.dispose();
    _imageStateNotifier.dispose();
    super.dispose();
  }
}

/// Translates QuillController to size
class SizeController extends QuillButtonController<Attribute?> {
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

/// Translates QuillController to indent
class IndentController extends QuillButtonController<Attribute?> {
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

/// Translates QuillController to align
class AlignController extends QuillButtonController<Attribute?> {
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
