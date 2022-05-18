import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/nodes/embed.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/models/constants.dart';
import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/utils/controller_utility.dart';
import 'package:mdi/mdi.dart';

class OptionButtonData {
  final ToggleState state;
  final IconData iconData;
  final String label;
  final String tooltip;
  final bool preferTooltipBelow;
  final VoidCallback onPressed;

  OptionButtonData({
    required this.state,
    required this.iconData,
    required this.label,
    required this.tooltip,
    required this.preferTooltipBelow,
    required this.onPressed,
  });
}

/// h1 > h2 > h3 > header
Attribute? incrementSize(Attribute? attribute) {
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
Attribute? decrementSize(Attribute? attribute) {
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
Attribute? incrementIndent(Attribute? attribute) {
  if (attribute == null) {
    return Attribute.indentL1;
  }
  if (attribute == Attribute.indentL3) {
    return null;
  }
  return Attribute.getIndentLevel(attribute.value + 1);
}

/// indentL1 < indentL2 < indentL3
Attribute? decrementIndent(Attribute? attribute) {
  if (attribute == null) {
    return null;
  }
  if (attribute == Attribute.indentL1) {
    return Attribute.clone(Attribute.indentL1, null);
  }
  return Attribute.getIndentLevel(attribute.value - 1);
}

final Attribute noAlignment = Attribute(
  key: 'align',
  scope: AttributeScope.BLOCK,
  value: null,
);

class LinkDialog extends StatefulWidget {
  const LinkDialog({Key? key}) : super(key: key);

  @override
  LinkDialogState createState() => LinkDialogState();
}

class LinkDialogState extends State<LinkDialog> {
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

class ImageDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ImageDialogState();
}

class ImageDialogState extends State<ImageDialog> {
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

class RichTextToolbar extends StatefulWidget {
  final QuillController controller;
  final OptionButtonData? optionButton;

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

  /// The Size of the buttons in the toolbar. Used with a SizedBox so if using
  /// widgets that may overflow this size make sure to wrap in FittedBox
  final Size buttonSize;

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
    this.optionButton,
    this.alignment = ToolbarAlignment.bottomCenterHorizontal,
    this.contentPadding = const EdgeInsets.all(2.0),
    this.buttonSpacing = 2.0,
    this.buttonSize = const Size(45.0, 40.0),
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
  late final ControllerUtility _conUtil;
  late final List<FloatingToolbarItem> _toolbarItems = [];
  late final bool _preferTooltipBelow;

  void _toggle(ToggleState state, Attribute attribute) {
    switch (state) {
      case ToggleState.disabled:
        break;
      case ToggleState.off:
        _conUtil.formatSelection(attribute);
        break;
      case ToggleState.on:
        _conUtil.formatSelection(Attribute.clone(attribute, null));
        break;
    }
  }

  void _openLinkDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        return LinkDialog();
      },
    ).then((value) => _linkSubmitted(context, value));
  }

  void _linkSubmitted(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      _conUtil.selection = TextSelection.collapsed(offset: 0);
      return;
    }
    _conUtil.formatSelection(LinkAttribute(value));
    _conUtil.selection = TextSelection.collapsed(offset: 0);
  }

  void _openImageDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        return ImageDialog();
      },
    ).then((value) => _imageSubmitted(context, value));
  }

  void _imageSubmitted(BuildContext context, String? value) {
    if (value != null && value.isNotEmpty) {
      final index = _conUtil.selection.baseOffset;
      final length = _conUtil.selection.extentOffset - index;
      _conUtil.controller
          .replaceText(index, length, BlockEmbed.image(value), null);
    }
  }

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

  // Controllers where ToggleState -> ButtonState
  late final ButtonController _boldController;
  late final ButtonController _italicController;
  late final ButtonController _underController;
  late final ButtonController _strikeController;
  late final ButtonController _bulletController;
  late final ButtonController _numberController;
  late final ButtonController _quoteController;
  late final ButtonController _codeController;
  late final ButtonController _linkController;
  late final ButtonController _imageController;

  // Controllers where Attribute? -> ButtonState
  late final ButtonController _sizePlusController;
  late final ButtonController _sizeMinusController;
  late final ButtonController _indentPlusController;
  late final ButtonController _indentMinusController;
  late final ButtonController _leftController;
  late final ButtonController _rightController;
  late final ButtonController _centerController;
  late final ButtonController _justifyController;

  ButtonController? _optionController;

  void _boldListener() {
    switch (_conUtil.bold) {
      case ToggleState.disabled:
        _boldController.disable();
        break;
      case ToggleState.off:
        _boldController.unSelect();
        break;
      case ToggleState.on:
        _boldController.select();
        break;
    }
  }

  void _italicListener() {
    switch (_conUtil.italic) {
      case ToggleState.disabled:
        _italicController.disable();
        break;
      case ToggleState.off:
        _italicController.unSelect();
        break;
      case ToggleState.on:
        _italicController.select();
        break;
    }
  }

  void _underListener() {
    switch (_conUtil.under) {
      case ToggleState.disabled:
        _underController.disable();
        break;
      case ToggleState.off:
        _underController.unSelect();
        break;
      case ToggleState.on:
        _underController.select();
        break;
    }
  }

  void _strikeListener() {
    switch (_conUtil.strike) {
      case ToggleState.disabled:
        _strikeController.disable();
        break;
      case ToggleState.off:
        _strikeController.unSelect();
        break;
      case ToggleState.on:
        _strikeController.select();
        break;
    }
  }

  // _conUtil.size.value == null smallest
  // _conUtil.size.value == 3
  // _conUtil.size.value == 2
  // _conUtil.size.value == 1 largest
  void _sizeListener() {
    if (_conUtil.size?.value == 1) {
      _sizePlusController.disable();
    } else {
      _sizePlusController.enable();
    }
    if (_conUtil.size?.value == null) {
      _sizeMinusController.disable();
    } else {
      _sizeMinusController.enable();
    }
  }

  // _conUtil.indent.value == null none
  // _conUtil.indent.value == 1
  // _conUtil.indent.value == 2
  // _conUtil.indent.value == 3 largest
  void _indentListener() {
    if (_conUtil.indent?.value == 3) {
      _indentPlusController.disable();
    } else {
      _indentPlusController.enable();
    }
    if (_conUtil.indent?.value == null) {
      _indentMinusController.disable();
    } else {
      _indentMinusController.enable();
    }
  }

  void _bulletListener() {
    switch (_conUtil.bullet) {
      case ToggleState.disabled:
        _bulletController.disable();
        break;
      case ToggleState.off:
        _bulletController.unSelect();
        break;
      case ToggleState.on:
        _bulletController.select();
        break;
    }
  }

  void _numberListener() {
    switch (_conUtil.number) {
      case ToggleState.disabled:
        _numberController.disable();
        break;
      case ToggleState.off:
        _numberController.unSelect();
        break;
      case ToggleState.on:
        _numberController.select();
        break;
    }
  }

  void _quoteListener() {
    switch (_conUtil.quote) {
      case ToggleState.disabled:
        _quoteController.disable();
        break;
      case ToggleState.off:
        _quoteController.unSelect();
        break;
      case ToggleState.on:
        _quoteController.select();
        break;
    }
  }

  void _codeListener() {
    switch (_conUtil.code) {
      case ToggleState.disabled:
        _codeController.disable();
        break;
      case ToggleState.off:
        _codeController.unSelect();
        break;
      case ToggleState.on:
        _codeController.select();
        break;
    }
  }

  void _alignmentListener() {
    if (_conUtil.alignment == Attribute.leftAlignment) {
      _leftController.select();
      _rightController.unSelect();
      _centerController.unSelect();
      _justifyController.unSelect();
    } else if (_conUtil.alignment == Attribute.rightAlignment) {
      _leftController.unSelect();
      _rightController.select();
      _centerController.unSelect();
      _justifyController.unSelect();
    } else if (_conUtil.alignment == Attribute.centerAlignment) {
      _leftController.unSelect();
      _rightController.unSelect();
      _centerController.select();
      _justifyController.unSelect();
    } else if (_conUtil.alignment == Attribute.justifyAlignment) {
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

  void _linkListener() {
    switch (_conUtil.link) {
      case ToggleState.disabled:
        _linkController.disable();
        break;
      case ToggleState.off:
        _linkController.unSelect();
        break;
      case ToggleState.on:
        _linkController.select();
        break;
    }
  }

  void _imageListener() {
    switch (_conUtil.image) {
      case ToggleState.disabled:
        _imageController.disable();
        break;
      case ToggleState.off:
        _imageController.unSelect();
        break;
      case ToggleState.on:
        _imageController.select();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _conUtil = ControllerUtility(controller: widget.controller);

    _boldController = ButtonController(value: _toButton(_conUtil.bold));
    _italicController = ButtonController(value: _toButton(_conUtil.italic));
    _underController = ButtonController(value: _toButton(_conUtil.under));
    _strikeController = ButtonController(value: _toButton(_conUtil.strike));
    _bulletController = ButtonController(value: _toButton(_conUtil.bullet));
    _numberController = ButtonController(value: _toButton(_conUtil.number));
    _quoteController = ButtonController(value: _toButton(_conUtil.quote));
    _codeController = ButtonController(value: _toButton(_conUtil.code));
    _linkController = ButtonController(value: _toButton(_conUtil.link));
    _imageController = ButtonController(value: _toButton(_conUtil.image));

    _sizePlusController = ButtonController(value: _sizePlus(_conUtil.size));
    _sizeMinusController = ButtonController(value: _sizeMinus(_conUtil.size));
    _indentPlusController =
        ButtonController(value: _indentPlus(_conUtil.indent));
    _indentMinusController =
        ButtonController(value: _indentMinus(_conUtil.indent));
    _leftController = ButtonController(
        value: _conUtil.alignment == Attribute.leftAlignment
            ? ButtonState.selected
            : ButtonState.unselected);
    _rightController = ButtonController(
        value: _conUtil.alignment == Attribute.rightAlignment
            ? ButtonState.selected
            : ButtonState.unselected);
    _centerController = ButtonController(
        value: _conUtil.alignment == Attribute.centerAlignment
            ? ButtonState.selected
            : ButtonState.unselected);
    _justifyController = ButtonController(
        value: _conUtil.alignment == Attribute.justifyAlignment
            ? ButtonState.selected
            : ButtonState.unselected);

    _conUtil.boldListenable.addListener(_boldListener);
    _conUtil.italicListenable.addListener(_italicListener);
    _conUtil.underListenable.addListener(_underListener);
    _conUtil.strikeListenable.addListener(_strikeListener);
    _conUtil.sizeListenable.addListener(_sizeListener);
    _conUtil.indentListenable.addListener(_indentListener);
    _conUtil.bulletListenable.addListener(_bulletListener);
    _conUtil.numberListenable.addListener(_numberListener);
    _conUtil.quoteListenable.addListener(_quoteListener);
    _conUtil.codeListenable.addListener(_codeListener);
    _conUtil.alignmentListenable.addListener(_alignmentListener);
    _conUtil.linkListenable.addListener(_linkListener);
    _conUtil.imageListenable.addListener(_imageListener);

    _preferTooltipBelow = _preferBelow();

    if (widget.optionButton != null) {
      _optionController = ButtonController();
      _toolbarItems.add(FloatingToolbarItem.custom(
        IconicButton(
          controller: _optionController!,
          iconData: widget.optionButton!.iconData,
          onPressed: widget.optionButton!.onPressed,
          label: widget.optionButton!.label,
          tooltip: widget.optionButton!.tooltip,
          preferTooltipBelow: _preferTooltipBelow,
          style: widget.toolbarStyle,
        ),
      ));
    }

    _toolbarItems.addAll([
      FloatingToolbarItem.standard(
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
              onPressed: () => _toggle(_conUtil.bold, Attribute.bold),
              style: widget.popupStyle,
              tooltip: kBoldTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _italicController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.format_italic,
              onPressed: () => _toggle(_conUtil.italic, Attribute.italic),
              style: widget.popupStyle,
              tooltip: kItalicTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _underController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.format_underline,
              onPressed: () => _toggle(_conUtil.under, Attribute.underline),
              style: widget.popupStyle,
              tooltip: kUnderTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _strikeController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.format_strikethrough,
              onPressed: () =>
                  _toggle(_conUtil.strike, Attribute.strikeThrough),
              style: widget.popupStyle,
              tooltip: kStrikeTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
        ],
      ),
      FloatingToolbarItem.standard(
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
              style: widget.popupStyle,
              onPressed: () {
                final attr = incrementSize(_conUtil.size);
                if (attr != null) {
                  _conUtil.formatSelection(attr);
                }
              },
              tooltip: kSizePlusTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _sizeMinusController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.arrow_downward,
              style: widget.popupStyle,
              onPressed: () {
                final attr = decrementSize(_conUtil.size);
                if (attr != null) {
                  _conUtil.formatSelection(attr);
                }
              },
              tooltip: kSizeMinusTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
        ],
      ),
      FloatingToolbarItem.standard(
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
              style: widget.popupStyle,
              onPressed: () {
                final attr = incrementIndent(_conUtil.indent);
                if (attr != null) {
                  _conUtil.formatSelection(attr);
                }
              },
              tooltip: kIndentPlusTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _indentMinusController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.arrow_back,
              style: widget.popupStyle,
              onPressed: () {
                final attr = decrementIndent(_conUtil.indent);
                if (attr != null) {
                  _conUtil.formatSelection(attr);
                }
              },
              tooltip: kIndentMinusTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
        ],
      ),
      FloatingToolbarItem.standard(
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
              onPressed: () => _toggle(_conUtil.number, Attribute.ol),
              style: widget.popupStyle,
              tooltip: kNumberTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _bulletController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.format_list_bulleted,
              onPressed: () => _toggle(_conUtil.bullet, Attribute.ul),
              style: widget.popupStyle,
              tooltip: kBulletTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
        ],
      ),
      FloatingToolbarItem.standard(
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
              onPressed: () => _toggle(_conUtil.quote, Attribute.blockQuote),
              style: widget.popupStyle,
              tooltip: kQuoteTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _codeController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.code,
              onPressed: () => _toggle(_conUtil.code, Attribute.codeBlock),
              style: widget.popupStyle,
              tooltip: kCodeTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
        ],
      ),
      FloatingToolbarItem.standard(
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
                if (_conUtil.alignment == Attribute.leftAlignment) {
                  _conUtil.formatSelection(noAlignment);
                } else {
                  _conUtil.formatSelection(Attribute.leftAlignment);
                }
              },
              style: widget.popupStyle,
              tooltip: kLeftAlignTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _rightController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.format_align_right,
              onPressed: () {
                if (_conUtil.alignment == Attribute.rightAlignment) {
                  _conUtil.formatSelection(noAlignment);
                } else {
                  _conUtil.formatSelection(Attribute.rightAlignment);
                }
              },
              style: widget.popupStyle,
              tooltip: kRightAlignTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _centerController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.format_align_center,
              onPressed: () {
                if (_conUtil.alignment == Attribute.centerAlignment) {
                  _conUtil.formatSelection(noAlignment);
                } else {
                  _conUtil.formatSelection(Attribute.centerAlignment);
                }
              },
              style: widget.popupStyle,
              tooltip: kCenterAlignTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _justifyController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.format_align_justify,
              onPressed: () {
                if (_conUtil.alignment == Attribute.justifyAlignment) {
                  _conUtil.formatSelection(noAlignment);
                } else {
                  _conUtil.formatSelection(Attribute.justifyAlignment);
                }
              },
              style: widget.popupStyle,
              tooltip: kJustifyAlignTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
        ],
      ),
      FloatingToolbarItem.standard(
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
              onPressed: () => _openLinkDialog(context),
              style: widget.popupStyle,
              tooltip: kLinkTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
          PopupItemBuilder(
            controller: _imageController,
            builder: (context, state, _) => BaseIconicButton(
              state: state,
              iconData: Icons.image,
              onPressed: () => _openImageDialog(context),
              style: widget.popupStyle,
              tooltip: kImageTooltip,
              preferTooltipBelow: _preferTooltipBelow,
            ),
          ),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingToolbar(
      items: _toolbarItems,
      alignment: widget.alignment,
      backgroundColor: widget.backgroundColor,
      buttonSize: widget.buttonSize,
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
    _conUtil.dispose();
    _boldController.dispose();
    _italicController.dispose();
    _underController.dispose();
    _strikeController.dispose();
    _sizePlusController.dispose();
    _sizeMinusController.dispose();
    _indentPlusController.dispose();
    _indentMinusController.dispose();
    _bulletController.dispose();
    _numberController.dispose();
    _quoteController.dispose();
    _codeController.dispose();
    _leftController.dispose();
    _rightController.dispose();
    _centerController.dispose();
    _justifyController.dispose();
    _linkController.dispose();
    _imageController.dispose();
    _optionController?.dispose();
    super.dispose();
  }
}
