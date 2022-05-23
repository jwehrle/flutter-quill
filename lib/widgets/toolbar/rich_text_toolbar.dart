import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/nodes/embed.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/models/constants.dart';
import 'package:floating_toolbar/toolbar.dart';
import 'package:mdi/mdi.dart';

/// h1 > h2 > h3 > header
Attribute? _incrementSize(Attribute? attribute) {
  print('incrementSize called with $attribute');
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
  return null;
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
  return null;
}

/// indentL3 > indentL2 > indentL1
Attribute? _incrementIndent(Attribute? attribute) {
  if (attribute == null || attribute.value == null) {
    return Attribute.indentL1;
  }
  if (attribute == Attribute.indentL3) {
    return null;
  }
  return Attribute.getIndentLevel(attribute.value + 1);
}

/// indentL1 < indentL2 < indentL3
Attribute? _decrementIndent(Attribute? attribute) {
  if (attribute == null || attribute.value == null) {
    return null;
  }
  if (attribute == Attribute.indentL1) {
    return Attribute.clone(Attribute.indentL1, null);
  }
  return Attribute.getIndentLevel(attribute.value - 1);
}

final Attribute _noAlignment = Attribute(
  key: 'align',
  scope: AttributeScope.BLOCK,
  value: null,
);

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

class _ImageDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<_ImageDialog> {
  String _url = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        decoration: InputDecoration(labelText: 'Paste a image link'),
        autofocus: true,
        onChanged: _urlChanged,
      ),
      actions: [
        TextButton(
          onPressed: _url.isNotEmpty ? _applyUrl : null,
          child: Text('Apply'),
        ),
      ],
    );
  }

  void _urlChanged(String value) {
    setState(() {
      _url = value;
    });
  }

  void _applyUrl() {
    Navigator.pop(context, _url);
  }
}

ButtonState _toButton(ToggleState state) {
  switch (state) {
    case ToggleState.disabled:
      return ButtonState.disabled;
    case ToggleState.off:
      return ButtonState.unselected;
    case ToggleState.on:
      return ButtonState.selected;
  }
}

ButtonState _sizePlus(Attribute? attribute) {
  if (attribute?.value == 1) {
    return ButtonState.disabled;
  } else {
    return ButtonState.enabled;
  }
}

ButtonState _sizeMinus(Attribute? attribute) {
  if (attribute?.value == null) {
    return ButtonState.disabled;
  } else {
    return ButtonState.enabled;
  }
}

ButtonState _indentPlus(Attribute? attribute) {
  if (attribute?.value == 3) {
    return ButtonState.disabled;
  } else {
    return ButtonState.enabled;
  }
}

ButtonState _indentMinus(Attribute? attribute) {
  if (attribute?.value == null) {
    return ButtonState.disabled;
  } else {
    return ButtonState.enabled;
  }
}

void _toggleListener(ToggleState state, ButtonController controller) {
  switch (state) {
    case ToggleState.disabled:
      controller.disable();
      break;
    case ToggleState.off:
      controller.unSelect();
      break;
    case ToggleState.on:
      controller.select();
      break;
  }
}

void _sizeListener({
  required Attribute? size,
  required ButtonController plusController,
  required ButtonController minusController,
}) {
  if (_sizePlus(size) == ButtonState.disabled) {
    plusController.disable();
  } else {
    plusController.enable();
  }
  if (_sizeMinus(size) == ButtonState.disabled) {
    minusController.disable();
  } else {
    minusController.enable();
  }
}

void _indentListener({
  required Attribute? indent,
  required ButtonController plusController,
  required ButtonController minusController,
}) {
  if (_indentPlus(indent) == ButtonState.disabled) {
    plusController.disable();
  } else {
    plusController.enable();
  }
  if (_indentMinus(indent) == ButtonState.disabled) {
    minusController.disable();
  } else {
    minusController.enable();
  }
}

