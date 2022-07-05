import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/buttons.dart';

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
  final ValueNotifier<int?> _selectNotifier = ValueNotifier(null);
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
      selectNotifier: _selectNotifier,
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
    _selectNotifier.dispose();
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
