import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/widgets/tiles.dart';
import 'package:flutter_quill/widgets/toolbar/models/constants.dart';
import 'package:flutter_quill/widgets/toolbar/models/types.dart';
import 'package:mdi/mdi.dart';

String _popItemKey(PopType type) {
  switch (type) {
    case PopType.block:
      return kBlockItemKey;
    case PopType.indent:
      return kIndentItemKey;
    case PopType.list:
      return kListItemKey;
    case PopType.size:
      return kSizeItemKey;
    case PopType.style:
      return kStyleItemKey;
  }
}

String _noPopItemKey(NoPopType type) {
  switch (type) {
    case NoPopType.bold:
      return kBoldItemKey;
    case NoPopType.italic:
      return kItalicItemKey;
    case NoPopType.under:
      return kUnderItemKey;
    case NoPopType.strike:
      return kStrikeItemKey;
    case NoPopType.bullet:
      return kBulletItemKey;
    case NoPopType.number:
      return kNumberItemKey;
    case NoPopType.quote:
      return kQuoteItemKey;
    case NoPopType.code:
      return kCodeItemKey;
    case NoPopType.link:
      return kLinkItemKey;
  }
}

final Set<String> _inlineAttrs = Set.unmodifiable({
  Attribute.bold.key!,
  Attribute.italic.key!,
  Attribute.strikeThrough.key!,
  Attribute.underline.key!,
});

final Set<String> _blockAttrs = Set.unmodifiable({
  Attribute.blockQuote.key!,
  Attribute.codeBlock.key!,
});

/// h1 > h2 > h3 > header
Attribute? _incrementSize(Attribute? attribute) {
  if (attribute == null) {
    attribute = Attribute.header;
  }
  if (attribute == Attribute.h1) {
    return null;
  }
  if (attribute == Attribute.h2) {
    return Attribute.h1;
  }
  if (attribute == Attribute.h3) {
    return Attribute.h2;
  }
  if (attribute == Attribute.header) {
    return Attribute.h3;
  }
}

/// header < h3 < h2 < h1
Attribute? _decrementSize(Attribute? attribute) {
  if (attribute == null) {
    attribute = Attribute.header;
  }
  if (attribute == Attribute.header) {
    return null;
  }
  if (attribute == Attribute.h1) {
    return Attribute.h2;
  }
  if (attribute == Attribute.h2) {
    return Attribute.h3;
  }
  if (attribute == Attribute.h3) {
    return Attribute.header;
  }
}

/// indentL3 > indentL2 > indentL1
Attribute? _incrementIndent(Attribute? attribute) {
  if (attribute == null) {
    return Attribute.indentL1;
  }
  if (attribute == Attribute.indentL3) {
    return null;
  }
  return Attribute.getIndentLevel(attribute.value + 1);
}

/// indentL1 < indentL2 < indentL3
Attribute? _decrementIndent(Attribute? attribute) {
  if (attribute == null) {
    return null;
  }
  if (attribute == Attribute.indentL1) {
    return Attribute.clone(Attribute.indentL1, null);
  }
  return Attribute.getIndentLevel(attribute.value - 1);
}

class _LinkDialog extends StatefulWidget {
  const _LinkDialog({Key? key}) : super(key: key);

  @override
  _LinkDialogState createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  String _link = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        decoration: InputDecoration(labelText: 'Paste a link'),
        autofocus: true,
        onChanged: _linkChanged,
      ),
      actions: [
        TextButton(
          onPressed: _link.isNotEmpty ? _applyLink : null,
          child: Text('Apply'),
        ),
      ],
    );
  }

  void _linkChanged(String value) {
    setState(() {
      _link = value;
    });
  }

  void _applyLink() {
    Navigator.pop(context, _link);
  }
}

class _ControllerData {
  final Set<String> toggledAttrSet;
  final Attribute? sizeAttribute;
  final Attribute? indentAttribute;
  final bool isCollapsed;

  _ControllerData({
    required this.toggledAttrSet,
    required this.sizeAttribute,
    required this.indentAttribute,
    required this.isCollapsed,
  });
}