void _alignmentListener({
  required Attribute? attribute,
  required ButtonController leftController,
  required ButtonController rightController,
  required ButtonController centerController,
  required ButtonController justifyController,
}) {
  if (attribute == Attribute.leftAlignment) {
    leftController.select();
    rightController.unSelect();
    centerController.unSelect();
    justifyController.unSelect();
  } else if (attribute == Attribute.rightAlignment) {
    leftController.unSelect();
    rightController.select();
    centerController.unSelect();
    justifyController.unSelect();
  } else if (attribute == Attribute.centerAlignment) {
    leftController.unSelect();
    rightController.unSelect();
    centerController.select();
    justifyController.unSelect();
  } else if (attribute == Attribute.justifyAlignment) {
    leftController.unSelect();
    rightController.unSelect();
    centerController.unSelect();
    justifyController.select();
  } else {
    leftController.unSelect();
    rightController.unSelect();
    centerController.unSelect();
    justifyController.unSelect();
  }
}

void _toggle(
  ToggleState state,
  Attribute attribute,
  QuillController controller,
) {
  switch (state) {
    case ToggleState.disabled:
      break;
    case ToggleState.off:
      controller.formatSelection(attribute);
      break;
    case ToggleState.on:
      controller.formatSelection(Attribute.clone(attribute, null));
      break;
  }
}

class RichTextToolbar extends StatefulWidget {
  /// Used to listen for changes in text selection which determines which buttons
  /// are selected, unSelected, or disabled. Also used to effect changes in the
  /// document from button presses.
  final QuillController controller;

  /// The location of the toolbar. The first direction indicates alignment along
  /// a side, the second direction indicates alignment relative to that side.
  /// For example: leftTop means the toolbar will be placed vertically along the
  /// left side, and, the start of the toolbar will be at the top.
  final ToolbarAlignment alignment;

  /// The padding around the buttons but not between them. Default is 2.0 on
  /// all sides.
  final EdgeInsets contentPadding;

  /// The padding between buttons in the toolbar. Default is 2.0
  final double buttonSpacing;

  /// The padding between popups in the toolbar. Default is 2.0
  final double popupSpacing;

  /// The ShapeBorder of the toolbar. Default is Rounded Rectangle with
  /// BorderRadius of 4.0 on all corners.
  final ShapeBorder shape;

  /// Padding around the toolbar. Default is 2.0 on all sides.
  final EdgeInsets margin;

  /// The Clip behavior to assign to the ScrollView the toolbar is wrapped in.
  /// Default is antiAlias.
  final Clip clip;

  /// The elevation of the Material widget the toolbar is wrapped in. Default is
  /// 2.0
  final double elevation;

  /// Callback with itemKey of toolbar buttons pressed
  final ValueChanged<int?>? onValueChanged;

  /// Offset of tooltips
  final double? tooltipOffset;

  /// The background of the toolbar. Defaults to [Theme.primaryColor]
  final Color backgroundColor;

  /// The ButtonStyle applied to IconicButtons of the toolbar.
  final ButtonStyle? toolbarStyle;

  /// The ButtonStyle applied to IconicButtons of popups.
  final ButtonStyle popupStyle;

