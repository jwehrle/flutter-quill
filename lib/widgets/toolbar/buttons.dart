import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/button_controllers.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/nodes/embeddable.dart';
import 'package:flutter_quill/models/toggles/toggle.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/utils/labels.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Methods required for classes that produce [FloatingToolbarItem]
abstract class QuillButtonItem {
  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  });

  void dispose();
}

/// Makes a [FloatingToolbarItem] with bold, italic, under, and strike popups
class StyleItem with ToggleMixin implements QuillButtonItem {
  late final StyleController _styleController;
  late final ButtonController _boldController;
  late final ButtonController _italicController;
  late final ButtonController _underController;
  late final ButtonController _strikeController;

  StyleItem(QuillController controller) {
    this._styleController = StyleController(controller);
    _boldController = ButtonController(
        value: toButton(
      _styleController.bold,
    ));
    _italicController = ButtonController(
        value: toButton(
      _styleController.italic,
    ));
    _underController = ButtonController(
        value: toButton(
      _styleController.under,
    ));
    _strikeController = ButtonController(
        value: toButton(
      _styleController.strike,
    ));
    _styleController.boldListenable.addListener(() => toggleListener(
          _styleController.bold,
          _boldController,
        ));
    _styleController.italicListenable.addListener(() => toggleListener(
          _styleController.italic,
          _italicController,
        ));
    _styleController.underListenable.addListener(() => toggleListener(
          _styleController.under,
          _underController,
        ));
    _styleController.strikeListenable.addListener(() => toggleListener(
          _styleController.strike,
          _strikeController,
        ));
  }

