import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/models/types.dart';

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

  _ControllerData({
    required this.toggledAttrSet,
    required this.sizeAttribute,
    required this.indentAttribute,
    required this.alignmentAttribute,
    required this.isCollapsed,
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
    _linkStateNotifier = ValueNotifier(
        data.isCollapsed ? ToggleState.disabled : ToggleState.off);
    controller.addListener(_controllerListener);
  }

  // Attribute Notifiers
  late final ValueNotifier<Attribute?> _sizeNotifier;
  late final ValueNotifier<Attribute?> _indentNotifier;
  late final ValueNotifier<Attribute?> _alignmentNotifier;

  ValueNotifier<Attribute?> popupScalarNotifier(PopupScalarType type) {
    switch (type) {
      case PopupScalarType.centerAlign:
        return _alignmentNotifier;
      case PopupScalarType.indentMinus:
        return _indentNotifier;
      case PopupScalarType.indentPlus:
        return _indentNotifier;
      case PopupScalarType.justifyAlign:
        return _alignmentNotifier;
      case PopupScalarType.leftAlign:
        return _alignmentNotifier;
      case PopupScalarType.rightAlign:
        return _alignmentNotifier;
      case PopupScalarType.sizeMinus:
        return _sizeNotifier;
      case PopupScalarType.sizePlus:
        return _sizeNotifier;
    }
  }

  // ToggleState Notifiers
  late final ValueNotifier<ToggleState> _boldStateNotifier;
  late final ValueNotifier<ToggleState> _italicStateNotifier;
  late final ValueNotifier<ToggleState> _underStateNotifier;
  late final ValueNotifier<ToggleState> _strikeStateNotifier;
  late final ValueNotifier<ToggleState> _quoteStateNotifier;
  late final ValueNotifier<ToggleState> _codeStateNotifier;
  late final ValueNotifier<ToggleState> _numberStateNotifier;
  late final ValueNotifier<ToggleState> _bulletStateNotifier;
  late final ValueNotifier<ToggleState> _linkStateNotifier;

  ValueNotifier<ToggleState> toolbarToggleNotifier(ToolbarToggleType type) {
    switch (type) {
      case ToolbarToggleType.bold:
        return _boldStateNotifier;
      case ToolbarToggleType.italic:
        return _italicStateNotifier;
      case ToolbarToggleType.under:
        return _underStateNotifier;
      case ToolbarToggleType.strike:
        return _strikeStateNotifier;
      case ToolbarToggleType.bullet:
        return _bulletStateNotifier;
      case ToolbarToggleType.number:
        return _numberStateNotifier;
      case ToolbarToggleType.quote:
        return _quoteStateNotifier;
      case ToolbarToggleType.code:
        return _codeStateNotifier;
      case ToolbarToggleType.link:
        return _linkStateNotifier;
    }
  }

  ValueNotifier<ToggleState> popupToggleNotifier(PopupToggleType type) {
    switch (type) {
      case PopupToggleType.bold:
        return _boldStateNotifier;
      case PopupToggleType.bullet:
        return _bulletStateNotifier;
      case PopupToggleType.code:
        return _codeStateNotifier;
      case PopupToggleType.italic:
        return _italicStateNotifier;
      case PopupToggleType.number:
        return _numberStateNotifier;
      case PopupToggleType.quote:
        return _quoteStateNotifier;
      case PopupToggleType.strike:
        return _strikeStateNotifier;
      case PopupToggleType.under:
        return _underStateNotifier;
    }
  }

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
  }
}