  const RichTextToolbar({
    Key? key,
    required this.controller,
    required this.backgroundColor,
    required this.popupStyle,
    this.alignment = ToolbarAlignment.bottomCenterHorizontal,
    this.contentPadding = const EdgeInsets.all(2.0),
    this.buttonSpacing = 2.0,
    this.popupSpacing = 4.0,
    this.elevation = 2.0,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
    this.tooltipOffset,
    this.toolbarStyle,
    this.clip = Clip.antiAlias,
    this.margin = const EdgeInsets.all(2.0),
    this.onValueChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => RichTextToolbarState();
}

class RichTextToolbarState extends State<RichTextToolbar> {
  late final List<FloatingToolbarItem> _toolbarItems;
  late final bool _preferTooltipBelow;

  bool _preferBelow() {
    switch (widget.alignment) {
      case ToolbarAlignment.topLeftVertical:
      case ToolbarAlignment.topLeftHorizontal:
      case ToolbarAlignment.topCenterHorizontal:
      case ToolbarAlignment.topRightHorizontal:
      case ToolbarAlignment.topRightVertical:
      case ToolbarAlignment.centerLeftVertical:
      case ToolbarAlignment.centerRightVertical:
        return true;
      case ToolbarAlignment.bottomLeftVertical:
      case ToolbarAlignment.bottomRightVertical:
      case ToolbarAlignment.bottomLeftHorizontal:
      case ToolbarAlignment.bottomCenterHorizontal:
      case ToolbarAlignment.bottomRightHorizontal:
        return false;
    }
  }

  late final StyleItem _styleItem;
  late final SizeItem _sizeItem;
  late final IndentItem _indentItem;
  late final ListItem _listItem;
  late final BlockItem _blockItem;
  late final InsertItem _insertItem;
  late final AlignItem _alignItem;

  @override
  void initState() {
    super.initState();

    _styleItem = StyleItem(widget.controller);
    _sizeItem = SizeItem(widget.controller);
    _indentItem = IndentItem(widget.controller);
    _listItem = ListItem(widget.controller);
    _blockItem = BlockItem(widget.controller);
    _alignItem = AlignItem(widget.controller);
    _insertItem = InsertItem(widget.controller);

    _preferTooltipBelow = _preferBelow();

    _toolbarItems = [
      _styleItem.item(
        popupStyle: widget.popupStyle,
        preferBelow: _preferTooltipBelow,
      ),
      _sizeItem.item(
        popupStyle: widget.popupStyle,
        preferBelow: _preferTooltipBelow,
      ),
      _indentItem.item(
        popupStyle: widget.popupStyle,
        preferBelow: _preferTooltipBelow,
      ),
      _listItem.item(
        popupStyle: widget.popupStyle,
        preferBelow: _preferTooltipBelow,
      ),
      _blockItem.item(
        popupStyle: widget.popupStyle,
        preferBelow: _preferTooltipBelow,
      ),
      _alignItem.item(
        popupStyle: widget.popupStyle,
        preferBelow: _preferTooltipBelow,
      ),
      _insertItem.item(
        popupStyle: widget.popupStyle,
        preferBelow: _preferTooltipBelow,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FloatingToolbar(
      items: _toolbarItems,
      alignment: widget.alignment,
      backgroundColor: widget.backgroundColor,
      contentPadding: widget.contentPadding,
      buttonSpacing: widget.buttonSpacing,
      popupSpacing: widget.popupSpacing,
      shape: widget.shape,
      margin: widget.margin,
      clip: widget.clip,
      elevation: widget.elevation,
      onValueChanged: widget.onValueChanged,
      tooltipOffset: widget.tooltipOffset,
      preferTooltipBelow: _preferTooltipBelow,
      toolbarStyle: widget.toolbarStyle,
    );
  }

  @override
  void dispose() {
    _styleItem.dispose();
    _sizeItem.dispose();
    _indentItem.dispose();
    _listItem.dispose();
    _blockItem.dispose();
    _insertItem.dispose();
    _alignItem.dispose();
    super.dispose();
  }
}

class StyleData {
  final Set<String> attrSet;

  StyleData({
    required this.attrSet,
  });
}

class StyleController {
  StyleController(this.controller) {
    StyleData data = _styleData;
    _boldStateNotifier = ValueNotifier(
        data.attrSet.contains(Attribute.bold.key!)
            ? ToggleState.on
            : ToggleState.off);
    _strikeStateNotifier = ValueNotifier(
        data.attrSet.contains(Attribute.strikeThrough.key!)
            ? ToggleState.on
            : ToggleState.off);
    _underStateNotifier = ValueNotifier(
        data.attrSet.contains(Attribute.underline.key!)
            ? ToggleState.on
            : ToggleState.off);
    _italicStateNotifier = ValueNotifier(
        data.attrSet.contains(Attribute.italic.key!)
            ? ToggleState.on
            : ToggleState.off);
    controller.addListener(_controllerListener);
  }

  static final Set<String> _styleAttrs = Set.unmodifiable({
    Attribute.bold.key!,
    Attribute.italic.key!,
    Attribute.strikeThrough.key!,
    Attribute.underline.key!,
  });

  final QuillController controller;

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

  void _controllerListener() {
    final data = _styleData;
    _boldStateNotifier.value = data.attrSet.contains(Attribute.bold.key!)
        ? ToggleState.on
        : ToggleState.off;
    _strikeStateNotifier.value =
        data.attrSet.contains(Attribute.strikeThrough.key!)
            ? ToggleState.on
            : ToggleState.off;
    _underStateNotifier.value = data.attrSet.contains(Attribute.underline.key!)
        ? ToggleState.on
        : ToggleState.off;
    _italicStateNotifier.value = data.attrSet.contains(Attribute.italic.key!)
        ? ToggleState.on
        : ToggleState.off;
  }

  StyleData get _styleData {
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
    return StyleData(attrSet: attrSet);
  }

  void dispose() {
    controller.removeListener(_controllerListener);
    _boldStateNotifier.dispose();
    _italicStateNotifier.dispose();
    _underStateNotifier.dispose();
    _strikeStateNotifier.dispose();
  }
}

class StyleItem {
  late final StyleController _styleController;
  late final ButtonController _boldController;
  late final ButtonController _italicController;
  late final ButtonController _underController;
  late final ButtonController _strikeController;

  StyleItem(QuillController controller) {
    this._styleController = StyleController(controller);
    _boldController = ButtonController(
        value: _toButton(
      _styleController.bold,
    ));
    _italicController = ButtonController(
        value: _toButton(
      _styleController.italic,
    ));
    _underController = ButtonController(
        value: _toButton(
      _styleController.under,
    ));
    _strikeController = ButtonController(
        value: _toButton(
      _styleController.strike,
    ));
    _styleController.boldListenable.addListener(() => _toggleListener(
          _styleController.bold,
          _boldController,
        ));
    _styleController.italicListenable.addListener(() => _toggleListener(
          _styleController.italic,
          _italicController,
        ));
    _styleController.underListenable.addListener(() => _toggleListener(
          _styleController.under,
          _underController,
        ));
    _styleController.strikeListenable.addListener(() => _toggleListener(
          _styleController.strike,
          _strikeController,
        ));
  }

  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  }) {
    return FloatingToolbarItem.standard(
      IconicItem(
        iconData: Mdi.formatFont,
        label: kStyleLabel,
        tooltip: kStyleTooltip,
      ),
      [
        PopupItemBuilder(
          controller: _boldController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_bold,
            onPressed: () => _toggle(
              _styleController.bold,
              Attribute.bold,
              _styleController.controller,
            ),
            style: popupStyle,
            tooltip: kBoldTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _italicController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_italic,
            onPressed: () => _toggle(
              _styleController.italic,
              Attribute.italic,
              _styleController.controller,
            ),
            style: popupStyle,
            tooltip: kItalicTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _underController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_underline,
            onPressed: () => _toggle(
              _styleController.under,
              Attribute.underline,
              _styleController.controller,
            ),
            style: popupStyle,
            tooltip: kUnderTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _strikeController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_strikethrough,
            onPressed: () => _toggle(
              _styleController.strike,
              Attribute.strikeThrough,
              _styleController.controller,
            ),
            style: popupStyle,
            tooltip: kStrikeTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
      ],
    );
  }

  void dispose() {
    _styleController.dispose();
    _boldController.dispose();
    _italicController.dispose();
    _underController.dispose();
    _strikeController.dispose();
  }
}

class ListData {
  final Set<String> attrSet;

  ListData({
    required this.attrSet,
  });
}

class ListController {
  ListController(this.controller) {
    final ListData data = _listData;
    _bulletStateNotifier = ValueNotifier(
        data.attrSet.contains(Attribute.ul.value!)
            ? ToggleState.on
            : ToggleState.off);
    _numberStateNotifier = ValueNotifier(
        data.attrSet.contains(Attribute.ol.value!)
            ? ToggleState.on
            : ToggleState.off);
    controller.addListener(_controllerListener);
  }

  static final Set<String> _listAttrs = Set.unmodifiable({
    Attribute.ol.value!,
    Attribute.ul.value!,
  });

  final QuillController controller;

  late final ValueNotifier<ToggleState> _numberStateNotifier;
  ValueListenable<ToggleState> get numberListenable => _numberStateNotifier;
  ToggleState get number => numberListenable.value;

  late final ValueNotifier<ToggleState> _bulletStateNotifier;
  ValueListenable<ToggleState> get bulletListenable => _bulletStateNotifier;
  ToggleState get bullet => bulletListenable.value;

  ListData get _listData {
    Set<String> attrSet = {};
    final Style style = controller.getSelectionStyle();
    attrSet.addAll(style.attributes.values
        .where((attr) => _listAttrs.contains(attr.value))
        .map((attr) => attr.value));
    return ListData(attrSet: attrSet);
  }

  void _controllerListener() {
    final data = _listData;
    _bulletStateNotifier.value = data.attrSet.contains(Attribute.ul.value!)
        ? ToggleState.on
        : ToggleState.off;
    _numberStateNotifier.value = data.attrSet.contains(Attribute.ol.value!)
        ? ToggleState.on
        : ToggleState.off;
  }

  void dispose() {
    controller.dispose();
  }
}

class ListItem {
  late final ListController _listController;
  late final ButtonController _numberController;
  late final ButtonController _bulletController;

  ListItem(QuillController controller) {
    _listController = ListController(controller);
    _numberController = ButtonController(
        value: _toButton(
      _listController.number,
    ));
    _bulletController = ButtonController(
        value: _toButton(
      _listController.bullet,
    ));
    _listController.numberListenable.addListener(() => _toggleListener(
          _listController.number,
          _numberController,
        ));
    _listController.bulletListenable.addListener(() => _toggleListener(
          _listController.bullet,
          _bulletController,
        ));
  }

  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  }) {
    return FloatingToolbarItem.standard(
      IconicItem(
        iconData: Mdi.viewList,
        label: kListLabel,
        tooltip: kListTooltip,
      ),
      [
        PopupItemBuilder(
          controller: _numberController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_list_numbered,
            onPressed: () => _toggle(
              _listController.number,
              Attribute.ol,
              _listController.controller,
            ),
            style: popupStyle,
            tooltip: kNumberTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _bulletController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_list_bulleted,
            onPressed: () => _toggle(
              _listController.bullet,
              Attribute.ul,
              _listController.controller,
            ),
            style: popupStyle,
            tooltip: kBulletTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
      ],
    );
  }

  void dispose() {
    _listController.dispose();
    _numberController.dispose();
    _bulletController.dispose();
  }
}

class BlockData {
  final Set<String> attrSet;

  BlockData({
    required this.attrSet,
  });
}

class BlockController {
  BlockController(this.controller) {
    final BlockData data = _blockData;
    _quoteStateNotifier = ValueNotifier(
        data.attrSet.contains(Attribute.blockQuote.key!)
            ? ToggleState.on
            : ToggleState.off);
    _codeStateNotifier = ValueNotifier(
        data.attrSet.contains(Attribute.codeBlock.key!)
            ? ToggleState.on
            : ToggleState.off);
    controller.addListener(_controllerListener);
  }

  static final Set<String> _quoteCodeAttrs = Set.unmodifiable({
    Attribute.blockQuote.key!,
    Attribute.codeBlock.key!,
  });

  final QuillController controller;

  late final ValueNotifier<ToggleState> _quoteStateNotifier;
  ValueListenable<ToggleState> get quoteListenable => _quoteStateNotifier;
  ToggleState get quote => quoteListenable.value;

  late final ValueNotifier<ToggleState> _codeStateNotifier;
  ValueListenable<ToggleState> get codeListenable => _codeStateNotifier;
  ToggleState get code => codeListenable.value;

  BlockData get _blockData {
    Set<String> attrSet = {};
    final Style style = controller.getSelectionStyle();
    attrSet.addAll(style.attributes.keys
        .where((attrKey) => _quoteCodeAttrs.contains(attrKey)));
    return BlockData(attrSet: attrSet);
  }

  void _controllerListener() {
    final BlockData data = _blockData;
    _quoteStateNotifier.value = data.attrSet.contains(Attribute.blockQuote.key!)
        ? ToggleState.on
        : ToggleState.off;
    _codeStateNotifier.value = data.attrSet.contains(Attribute.codeBlock.key!)
        ? ToggleState.on
        : ToggleState.off;
  }

  void dispose() {
    _quoteStateNotifier.dispose();
    _codeStateNotifier.dispose();
  }
}

class BlockItem {
  late final BlockController _blockController;
  late final ButtonController _quoteController;
  late final ButtonController _codeController;

  BlockItem(QuillController controller) {
    _blockController = BlockController(controller);
    _quoteController = ButtonController(
        value: _toButton(
      _blockController.quote,
    ));
    _codeController = ButtonController(
        value: _toButton(
      _blockController.code,
    ));
    _blockController.quoteListenable.addListener(() => _toggleListener(
          _blockController.quote,
          _quoteController,
        ));
    _blockController.codeListenable.addListener(() => _toggleListener(
          _blockController.code,
          _codeController,
        ));
  }

  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  }) {
    return FloatingToolbarItem.standard(
      IconicItem(
        iconData: Mdi.formatPilcrow,
        label: kBlockLabel,
        tooltip: kBlockTooltip,
      ),
      [
        PopupItemBuilder(
          controller: _quoteController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_quote,
            onPressed: () => _toggle(
              _blockController.quote,
              Attribute.blockQuote,
              _blockController.controller,
            ),
            style: popupStyle,
            tooltip: kQuoteTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _codeController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.code,
            onPressed: () => _toggle(
              _blockController.code,
              Attribute.codeBlock,
              _blockController.controller,
            ),
            style: popupStyle,
            tooltip: kCodeTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
      ],
    );
  }

  void dispose() {
    _blockController.dispose();
    _quoteController.dispose();
    _codeController.dispose();
  }
}

class InsertData {
  final bool isCollapsed;
  final bool canEmbedImage;