  @override
  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  }) {
    return FloatingToolbarItem.standard(
      IconicItem(
        iconData: MdiIcons.formatFont,
        label: kStyleLabel,
        tooltip: kStyleTooltip,
      ),
      [
        PopupItemBuilder(
          controller: _boldController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_bold,
            onPressed: () => toggle(
              state: _styleController.bold,
              attribute: Attribute.bold,
              controller: _styleController.controller,
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
            onPressed: () => toggle(
              state: _styleController.italic,
              attribute: Attribute.italic,
              controller: _styleController.controller,
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
            onPressed: () => toggle(
              state: _styleController.under,
              attribute: Attribute.underline,
              controller: _styleController.controller,
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
            onPressed: () => toggle(
              state: _styleController.strike,
              attribute: Attribute.strikeThrough,
              controller: _styleController.controller,
            ),
            style: popupStyle,
            tooltip: kStrikeTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _styleController.dispose();
    _boldController.dispose();
    _italicController.dispose();
    _underController.dispose();
    _strikeController.dispose();
  }
}

/// Makes a [FloatingToolbarItem] with bullet and number popups
class ListItem with ToggleMixin implements QuillButtonItem {
  late final ListController _listController;
  late final ButtonController _numberController;
  late final ButtonController _bulletController;

  ListItem(QuillController controller) {
    _listController = ListController(controller);
    _numberController = ButtonController(
        value: toButton(
      _listController.number,
    ));
    _bulletController = ButtonController(
        value: toButton(
      _listController.bullet,
    ));
    _listController.numberListenable.addListener(() => toggleListener(
          _listController.number,
          _numberController,
        ));
    _listController.bulletListenable.addListener(() => toggleListener(
          _listController.bullet,
          _bulletController,
        ));
  }

  @override
  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  }) {
    return FloatingToolbarItem.standard(
      IconicItem(
        iconData: MdiIcons.viewList,
        label: kListLabel,
        tooltip: kListTooltip,
      ),
      [
        PopupItemBuilder(
          controller: _numberController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_list_numbered,
            onPressed: () => toggle(
              state: _listController.number,
              attribute: Attribute.ol,
              controller: _listController.controller,
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
            onPressed: () => toggle(
              state: _listController.bullet,
              attribute: Attribute.ul,
              controller: _listController.controller,
            ),
            style: popupStyle,
            tooltip: kBulletTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _listController.dispose();
    _numberController.dispose();
    _bulletController.dispose();
  }
}

/// Makes a [FloatingToolbarItem] with quote and code popups
class BlockItem with ToggleMixin implements QuillButtonItem {
  late final BlockController _blockController;
  late final ButtonController _quoteController;
  late final ButtonController _codeController;

  BlockItem(QuillController controller) {
    _blockController = BlockController(controller);
    _quoteController = ButtonController(
        value: toButton(
      _blockController.quote,
    ));
    _codeController = ButtonController(
        value: toButton(
      _blockController.code,
    ));
    _blockController.quoteListenable.addListener(() => toggleListener(
          _blockController.quote,
          _quoteController,
        ));
    _blockController.codeListenable.addListener(() => toggleListener(
          _blockController.code,
          _codeController,
        ));
  }

  @override
  FloatingToolbarItem item({
    required ButtonStyle popupStyle,
    required bool preferBelow,
  }) {
    return FloatingToolbarItem.standard(
      IconicItem(
        iconData: MdiIcons.formatPilcrow,
        label: kBlockLabel,
        tooltip: kBlockTooltip,
      ),
      [
        PopupItemBuilder(
          controller: _quoteController,
          builder: (context, state, _) => BaseIconicButton(
            state: state,
            iconData: Icons.format_quote,
            onPressed: () => toggle(
              state: _blockController.quote,
              attribute: Attribute.blockQuote,
              controller: _blockController.controller,
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
            onPressed: () => toggle(
              state: _blockController.code,
              attribute: Attribute.codeBlock,
              controller: _blockController.controller,
            ),
            style: popupStyle,
            tooltip: kCodeTooltip,
            preferTooltipBelow: preferBelow,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _blockController.dispose();
    _quoteController.dispose();
    _codeController.dispose();
  }
}

/// AlertDialog for inserting a link
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
    if (!_link.startsWith('https://')) {
      if (_link.startsWith('www.')) {
        _link = 'https://' + _link;
      } else {
        _link = 'https://www.' + _link;
      }
    }
    Navigator.pop(context, _link);
  }
}

/// AlertDialog for inserting an image
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

/// Makes a [FloatingToolbarItem] with link and image popups
class InsertItem with ToggleMixin implements QuillButtonItem {
  late final InsertController _insertController;
  late final ButtonController _linkController;
  late final ButtonController _imageController;

  InsertItem(QuillController controller) {
    _insertController = InsertController(controller);
    _linkController = ButtonController(
      value: toButton(_insertController.link),
    );
    _imageController = ButtonController(
      value: toButton(_insertController.image),
    );
    _insertController.linkListenable.addListener(() => toggleListener(
          _insertController.link,
          _linkController,
        ));
    _insertController.imageListenable.addListener(() => toggleListener(
          _insertController.image,
          _imageController,
        ));
  }

  @override
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
              _insertController.controller.moveCursorToPosition(
                  _insertController.controller.selection.extentOffset);
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

  @override
  void dispose() {
    _insertController.dispose();
    _linkController.dispose();
    _imageController.dispose();
  }
}

/// Makes a [FloatingToolbarItem] with sizePlus and sizeMinus popups
class SizeItem implements QuillButtonItem {
  late final SizeController _sizeController;
  late final ButtonController _sizePlusController;
  late final ButtonController _sizeMinusController;

  SizeItem(QuillController controller) {
    _sizeController = SizeController(controller);
    _sizePlusController = ButtonController(
      value: _sizePlusStateFromAttribute(_sizeController.size),
    );
    _sizeMinusController = ButtonController(
      value: _sizeMinusStateFromAttribute(_sizeController.size),
    );
    _sizeController.sizeListenable.addListener(() => _onSizeChanged(
          size: _sizeController.size,
          plusController: _sizePlusController,
          minusController: _sizeMinusController,
        ));
  }

  ButtonState _sizePlusStateFromAttribute(Attribute? attribute) {
    if (attribute?.value == 1) {
      return ButtonState.disabled;
    } else {
      return ButtonState.enabled;
    }
  }

  ButtonState _sizeMinusStateFromAttribute(Attribute? attribute) {
    if (attribute?.value == null) {
      return ButtonState.disabled;
    } else {
      return ButtonState.enabled;
    }
  }

  void _onSizeChanged({
    required Attribute? size,
    required ButtonController plusController,
    required ButtonController minusController,
  }) {
    if (_sizePlusStateFromAttribute(size) == ButtonState.disabled) {
      plusController.disable();
    } else {
      plusController.enable();
    }
    if (_sizeMinusStateFromAttribute(size) == ButtonState.disabled) {
      minusController.disable();
    } else {
      minusController.enable();
    }
  }

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

  @override
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

  @override
  void dispose() {
    _sizeController.dispose();
    _sizePlusController.dispose();
    _sizeMinusController.dispose();
  }
}

/// Makes a [FloatingToolbarItem] with indentPlus and indentMinus popups
class IndentItem implements QuillButtonItem {
  late final IndentController _indentController;
  late final ButtonController _indentPlusController;
  late final ButtonController _indentMinusController;

  IndentItem(QuillController controller) {
    _indentController = IndentController(controller);
    _indentPlusController = ButtonController(
      value: _indentPlusStateFromAttribute(_indentController.indent),
    );
    _indentMinusController = ButtonController(
      value: _indentMinusStateFromAttribute(_indentController.indent),
    );
    _indentController.indentListenable.addListener(() => _onIndentChanged(
          indent: _indentController.indent,
          plusController: _indentPlusController,
          minusController: _indentMinusController,
        ));
  }

  ButtonState _indentPlusStateFromAttribute(Attribute? attribute) {
    if (attribute?.value == 3) {
      return ButtonState.disabled;
    } else {
      return ButtonState.enabled;
    }
  }

  ButtonState _indentMinusStateFromAttribute(Attribute? attribute) {
    if (attribute?.value == null) {
      return ButtonState.disabled;
    } else {
      return ButtonState.enabled;
    }
  }

  void _onIndentChanged({
    required Attribute? indent,
    required ButtonController plusController,
    required ButtonController minusController,
  }) {
    if (_indentPlusStateFromAttribute(indent) == ButtonState.disabled) {
      plusController.disable();
    } else {
      plusController.enable();
    }
    if (_indentMinusStateFromAttribute(indent) == ButtonState.disabled) {
      minusController.disable();
    } else {
      minusController.enable();
    }
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

  @override
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

  @override
  void dispose() {
    _indentController.dispose();
    _indentPlusController.dispose();
    _indentMinusController.dispose();
  }
}

/// Makes a [FloatingToolbarItem] with left, right, center, and justify
/// alignment popups
class AlignItem implements QuillButtonItem {
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
    _alignController.alignmentListenable.addListener(
        () => _alignmentListener(attribute: _alignController.alignment));
  }

  Attribute get _noAlignment => Attribute('align', AttributeScope.BLOCK, null);

  void _alignmentListener({required Attribute? attribute}) {
    if (attribute == Attribute.leftAlignment) {
      _leftController.select();
      _rightController.unSelect();
      _centerController.unSelect();
      _justifyController.unSelect();
    } else if (attribute == Attribute.rightAlignment) {
      _leftController.unSelect();
      _rightController.select();
      _centerController.unSelect();
      _justifyController.unSelect();
    } else if (attribute == Attribute.centerAlignment) {
      _leftController.unSelect();
      _rightController.unSelect();
      _centerController.select();
      _justifyController.unSelect();
    } else if (attribute == Attribute.justifyAlignment) {
      _leftController.unSelect();
      _rightController.unSelect();
      _centerController.unSelect();
      _justifyController.select();
    } else {
      _leftController.unSelect();
      _rightController.unSelect();
      _centerController.unSelect();
      _justifyController.unSelect();
    }
  }

  @override
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

  @override
  void dispose() {
    _alignController.dispose();
    _leftController.dispose();
    _rightController.dispose();
    _centerController.dispose();
    _justifyController.dispose();
  }
}
