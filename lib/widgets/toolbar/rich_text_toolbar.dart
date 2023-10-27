import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter_quill/utils/labels.dart';
import 'package:flutter_quill/widgets/toolbar/items/align_item.dart';
import 'package:flutter_quill/widgets/toolbar/items/block_item.dart';
import 'package:flutter_quill/widgets/toolbar/items/indent_item.dart';
import 'package:flutter_quill/widgets/toolbar/items/insert_item.dart';
import 'package:flutter_quill/widgets/toolbar/items/list_item.dart';
import 'package:flutter_quill/widgets/toolbar/items/quill_item.dart';
import 'package:flutter_quill/widgets/toolbar/items/size_item.dart';
import 'package:flutter_quill/widgets/toolbar/items/style_item.dart';
import 'package:iconic_button/iconic_button.dart';

const kDefaultToolbarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(4.0)));
const kDefaultPopupShape = const CircleBorder();

const kDefaultToolbarContentPadding = const EdgeInsets.all(2.0);
const kDefaultToolbarMargin = const EdgeInsets.all(2.0);
const kDefaultPopupPadding = const EdgeInsets.all(8.0);

const kDefaultPopupElevation = 4.0;
const kDefaultButtonSpacing = 2.0;
const kDefaultPopupSpacing = 4.0;
const kDefaultToolbarElevation = 2.0;