  InsertData({required this.isCollapsed, required this.canEmbedImage});
}

class InsertController {
  InsertController(this.controller) {
    _linkStateNotifier = ValueNotifier(ToggleState.disabled);
    _imageStateNotifier = ValueNotifier(ToggleState.disabled);
    controller.addListener(_controllerListener);
  }

  static final Set<String> _quoteCodeAttrs = Set.unmodifiable({
    Attribute.blockQuote.key!,
    Attribute.codeBlock.key!,
  });

  final QuillController controller;

  late final ValueNotifier<ToggleState> _linkStateNotifier;
  ValueListenable<ToggleState> get linkListenable => _linkStateNotifier;
  ToggleState get link => linkListenable.value;

  late final ValueNotifier<ToggleState> _imageStateNotifier;
  ValueListenable<ToggleState> get imageListenable => _imageStateNotifier;
  ToggleState get image => imageListenable.value;

  InsertData get _insertData {
    Set<String> attrSet = {};
    final Style style = controller.getSelectionStyle();
    attrSet.addAll(style.attributes.keys
        .where((attrKey) => _quoteCodeAttrs.contains(attrKey)));
    return InsertData(
      isCollapsed: controller.selection.isCollapsed,
      canEmbedImage: attrSet.intersection(_quoteCodeAttrs).isEmpty,
    );
  }