class RichTextToolbar extends StatefulWidget {
  final RichTextToolbarType toolbarType;
  final QuillController controller;
  final ToolbarData toolbarData;
  final ButtonStyling toolbarButtonStyling;
  final ButtonStyling popupButtonStyling;
  final OptionButtonData? optionButtonParameters;

  const RichTextToolbar({
    Key? key,
    required this.toolbarType,
    required this.controller,
    required this.toolbarData,
    required this.toolbarButtonStyling,
    required this.popupButtonStyling,
    this.optionButtonParameters,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => RichTextToolbarState();
}

class RichTextToolbarState extends State<RichTextToolbar> {
  // Attribute Notifiers
  late final ValueNotifier<Attribute?> _sizeNotifier;
  late final ValueNotifier<Attribute?> _indentNotifier;

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

  _toggleAttribute(
    ValueNotifier<ToggleState> stateNotifier,
    Attribute attribute,
  ) {
    switch (stateNotifier.value) {
      case ToggleState.on:
        widget.controller.formatSelection(Attribute.clone(attribute, null));
        stateNotifier.value = ToggleState.off;
        break;
      case ToggleState.off:
        widget.controller.formatSelection(attribute);
        stateNotifier.value = ToggleState.on;
        break;
      case ToggleState.disabled:
        break;
    }
  }

  _ControllerData get _controllerData {
    Set<String> attrSet = {};
    final Style blockStyle = widget.controller.getSelectionStyle();
    TextSelection selection = widget.controller.selection;
    if (selection.isCollapsed) {
      int cursorPos = selection.start;
      if (cursorPos > 0) {
        Style prevStyle = widget.controller.getStyleAt(cursorPos - 1);
        attrSet.addAll(prevStyle.attributes.keys
            .where((attrKey) => _inlineAttrs.contains(attrKey)));
      } else {
        final Style curStyle = widget.controller.getStyleAt(cursorPos);
        attrSet.addAll(curStyle.attributes.keys
            .where((attrKey) => _inlineAttrs.contains(attrKey)));
      }
    } else {
      attrSet.addAll(blockStyle.attributes.keys
          .where((attrKey) => _inlineAttrs.contains(attrKey)));
    }
    attrSet.addAll(blockStyle.attributes.keys
        .where((attrKey) => _blockAttrs.contains(attrKey)));
    blockStyle.attributes.keys.forEach(
      (attrKey) {
        if (attrKey != Attribute.list.key!) {
          return;
        }
        final listAttr = blockStyle.attributes[attrKey];
        if (listAttr!.value == Attribute.ul.value!) {
          attrSet.add(Attribute.ul.value!);
        }
        if (listAttr.value == Attribute.ol.value!) {
          attrSet.add(Attribute.ol.value!);
        }
      },
    );
    return _ControllerData(
      toggledAttrSet: attrSet,
      isCollapsed: selection.isCollapsed,
      sizeAttribute: blockStyle.attributes[Attribute.header.key!],
      indentAttribute: blockStyle.attributes[Attribute.indent.key!],
    );
  }

  void _assignAttributeValueNotifiers() {
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
    _linkStateNotifier = ValueNotifier(
        data.isCollapsed ? ToggleState.disabled : ToggleState.off);
  }

  void _controllerListener() {
    _ControllerData data = _controllerData;
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
    _linkStateNotifier.value =
        data.isCollapsed ? ToggleState.disabled : ToggleState.off;
  }

  void _openLinkDialog() {
    _linkStateNotifier.value = ToggleState.on;
    showDialog<String>(
      context: context,
      builder: (ctx) {
        return _LinkDialog();
      },
    ).then(_linkSubmitted);
  }

  void _linkSubmitted(String? value) {
    setState(() {
      _linkStateNotifier.value = widget.controller.selection.isCollapsed
          ? ToggleState.disabled
          : ToggleState.off;
      if (value == null || value.isEmpty) {
        widget.controller.selection = TextSelection.collapsed(offset: 0);
        return;
      }
      widget.controller.formatSelection(LinkAttribute(value));
      widget.controller.selection = TextSelection.collapsed(offset: 0);
    });
  }

  ToolbarItem _toolbarItemPopup(PopType type) {
    return ToolbarItem.pop(
      itemKey: _popItemKey(type),
      popupButtonBuilder: (data) => _popupButton(type, data),
      popupListBuilder: (data) => _popupList(type, data),
    );
  }

  PopupButton _popupButton(PopType type, PopupButtonData data) {
    switch (type) {
      case PopType.block:
        return PopupButton(
          data: data,
          unselectedButton: OffTile(
            iconData: Mdi.formatPilcrow,
            label: kBlockLabel,
            tooltip: kBlockTooltip,
            styling: widget.toolbarButtonStyling,
          ),
          selectedButton: OnTile(
            iconData: Mdi.formatPilcrow,
            label: kBlockLabel,
            tooltip: kBlockTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case PopType.indent:
        return PopupButton(
          data: data,
          unselectedButton: OffTile(
            iconData: Icons.format_indent_increase,
            label: kIndentLabel,
            tooltip: kIndentTooltip,
            styling: widget.toolbarButtonStyling,
          ),
          selectedButton: OnTile(
            iconData: Icons.format_indent_increase,
            label: kIndentLabel,
            tooltip: kIndentTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case PopType.list:
        return PopupButton(
          data: data,
          unselectedButton: OffTile(
            iconData: Mdi.viewList,
            label: kListLabel,
            tooltip: kListTooltip,
            styling: widget.toolbarButtonStyling,
          ),
          selectedButton: OnTile(
            iconData: Mdi.viewList,
            label: kListLabel,
            tooltip: kListTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case PopType.size:
        return PopupButton(
          data: data,
          unselectedButton: OffTile(
            iconData: Icons.format_size,
            label: kSizeLabel,
            tooltip: kSizeTooltip,
            styling: widget.toolbarButtonStyling,
          ),
          selectedButton: OnTile(
            iconData: Icons.format_size,
            label: kSizeLabel,
            tooltip: kSizeTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case PopType.style:
        return PopupButton(
          data: data,
          unselectedButton: OffTile(
            iconData: Mdi.formatFont,
            label: kStyleLabel,
            tooltip: kStyleTooltip,
            styling: widget.toolbarButtonStyling,
          ),
          selectedButton: OnTile(
            iconData: Mdi.formatFont,
            label: kStyleLabel,
            tooltip: kStyleTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
    }
  }

  ToolbarItem _optionItem() => ToolbarItem.noPop(
        itemKey: kOptionItemKey,
        selectableButtonBuilder: (data) => _optionSelectableButton(data),
      );

  SelectableButton _optionSelectableButton(SelectableButtonData data) =>
      SelectableButton(
        data: data,
        unselectedButton: widget.optionButtonParameters!.child,
      );

  ToolbarItem _toolbarItemNoPop(NoPopType type) => ToolbarItem.noPop(
        itemKey: _noPopItemKey(type),
        selectableButtonBuilder: (data) => _selectableButton(type, data),
      );

  SelectableButton _selectableButton(
    NoPopType type,
    SelectableButtonData data,
  ) {
    switch (type) {
      case NoPopType.bold:
        return SelectableButton(
          data: data,
          unselectedButton: ToggleTile(
            notifier: _boldStateNotifier,
            iconData: Icons.format_bold,
            label: kBoldLabel,
            tooltip: kBoldTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case NoPopType.italic:
        return SelectableButton(
          data: data,
          unselectedButton: ToggleTile(
            notifier: _italicStateNotifier,
            iconData: Icons.format_italic,
            label: kItalicLabel,
            tooltip: kItalicTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case NoPopType.under:
        return SelectableButton(
          data: data,
          unselectedButton: ToggleTile(
            notifier: _underStateNotifier,
            iconData: Icons.format_underline,
            label: kUnderLabel,
            tooltip: kUnderTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case NoPopType.strike:
        return SelectableButton(
          data: data,
          unselectedButton: ToggleTile(
            notifier: _strikeStateNotifier,
            iconData: Icons.format_strikethrough,
            label: kStrikeLabel,
            tooltip: kStrikeTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case NoPopType.bullet:
        return SelectableButton(
          data: data,
          unselectedButton: ToggleTile(
            notifier: _bulletStateNotifier,
            iconData: Icons.format_list_bulleted,
            label: kBulletLabel,
            tooltip: kBulletTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case NoPopType.number:
        return SelectableButton(
          data: data,
          unselectedButton: ToggleTile(
            notifier: _numberStateNotifier,
            iconData: Icons.format_list_bulleted,
            label: kNumberLabel,
            tooltip: kNumberTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case NoPopType.quote:
        return SelectableButton(
          data: data,
          unselectedButton: ToggleTile(
            notifier: _quoteStateNotifier,
            iconData: Icons.format_quote,
            label: kQuoteLabel,
            tooltip: kQuoteTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case NoPopType.code:
        return SelectableButton(
          data: data,
          unselectedButton: ToggleTile(
            notifier: _codeStateNotifier,
            iconData: Icons.code,
            label: kCodeLabel,
            tooltip: kCodeTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
      case NoPopType.link:
        return SelectableButton(
          data: data,
          unselectedButton: ToggleTile(
            notifier: _linkStateNotifier,
            iconData: Icons.link,
            label: kLinkLabel,
            tooltip: kLinkTooltip,
            styling: widget.toolbarButtonStyling,
          ),
        );
    }
  }

  PopupList _popupList(PopType type, PopupListData data) {
    switch (type) {
      case PopType.style:
        return PopupList(
          data: data,
          buttons: [
            GestureDetector(
              onTap: () => _toggleAttribute(_boldStateNotifier, Attribute.bold),
              child: ToggleTile(
                notifier: _boldStateNotifier,
                iconData: Icons.format_bold,
                styling: widget.popupButtonStyling,
                tooltip: kBoldTooltip,
              ),
            ),
            GestureDetector(
              onTap: () => _toggleAttribute(
                _italicStateNotifier,
                Attribute.italic,
              ),
              child: ToggleTile(
                notifier: _italicStateNotifier,
                iconData: Icons.format_italic,
                styling: widget.popupButtonStyling,
                tooltip: kItalicTooltip,
              ),
            ),
            GestureDetector(
              onTap: () => _toggleAttribute(
                _underStateNotifier,
                Attribute.underline,
              ),
              child: ToggleTile(
                notifier: _underStateNotifier,
                iconData: Icons.format_underline,
                styling: widget.popupButtonStyling,
                tooltip: kUnderTooltip,
              ),
            ),
            GestureDetector(
              onTap: () => _toggleAttribute(
                _strikeStateNotifier,
                Attribute.strikeThrough,
              ),
              child: ToggleTile(
                notifier: _strikeStateNotifier,
                iconData: Icons.format_strikethrough,
                styling: widget.popupButtonStyling,
                tooltip: kStrikeTooltip,
              ),
            ),
          ],
        );
      case PopType.size:
        return PopupList(
          data: data,
          buttons: [
            _attributeModifyingPopup(
              PopupActionType.sizePlus,
              widget.popupButtonStyling,
            ),
            _attributeModifyingPopup(
              PopupActionType.sizeMinus,
              widget.popupButtonStyling,
            ),
          ],
        );
      case PopType.indent:
        return PopupList(
          data: data,
          buttons: [
            _attributeModifyingPopup(
              PopupActionType.indentPlus,
              widget.popupButtonStyling,
            ),
            _attributeModifyingPopup(
              PopupActionType.indentMinus,
              widget.popupButtonStyling,
            ),
          ],
        );
      case PopType.list:
        return PopupList(
          data: data,
          buttons: [
            GestureDetector(
              onTap: () => _toggleAttribute(_numberStateNotifier, Attribute.ol),
              child: ToggleTile(
                notifier: _numberStateNotifier,
                iconData: Icons.format_list_numbered,
                styling: widget.popupButtonStyling,
                tooltip: kNumberTooltip,
              ),
            ),
            GestureDetector(
              onTap: () => _toggleAttribute(
                _bulletStateNotifier,
                Attribute.ul,
              ),
              child: ToggleTile(
                notifier: _bulletStateNotifier,
                iconData: Icons.format_list_bulleted,
                styling: widget.popupButtonStyling,
                tooltip: kBulletTooltip,
              ),
            ),
          ],
        );
      case PopType.block:
        return PopupList(
          data: data,
          buttons: [
            GestureDetector(
              onTap: () =>
                  _toggleAttribute(_quoteStateNotifier, Attribute.blockQuote),
              child: ToggleTile(
                notifier: _quoteStateNotifier,
                iconData: Icons.format_quote,
                styling: widget.popupButtonStyling,
                tooltip: kNumberTooltip,
              ),
            ),
            GestureDetector(
              onTap: () => _toggleAttribute(
                _codeStateNotifier,
                Attribute.codeBlock,
              ),
              child: ToggleTile(
                notifier: _codeStateNotifier,
                iconData: Icons.code,
                styling: widget.popupButtonStyling,
                tooltip: kBulletTooltip,
              ),
            ),
          ],
        );
    }
  }

  Widget _attributeModifyingPopup(
    PopupActionType type,
    ButtonStyling styling,
  ) {
    IconData iconData;
    String tooltip;
    VoidCallback onPressed;
    ValueNotifier<Attribute?> notifier;
    switch (type) {
      case PopupActionType.indentMinus:
        notifier = _indentNotifier;
        iconData = Icons.arrow_back;
        tooltip = kIndentMinusTooltip;
        onPressed = () {
          final attr = _decrementIndent(_indentNotifier.value);
          if (attr != null) {
            widget.controller.formatSelection(attr);
          }
        };
        break;
      case PopupActionType.indentPlus:
        notifier = _indentNotifier;
        iconData = Icons.arrow_forward;
        tooltip = kIndentPlusTooltip;
        onPressed = () {
          final attr = _incrementIndent(_indentNotifier.value);
          if (attr != null) {
            widget.controller.formatSelection(attr);
          }
        };
        break;
      case PopupActionType.sizeMinus:
        notifier = _sizeNotifier;
        iconData = Icons.arrow_downward;
        tooltip = kSizeMinusTooltip;
        onPressed = () {
          final attr = _decrementSize(_sizeNotifier.value);
          if (attr != null) {
            widget.controller.formatSelection(attr);
          }
        };
        break;
      case PopupActionType.sizePlus:
        notifier = _sizeNotifier;
        iconData = Icons.arrow_upward;
        tooltip = kSizePlusTooltip;
        onPressed = () {
          final attr = _incrementSize(_sizeNotifier.value);
          if (attr != null) {
            widget.controller.formatSelection(attr);
          }
        };
        break;
    }
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, attribute, _) {
        Attribute? nextAttr;
        switch (type) {
          case PopupActionType.indentMinus:
            nextAttr = _decrementIndent(_indentNotifier.value);
            break;
          case PopupActionType.indentPlus:
            nextAttr = _incrementIndent(_indentNotifier.value);
            break;
          case PopupActionType.sizeMinus:
            nextAttr = _decrementSize(_sizeNotifier.value);
            break;
          case PopupActionType.sizePlus:
            nextAttr = _incrementSize(_sizeNotifier.value);
            break;
        }
        bool isDisabled = nextAttr == null;
        return GestureDetector(
          onTap: isDisabled ? null : onPressed,
          child: ButtonTile(
            iconData: iconData,
            foregroundColor:
                isDisabled ? styling.disabledColor : styling.accentColor,
            decorationColor: styling.backgroundColor,
            backgroundColor: styling.backgroundColor,
            buttonShape: styling.buttonShape,
            borderStyle: styling.borderStyle,
            borderRadius: styling.borderRadius,
            borderWidth: styling.borderWidth,
            internalPadding: styling.internalPadding,
            isMaterialized: styling.isMaterialized,
            radius: styling.radius,
            width: styling.width,
            height: styling.height,
            elevation: styling.elevation,
            tooltip: tooltip,
          ),
        );
      },
    );
  }

  List<ToolbarItem> _toolbarItemsByType(RichTextToolbarType type) {
    switch (type) {
      case RichTextToolbarType.condensed:
        return [
          _toolbarItemPopup(PopType.style),
          _toolbarItemPopup(PopType.size),
          _toolbarItemPopup(PopType.indent),
          _toolbarItemPopup(PopType.list),
          _toolbarItemPopup(PopType.block),
          _toolbarItemNoPop(NoPopType.link),
        ];
      case RichTextToolbarType.expanded:
        return [
          _toolbarItemNoPop(NoPopType.bold),
          _toolbarItemNoPop(NoPopType.italic),
          _toolbarItemNoPop(NoPopType.under),
          _toolbarItemNoPop(NoPopType.strike),
          _toolbarItemPopup(PopType.size),
          _toolbarItemPopup(PopType.indent),
          _toolbarItemNoPop(NoPopType.bullet),
          _toolbarItemNoPop(NoPopType.number),
          _toolbarItemNoPop(NoPopType.quote),
          _toolbarItemNoPop(NoPopType.code),
          _toolbarItemNoPop(NoPopType.link),
        ];
      case RichTextToolbarType.condensedOption:
        return [
          _optionItem(),
          _toolbarItemPopup(PopType.style),
          _toolbarItemPopup(PopType.size),
          _toolbarItemPopup(PopType.indent),
          _toolbarItemPopup(PopType.list),
          _toolbarItemPopup(PopType.block),
          _toolbarItemNoPop(NoPopType.link),
        ];
      case RichTextToolbarType.expandedOption:
        return [
          _optionItem(),
          _toolbarItemNoPop(NoPopType.bold),
          _toolbarItemNoPop(NoPopType.italic),
          _toolbarItemNoPop(NoPopType.under),
          _toolbarItemNoPop(NoPopType.strike),
          _toolbarItemPopup(PopType.size),
          _toolbarItemPopup(PopType.indent),
          _toolbarItemNoPop(NoPopType.bullet),
          _toolbarItemNoPop(NoPopType.number),
          _toolbarItemNoPop(NoPopType.quote),
          _toolbarItemNoPop(NoPopType.code),
          _toolbarItemNoPop(NoPopType.link),
        ];
    }
  }

  @override
  void initState() {
    _assignAttributeValueNotifiers();
    widget.controller.addListener(_controllerListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingToolbar(
      data: widget.toolbarData,
      items: _toolbarItemsByType(widget.toolbarType),
      onPressed: (itemKey) {
        switch (itemKey) {
          case kBoldItemKey:
            _toggleAttribute(_boldStateNotifier, Attribute.bold);
            break;
          case kItalicItemKey:
            _toggleAttribute(_italicStateNotifier, Attribute.italic);
            break;
          case kUnderItemKey:
            _toggleAttribute(_underStateNotifier, Attribute.underline);
            break;
          case kStrikeItemKey:
            _toggleAttribute(_strikeStateNotifier, Attribute.strikeThrough);
            break;
          case kQuoteItemKey:
            _toggleAttribute(_quoteStateNotifier, Attribute.blockQuote);
            break;
          case kCodeItemKey:
            _toggleAttribute(_codeStateNotifier, Attribute.codeBlock);
            break;
          case kNumberItemKey:
            _toggleAttribute(_numberStateNotifier, Attribute.ol);
            break;
          case kBulletItemKey:
            _toggleAttribute(_bulletStateNotifier, Attribute.ul);
            break;
          case kLinkItemKey:
            if (_linkStateNotifier.value == ToggleState.off) {
              _openLinkDialog();
            }
            break;
          case kOptionItemKey:
            widget.optionButtonParameters?.onPressed();
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    _boldStateNotifier.dispose();
    _italicStateNotifier.dispose();
    _underStateNotifier.dispose();
    _strikeStateNotifier.dispose();
    _quoteStateNotifier.dispose();
    _codeStateNotifier.dispose();
    _numberStateNotifier.dispose();
    _bulletStateNotifier.dispose();
    _linkStateNotifier.dispose();
    super.dispose();
  }
}