class RichTextToolbar extends StatefulWidget {
  /// Creates a floating toolbar with standard formating options.
  /// The only two required parameters are [controller] and [backgroundColor].
  /// All other parameters are nullable or come with standard defaults - changing
  /// these provides exhaustive control over shape, size, coloring, spacing, labels
  /// icons, tooltips, and, item selection/deselection.
  const RichTextToolbar({
    Key? key,
    required this.controller,
    required this.backgroundColor,
    this.alignment = ToolbarAlignment.bottomCenterHorizontal,
    this.contentPadding = kDefaultToolbarContentPadding,
    this.buttonSpacing = kDefaultButtonSpacing,
    this.popupSpacing = kDefaultPopupSpacing,
    this.elevation = kDefaultToolbarElevation,
    this.shape = kDefaultToolbarShape,
    this.tooltipOffset,
    this.clip = Clip.antiAlias,
    this.margin = kDefaultToolbarMargin,
    this.onValueChanged,
    this.popupShape = kDefaultPopupShape,
    this.popupElevation = kDefaultPopupElevation,
    this.popupPadding = kDefaultPopupPadding,
    this.popupPrimary,
    this.popupOnPrimary,
    this.popupOnSurface,
    this.popupShadowColor,
    this.popupTextStyle,
    this.toolbarPrimary,
    this.toolbarOnPrimary,
    this.toolbarOnSurface,
    this.toolbarShadowColor,
    this.toolbarButtonElevation = 0.0,
    this.toolbarTextStyle,
    this.toolbarPadding,
    this.toolbarButtonShape = kDefaultRectangularShape,
    this.dimissOnFinish = false,
    this.styleIconData = CommunityMaterialIcons.format_font,
    this.styleLabel = kStyleLabel,
    this.styleTooltip = kStyleTooltip,
    this.boldIconData = Icons.format_bold,
    this.boldLabel,
    this.boldTooltip = kBoldTooltip,
    this.italicIconData = Icons.format_italic,
    this.italicLabel,
    this.italicTooltip = kItalicTooltip,
    this.underlineIconData = Icons.format_underline,
    this.underlineLabel,
    this.underlineTooltip = kUnderTooltip,
    this.strikeThruIconData = Icons.format_strikethrough,
    this.strikeThruLabel,
    this.strikeThruTooltip = kStrikeTooltip,
    this.listIconData = CommunityMaterialIcons.view_list,
    this.listLabel = kListLabel,
    this.listTooltip = kListTooltip,
    this.numberedListIconData = Icons.format_list_numbered,
    this.numberedListLabel,
    this.numberedListTooltip = kNumberTooltip,
    this.bulletedListIconData = Icons.format_list_bulleted,
    this.bulletedListLabel,
    this.bulletedListTooltip = kBulletTooltip,
    this.blockIconData = CommunityMaterialIcons.format_pilcrow,
    this.blockLabel = kBlockLabel,
    this.blockTooltip = kBlockTooltip,
    this.quoteBlockIconData = Icons.format_quote,
    this.quoteBlockLabel,
    this.quoteBlockTooltip = kQuoteTooltip,
    this.codeBlockIconData = Icons.code,
    this.codeBlocklabel,
    this.codeBlockTooltip = kCodeTooltip,
    this.insertIconData = Icons.attachment_sharp,
    this.insertLabel = kInsertLabel,
    this.insertTooltip = kInsertTooltip,
    this.textLinkIconData = Icons.link,
    this.textLinkLabel,
    this.textLinkTooltip = kLinkTooltip,
    this.textLinkDialogTitle = kLinkTitle,
    this.textLinkDialogTextLabel = kLinkTextLabel,
    this.textLinkDialogUrlLabel = kUrlLabel,
    this.textLinkDialogCancelLabel = kDialogCancelLabel,
    this.textLinkDialogAcceptLabel = kDialogAcceptLabel,
    this.imageLinkIconData = Icons.image,
    this.imageLinkLabel,
    this.imageLinkTooltip = kImageTooltip,
    this.imageLinkDialogTitle = kImageTitle,
    this.imageLinkDialogUrlLabel = kUrlLabel,
    this.imageLinkDialogCancelLabel = kDialogCancelLabel,
    this.imageLinkDialogAcceptLabel = kDialogAcceptLabel,
    this.sizeIconData = Icons.format_size,
    this.sizeLabel = kSizeLabel,
    this.sizeTooltip = kSizeTooltip,
    this.sizePlusIconData = Icons.arrow_upward,
    this.sizePlusLabel,
    this.sizePlusTooltip = kSizePlusTooltip,
    this.sizeMinusIconData = Icons.arrow_downward,
    this.sizeMinusLabel,
    this.sizeMinusTooltip = kSizeMinusTooltip,
    this.indentIconData = Icons.format_indent_increase,
    this.indentLabel = kIndentLabel,
    this.indentTooltip = kIndentTooltip,
    this.indentPlusIconData = Icons.arrow_forward,
    this.indentPlusLabel,
    this.indentPlusTooltip = kIndentPlusTooltip,
    this.indentMinusIconData = Icons.arrow_back,
    this.indentMinusLabel,
    this.indentMinusTooltip = kIndentMinusTooltip,
    this.alignIconData = Icons.format_align_left,
    this.alignLabel = kAlignLabel,
    this.alignTooltip = kAlignTooltip,
    this.leftAlignIconData = Icons.format_align_left,
    this.leftAlignLabel,
    this.leftAlignTooltip = kLeftAlignTooltip,
    this.rightAlignIconData = Icons.format_align_right,
    this.rightAlignLabel,
    this.rightAlignTooltip = kRightAlignTooltip,
    this.centerAlignIconData = Icons.format_align_center,
    this.centerAlignLabel,
    this.centerAlignTooltip = kCenterAlignTooltip,
    this.justifyAlignIconData = Icons.format_align_justify,
    this.justifyAlignLabel,
    this.justifyAlignTooltip = kJustifyAlignTooltip,
  }) : super(key: key);

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

  /// Shape of popup buttons
  final OutlinedBorder? popupShape;

  /// Elevation of popup buttons
  final double? popupElevation;

  /// Padding between popup buttons
  final EdgeInsetsGeometry? popupPadding;

  /// Color of popup button background when not selected
  final Color? popupPrimary;

  /// Color of popup button foreground when not selected
  final Color? popupOnPrimary;

  /// Color of popup button foreground when disabled
  final Color? popupOnSurface;

  /// Color of popup buttons shadow
  final Color? popupShadowColor;

  /// Textstyle of popup button label
  final TextStyle? popupTextStyle;

  /// Color of toolbar button background when not selected
  final Color? toolbarPrimary;

  /// Color of toolbar button foreground when not selected
  final Color? toolbarOnPrimary;

  /// Color of toolbar button foreground when disabled
  final Color? toolbarOnSurface;

  /// Color of toolbar shadow
  final Color? toolbarShadowColor;

  /// Elevation of toolbar buttons
  final double? toolbarButtonElevation;

  /// Textstyle of toolbar button labels
  final TextStyle? toolbarTextStyle;

  /// Padding between toolbar buttons
  final EdgeInsetsGeometry? toolbarPadding;