  void _controllerListener() {
    final InsertData data = _insertData;
    _linkStateNotifier.value =
        data.isCollapsed ? ToggleState.disabled : ToggleState.off;
    _imageStateNotifier.value =
        data.canEmbedImage ? ToggleState.off : ToggleState.disabled;
  }

  void dispose() {
    _linkStateNotifier.dispose();
    _imageStateNotifier.dispose();
  }
}

class InsertItem {
  late final InsertController _insertController;
  late final ButtonController _linkController;
  late final ButtonController _imageController;

  InsertItem(QuillController controller) {
    _insertController = InsertController(controller);
    _linkController = ButtonController(
      value: _toButton(_insertController.link),
    );
    _imageController = ButtonController(
      value: _toButton(_insertController.image),
    );
    _insertController.linkListenable.addListener(() => _toggleListener(
          _insertController.link,
          _linkController,
        ));
    _insertController.imageListenable.addListener(() => _toggleListener(
          _insertController.image,
          _imageController,
        ));
  }

  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  }) {
    return FloatingToolbarItem.standard(
      IconicItem(
        iconData: Icons.attachment_sharp,
        label: kInsertLabel,
        tooltip: kInsertTooltip,
      ),
      [
        PopupItemBuilder(
          controller: _linkController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.link,
            onPressed: () => showDialog<String>(
                context: context,
                builder: (context) => _LinkDialog()).then((value) {
              if (value != null && value.isNotEmpty) {
                _insertController.controller.formatSelection(
                  LinkAttribute(value),
                );
              }
              _insertController.controller.selection = TextSelection.collapsed(
                offset: _insertController.controller.selection.extentOffset,
              );
            }),
            style: popupStyle,
            tooltip: kLinkTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _imageController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.image,
            onPressed: () => showDialog<String>(
              context: context,
              builder: (context) {
                return _ImageDialog();
              },
            ).then((value) {
              if (value != null && value.isNotEmpty) {
                final index = _insertController.controller.selection.baseOffset;
                final length =
                    _insertController.controller.selection.extentOffset - index;
                _insertController.controller.replaceText(
                  index,
                  length,
                  BlockEmbed.image(value),
                  null,
                );
              }
            }),
            style: popupStyle,
            tooltip: kImageTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
      ],
    );
  }

  void dispose() {
    _insertController.dispose();
    _linkController.dispose();
    _imageController.dispose();
  }
}

class SizeData {
  final Attribute? data;
  SizeData(this.data);
}

class SizeController {
  SizeController(this.controller) {
    _sizeNotifier = ValueNotifier(_sizeData.data);
    controller.addListener(() => _sizeNotifier.value = _sizeData.data);
  }

  final QuillController controller;

  late final ValueNotifier<Attribute?> _sizeNotifier;
  ValueListenable<Attribute?> get sizeListenable => _sizeNotifier;
  Attribute? get size => sizeListenable.value;

  SizeData get _sizeData => SizeData(
      controller.getSelectionStyle().attributes[Attribute.header.key!] ??
          Attribute.header);

  void dispose() {
    _sizeNotifier.dispose();
  }
}

class SizeItem {
  late final SizeController _sizeController;
  late final ButtonController _sizePlusController;
  late final ButtonController _sizeMinusController;

  SizeItem(QuillController controller) {
    _sizeController = SizeController(controller);
    _sizePlusController = ButtonController(
      value: _sizePlus(_sizeController.size),
    );
    _sizeMinusController = ButtonController(
      value: _sizeMinus(_sizeController.size),
    );
    _sizeController.sizeListenable.addListener(() => _sizeListener(
          size: _sizeController.size,
          plusController: _sizePlusController,
          minusController: _sizeMinusController,
        ));
  }

  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  }) {
    return FloatingToolbarItem.standard(
      IconicItem(
        iconData: Icons.format_size,
        label: kSizeLabel,
        tooltip: kSizeTooltip,
      ),
      [
        PopupItemBuilder(
          controller: _sizePlusController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.arrow_upward,
            onPressed: () {
              final attr = _incrementSize(_sizeController.size);
              if (attr != null) {
                _sizeController.controller.formatSelection(attr);
              }
            },
            style: popupStyle,
            tooltip: kSizePlusTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _sizeMinusController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.arrow_downward,
            onPressed: () {
              final attr = _decrementSize(_sizeController.size);
              if (attr != null) {
                _sizeController.controller.formatSelection(attr);
              }
            },
            style: popupStyle,
            tooltip: kSizeMinusTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
      ],
    );
  }

  void dispose() {
    _sizeController.dispose();
    _sizePlusController.dispose();
    _sizeMinusController.dispose();
  }
}