  /// Shape of toolbar buttons
  final OutlinedBorder? toolbarButtonShape;

  /// Whether to deselect items after popup button presses.
  /// Defaults to false.
  final bool dimissOnFinish;

  /// Style toolbar button IconData, defaults to [CommunityMaterialIcons.format_font]
  final IconData styleIconData;

  /// Style toolbar button label, defaults to 'Style'
  final String styleLabel;

  /// Style toolbar button tooltip, defaults to 'Change text style'
  final String styleTooltip;

  /// Bold popup button IconData, defaults to [Icons.format_bold]
  final IconData boldIconData;

  /// Bold popup button label, defaults to [Null]
  final String? boldLabel;

  /// Bold popup button tooltip, defaults to 'Make text bold'
  final String boldTooltip;

  /// Italic popup button IconData, defaults to [Icons.format_italic]
  final IconData italicIconData;

  /// Italic popup button label, defaults to [Null]
  final String? italicLabel;

  /// Italic popup button tooltip, defaults to 'Make text italic'
  final String italicTooltip;

  /// Underline popup button IconData, defaults to [Icons.format_underline]
  final IconData underlineIconData;

  /// Underline popup button label, defaults to [Null]
  final String? underlineLabel;

  /// Underline popup button tooltip, defaults to 'Underline text'
  final String underlineTooltip;

  /// Strikethrough popup button IconData, defaults to [Icons.format_strikethrough]
  final IconData strikeThruIconData;

  /// Strikethrough popup button label, defaults to [Null]
  final String? strikeThruLabel;

  /// Strikethrough popup button tooltip, defaults to 'Strike thru text'
  final String strikeThruTooltip;

  //List toolbar button IconData, defaults to [CommunityMaterialIcons.view_list]
  final IconData listIconData;

  /// List toolbar button label, defaults to 'List'
  final String listLabel;

  /// List toolbar button tooltip, defaults to 'Format text as a List'
  final String listTooltip;

  /// Numbered list popup button IconData, defaults to [Icons.format_list_numbered]
  final IconData numberedListIconData;

  /// Numbered list popup button label, defaults to [Null]
  final String? numberedListLabel;

  /// Numbered list popup button tooltip, defaults to 'Format text as numbered list'
  final String numberedListTooltip;

  /// Bulleted list popup button IconData, defaults to [Icons.format_list_bulleted]
  final IconData bulletedListIconData;

  /// Bulleted list popup button label, defaults to [Null]
  final String? bulletedListLabel;

  /// Bulleted list popup button tooltip, defaults to 'Format text as bulleted list'
  final String bulletedListTooltip;

  //Block toolbar button IconData, defaults to [CommunityMaterialIcons.format_pilcrow]
  final IconData blockIconData;

  /// Block toolbar button label, defaults to 'Block
  final String blockLabel;

  /// Block toolbar button tooltip, defaults to 'Format text block'
  final String blockTooltip;

  /// Quote block popup button IconData, defaults to [Icons.format_quote]
  final IconData quoteBlockIconData;

  /// Quote block popup button label, defaults to [Null]
  final String? quoteBlockLabel;

  /// Quote block popup button tooltip, defaults to 'Format text as quote block'
  final String quoteBlockTooltip;

  /// Code block popup button IconData, defaults to [Icons.code]
  final IconData codeBlockIconData;

  /// Code block popup button label, defaults to [Null]
  final String? codeBlocklabel;

  /// code block popup button tooltip, defaults to 'Format text as code block',
  final String codeBlockTooltip;

  // Insert toolbar button IconData, defaults to [Icons.attachment_sharp]
  final IconData insertIconData;

  /// Insert toolbar button label, defaults to 'Insert'
  final String insertLabel;

  /// Insert toolbar button tooltip, defaults to 'Insert link or web image'
  final String insertTooltip;

  /// Text link popup button IconData, defaults to [Icons.link]
  final IconData textLinkIconData;

  /// Text link popup button label, defaults to [Null]
  final String? textLinkLabel;

  /// Text link popup button tooltip, defaults to 'Format text as a link'
  final String textLinkTooltip;

  /// Image link popup button IconData, defaults to [Icons.image]
  final IconData imageLinkIconData;

  /// Image link popup button label, defaults to [Null]
  final String? imageLinkLabel;

  /// Image link popup button tooltip, defaults to 'Insert web image'
  final String imageLinkTooltip;