class IndentData {
  final Attribute? data;
  IndentData(this.data);
}

class IndentController {
  IndentController(this.controller) {
    _indentNotifier = ValueNotifier(_indentData.data);
    controller.addListener(() => _indentNotifier.value = _indentData.data);
  }

  final QuillController controller;

  late final ValueNotifier<Attribute?> _indentNotifier;
  ValueListenable<Attribute?> get indentListenable => _indentNotifier;
  Attribute? get indent => indentListenable.value;

  IndentData get _indentData => IndentData(
      controller.getSelectionStyle().attributes[Attribute.indent.key!] ??
          Attribute.indent);

  void dispose() {
    _indentNotifier.dispose();
  }
}

class IndentItem {
  late final IndentController _indentController;
  late final ButtonController _indentPlusController;
  late final ButtonController _indentMinusController;

  IndentItem(QuillController controller) {
    _indentController = IndentController(controller);
    _indentPlusController = ButtonController(
      value: _indentPlus(_indentController.indent),
    );
    _indentMinusController = ButtonController(
      value: _indentMinus(_indentController.indent),
    );
    _indentController.indentListenable.addListener(() => _indentListener(
          indent: _indentController.indent,
          plusController: _indentPlusController,
          minusController: _indentMinusController,
        ));
  }

  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  }) {
    return FloatingToolbarItem.standard(
      IconicItem(
        iconData: Icons.format_indent_increase,
        label: kIndentLabel,
        tooltip: kIndentTooltip,
      ),
      [
        PopupItemBuilder(
          controller: _indentPlusController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.arrow_forward,
            onPressed: () {
              final attr = _incrementIndent(_indentController.indent);
              if (attr != null) {
                _indentController.controller.formatSelection(attr);
              }
            },
            style: popupStyle,
            tooltip: kIndentPlusTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _indentMinusController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.arrow_back,
            onPressed: () {
              final attr = _decrementIndent(_indentController.indent);
              if (attr != null) {
                _indentController.controller.formatSelection(attr);
              }
            },
            style: popupStyle,
            tooltip: kIndentMinusTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
      ],
    );
  }

  void dispose() {
    _indentController.dispose();
    _indentPlusController.dispose();
    _indentMinusController.dispose();
  }
}

class AlignData {
  final Attribute? data;
  AlignData(this.data);
}

class AlignController {
  AlignController(this.controller) {
    _alignmentNotifier = ValueNotifier(_alignData.data);
    controller.addListener(() => _alignmentNotifier.value = _alignData.data);
  }

  final QuillController controller;

  late final ValueNotifier<Attribute?> _alignmentNotifier;
  ValueListenable<Attribute?> get alignmentListenable => _alignmentNotifier;
  Attribute? get alignment => alignmentListenable.value;

  AlignData get _alignData => AlignData(
      controller.getSelectionStyle().attributes[Attribute.align.key!]);

  dispose() {
    _alignmentNotifier.dispose();
  }
}

class AlignItem {
  late final AlignController _alignController;
  late final ButtonController _leftController;
  late final ButtonController _rightController;
  late final ButtonController _centerController;
  late final ButtonController _justifyController;

  AlignItem(QuillController controller) {
    _alignController = AlignController(controller);
    _leftController = ButtonController(
        value: _alignController.alignment == Attribute.leftAlignment
            ? ButtonState.selected
            : ButtonState.unselected);
    _rightController = ButtonController(
        value: _alignController.alignment == Attribute.rightAlignment
            ? ButtonState.selected
            : ButtonState.unselected);
    _centerController = ButtonController(
        value: _alignController.alignment == Attribute.centerAlignment
            ? ButtonState.selected
            : ButtonState.unselected);
    _justifyController = ButtonController(
        value: _alignController.alignment == Attribute.justifyAlignment
            ? ButtonState.selected
            : ButtonState.unselected);
    _alignController.alignmentListenable.addListener(() => _alignmentListener(
          attribute: _alignController.alignment,
          leftController: _leftController,
          rightController: _rightController,
          centerController: _centerController,
          justifyController: _justifyController,
        ));
  }

  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  }) {
    return FloatingToolbarItem.standard(
      IconicItem(
        iconData: Icons.format_align_left,
        label: kAlignLabel,
        tooltip: kAlignTooltip,
      ),
      [
        PopupItemBuilder(
          controller: _leftController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_align_left,
            onPressed: () {
              if (_alignController.alignment == Attribute.leftAlignment) {
                _alignController.controller.formatSelection(_noAlignment);
              } else {
                _alignController.controller
                    .formatSelection(Attribute.leftAlignment);
              }
            },
            style: popupStyle,
            tooltip: kLeftAlignTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _rightController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_align_right,
            onPressed: () {
              if (_alignController.alignment == Attribute.rightAlignment) {
                _alignController.controller.formatSelection(_noAlignment);
              } else {
                _alignController.controller
                    .formatSelection(Attribute.rightAlignment);
              }
            },
            style: popupStyle,
            tooltip: kRightAlignTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _centerController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_align_center,
            onPressed: () {
              if (_alignController.alignment == Attribute.centerAlignment) {
                _alignController.controller.formatSelection(_noAlignment);
              } else {
                _alignController.controller
                    .formatSelection(Attribute.centerAlignment);
              }
            },
            style: popupStyle,
            tooltip: kCenterAlignTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
        PopupItemBuilder(
          controller: _justifyController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_align_justify,
            onPressed: () {
              if (_alignController.alignment == Attribute.justifyAlignment) {
                _alignController.controller.formatSelection(_noAlignment);
              } else {
                _alignController.controller
                    .formatSelection(Attribute.justifyAlignment);
              }
            },
            style: popupStyle,
            tooltip: kJustifyAlignTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
      ],
    );
  }

  void dispose() {
    _alignController.dispose();
    _leftController.dispose();
    _rightController.dispose();
    _centerController.dispose();
    _justifyController.dispose();
  }
}