  /// Link dialog title, defaults to 'Text Link'
  final String textLinkDialogTitle;

  /// Link dialog text field label, defaults to 'Display text'
  final String textLinkDialogTextLabel;

  /// Link dialog url field label, defaults to 'Link'
  final String textLinkDialogUrlLabel;

  /// Link dialog cancel button label, defaults to 'Cancel'
  final String textLinkDialogCancelLabel;

  /// Link dialog accept button label, defaults to 'OK'
  final String textLinkDialogAcceptLabel;

  /// Image dialog title, defaults to 'Image Link'
  final String imageLinkDialogTitle;

  /// Image dialog url field label, defaults to 'Link'
  final String imageLinkDialogUrlLabel;

  /// Image dialog cancel button label, defaults to 'Cancel'
  final String imageLinkDialogCancelLabel;

  /// Image dialog accept button label, defaults to 'OK'
  final String imageLinkDialogAcceptLabel;

  /// Size toolbar button IconData, defaults to [Icons.format_size]
  final IconData sizeIconData;

  /// Size toolbar button label, defaults to 'Size'
  final String sizeLabel;

  /// Size toolbar button tooltip, defaults to 'Change text size'
  final String sizeTooltip;

  /// Size plus popup button IconData, defaults to [Icons.arrow_upward]
  final IconData sizePlusIconData;

  /// Size plus popup button label, defaults to [Null]
  final String? sizePlusLabel;

  /// Size plus popup button tooltip, defaults to 'Increase font size'
  final String sizePlusTooltip;

  /// Size minus popup button IconData, defaults to [Icons.arrow_downward]
  final IconData sizeMinusIconData;

  /// Size minus popup button label, defaults to [Null]
  final String? sizeMinusLabel;

  /// Size minus popup button tooltip, defaults to 'Decrease font size'
  final String sizeMinusTooltip;

  /// Indent toolbar button IconData, defaults to [Icons.format_indent_increase]
  final IconData indentIconData;

  /// Indent toolbar button label, defaults to 'Indent'
  final String indentLabel;

  /// Indent toolbar button tooltip, defaults to 'Change indentation'
  final String indentTooltip;

  /// Indent plus popup button IconData, defaults to [Icons.arrow_forward]
  final IconData indentPlusIconData;

  /// Indent plus popup button label, defaults to [Null]
  final String? indentPlusLabel;

  /// Indent plus popup button tooltip, defaults to 'Increase indentation'
  final String indentPlusTooltip;

  /// Indent plus popup button IconData, defaults to [Icons.arrow_back]
  final IconData indentMinusIconData;

  /// Indent plus popup button label, defaults to [Null]
  final String? indentMinusLabel;

  /// Indent plus popup button tooltip, defaults to 'Decrease indentation'
  final String indentMinusTooltip;

  /// Align toolbar button IconData, defaults to [Icons.format_align_left]
  final IconData alignIconData;

  /// Align toolbar button label, defaults to 'Align'
  final String alignLabel;

  /// Align toolbar button tooltip, defaults to 'Align text'
  final String alignTooltip;

  /// Left align popup button IconData, defaults to [Icons.format_align_left]
  final IconData leftAlignIconData;

  /// Left align popup button label, defaults to [Null]
  final String? leftAlignLabel;

  /// Left align popup button tooltip, defaults to 'Left align text'
  final String leftAlignTooltip;

  /// Right align popup button IconData, defaults to [Icons.format_align_right]
  final IconData rightAlignIconData;

  /// Right align popup button label, defaultst to [Null]
  final String? rightAlignLabel;

  /// Right align popup button tooltip, defaults to 'Right align text'
  final String rightAlignTooltip;

  /// Center align popup button IconData, defaults to [Icons.format_align_center]
  final IconData centerAlignIconData;

  /// Center align popup button label, defaultst to [Null]
  final String? centerAlignLabel;

  /// Center align popup button tooltip, defaults to 'Center align text'
  final String centerAlignTooltip;

  /// Justify align popup button IconData, defaults to [Icons.format_align_justify]
  final IconData justifyAlignIconData;

  /// Justify align popup button label, defaultst to [Null]
  final String? justifyAlignLabel;

  /// Justify align popup button tooltip, defaults to 'Justify align text'
  final String justifyAlignTooltip;

  @override
  State<StatefulWidget> createState() => RichTextToolbarState();
}

class RichTextToolbarState extends State<RichTextToolbar> {
  
  /// Determines tooltp display preference based on alignment
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

  /// Disposes of style controller
  final Disposer _styleDisposer = Disposer();

  /// Disposes of size controller
  final Disposer _sizeDisposer = Disposer();

  /// Disposes of indent controller
  final Disposer _indentDisposer = Disposer();

  /// Disposes of list controller
  final Disposer _listDisposer = Disposer();

  /// Disposes of block controller
  final Disposer _blockDisposer = Disposer();

  /// Disposes of insert controller
  final Disposer _insertDisposer = Disposer();

  /// Disposes of align controller
  final Disposer _alignDisposer = Disposer();

  /// Controls toolbar button selection
  final ItemSelector _itemSelector = ItemSelector();

  /// Deselects items
  void _onFinished() => _itemSelector.selected = null;

  @override
  Widget build(BuildContext context) {
    final itemStyle = IconicButtonTheme.of(context).copyWith(
      shape: widget.popupShape,
      elevation: widget.popupElevation,
      padding: widget.popupPadding,
      primary: widget.popupPrimary,
      onPrimary: widget.popupOnPrimary,
      onSurface: widget.popupOnSurface,
      shadowColor: widget.popupShadowColor,
      textStyle: widget.popupTextStyle,
    ).style;
    final preferBelow = _preferBelow();
    return FloatingToolbar(
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
      preferTooltipBelow: preferBelow,
      primary: widget.toolbarPrimary,
      onPrimary: widget.toolbarOnPrimary,
      onSurface: widget.toolbarOnSurface,
      shadowColor: widget.toolbarShadowColor,
      buttonElevation: widget.toolbarButtonElevation,
      textStyle: widget.toolbarTextStyle,
      padding: widget.toolbarPadding,
      buttonShape: widget.toolbarButtonShape,
      modalBarrier: false,
      itemSelector: _itemSelector,
      items: [
        StyleItem(
          controller: widget.controller,
          disposer: _styleDisposer,
          preferBelow: preferBelow,
          style: itemStyle,
          onFinished: widget.dimissOnFinish ? _onFinished : null,
          iconData: widget.styleIconData,
          label: widget.styleLabel,
          tooltip: widget.styleTooltip,
          boldIconData: widget.boldIconData,
          boldLabel: widget.boldLabel,
          boldTooltip: widget.boldTooltip,
          italicIconData: widget.italicIconData,
          italicLabel: widget.italicLabel,
          italicTooltip: widget.italicTooltip,
          underlineIconData: widget.underlineIconData,
          underlineLabel: widget.underlineLabel,
          underlineTooltip: widget.underlineTooltip,
          strikeThruIconData: widget.strikeThruIconData,
          strikeThruLabel: widget.strikeThruLabel,
          strikeThruTooltip: widget.strikeThruTooltip,
        ).build(),
        SizeItem(
          controller: widget.controller,
          disposer: _sizeDisposer,
          preferBelow: preferBelow,
          style: itemStyle,
          onFinished: widget.dimissOnFinish ? _onFinished : null,
          iconData: widget.sizeIconData,
          label: widget.sizeLabel,
          tooltip: widget.sizeTooltip,
          sizePlusIconData: widget.sizePlusIconData,
          sizePlusLabel: widget.sizePlusLabel,
          sizePlusTooltip: widget.sizePlusTooltip,
          sizeMinusIconData: widget.sizeMinusIconData,
          sizeMinusLabel: widget.sizeMinusLabel,
          sizeMinusTooltip: widget.sizeMinusTooltip,
        ).build(),
        IndentItem(
          controller: widget.controller,
          disposer: _indentDisposer,
          preferBelow: preferBelow,
          style: itemStyle,
          onFinished: widget.dimissOnFinish ? _onFinished : null,
          iconData: widget.indentIconData,
          label: widget.indentLabel,
          tooltip: widget.indentTooltip,
          indentPlusIconData: widget.indentPlusIconData,
          indentPlusLabel: widget.indentPlusLabel,
          indentPlusTooltip: widget.indentPlusTooltip,
          indentMinusIconData: widget.indentMinusIconData,
          indentMinusLabel: widget.indentMinusLabel,
          indentMinusTooltip: widget.indentMinusTooltip,
        ).build(),
        ListItem(
          controller: widget.controller,
          disposer: _listDisposer,
          preferBelow: preferBelow,
          style: itemStyle,
          onFinished: widget.dimissOnFinish ? _onFinished : null,
          iconData: widget.listIconData,
          label: widget.listLabel,
          tooltip: widget.listTooltip,
          numberedListIconData: widget.numberedListIconData,
          numberedListLabel: widget.numberedListLabel,
          numberedListTooltip: widget.numberedListTooltip,
          bulletedListIconData: widget.bulletedListIconData,
          bulletedListLabel: widget.bulletedListLabel,
          bulletedListTooltip: widget.bulletedListTooltip,
        ).build(),
        BlockItem(
          controller: widget.controller,
          disposer: _blockDisposer,
          preferBelow: preferBelow,
          style: itemStyle,
          onFinished: widget.dimissOnFinish ? _onFinished : null,
          iconData: widget.blockIconData,
          label: widget.blockLabel,
          tooltip: widget.blockTooltip,
          quoteBlockIconData: widget.quoteBlockIconData,
          quoteBlockLabel: widget.quoteBlockLabel,
          quoteBlockTooltip: widget.quoteBlockTooltip,
          codeBlockIconData: widget.codeBlockIconData,
          codeBlocklabel: widget.codeBlocklabel,
          codeBlockTooltip: widget.codeBlockTooltip,
        ).build(),
        AlignItem(
          controller: widget.controller,
          disposer: _alignDisposer,
          preferBelow: preferBelow,
          style: itemStyle,
          onFinished: widget.dimissOnFinish ? _onFinished : null,
          iconData: widget.alignIconData,
          label: widget.alignLabel,
          tooltip: widget.alignTooltip,
          leftAlignIconData: widget.leftAlignIconData,
          leftAlignLabel: widget.leftAlignLabel,
          leftAlignTooltip: widget.leftAlignTooltip,
          rightAlignIconData: widget.rightAlignIconData,
          rightAlignLabel: widget.rightAlignLabel,
          rightAlignTooltip: widget.rightAlignTooltip,
          centerAlignIconData: widget.centerAlignIconData,
          centerAlignLabel: widget.centerAlignLabel,
          centerAlignTooltip: widget.centerAlignTooltip,
          justifyAlignIconData: widget.justifyAlignIconData,
          justifyAlignLabel: widget.justifyAlignLabel,
          justifyAlignTooltip: widget.justifyAlignTooltip,
        ).build(),
        InsertItem(
          controller: widget.controller,
          disposer: _insertDisposer,
          preferBelow: preferBelow,
          style: itemStyle,
          onFinished: widget.dimissOnFinish ? _onFinished : null,
          iconData: widget.insertIconData,
          label: widget.insertLabel,
          tooltip: widget.insertTooltip,
          textLinkIconData: widget.textLinkIconData,
          textLinkLabel: widget.textLinkLabel,
          textLinkTooltip: widget.textLinkTooltip,
          textLinkDialogTitle: widget.textLinkDialogTitle,
          textLinkDialogTextLabel: widget.textLinkDialogTextLabel,
          textLinkDialogUrlLabel: widget.textLinkDialogUrlLabel,
          textLinkDialogCancelLabel: widget.textLinkDialogCancelLabel,
          textLinkDialogAcceptLabel: widget.textLinkDialogAcceptLabel,
          imageLinkIconData: widget.imageLinkIconData,
          imageLinkLabel: widget.imageLinkLabel,
          imageLinkTooltip: widget.imageLinkTooltip,
          imageLinkDialogTitle: widget.imageLinkDialogTitle,
          imageLinkDialogUrlLabel: widget.imageLinkDialogUrlLabel,
          imageLinkDialogCancelLabel: widget.imageLinkDialogCancelLabel,
          imageLinkDialogAcceptLabel: widget.imageLinkDialogAcceptLabel,
        ).build(),
      ],
    );
  }

  @override
  void dispose() {
    _styleDisposer.dispose();
    _sizeDisposer.dispose();
    _indentDisposer.dispose();
    _listDisposer.dispose();
    _blockDisposer.dispose();
    _insertDisposer.dispose();
    _alignDisposer.dispose();
    _itemSelector.dispose();
    super.dispose();
  }
}
