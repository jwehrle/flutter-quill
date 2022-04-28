import 'package:flutter_quill/widgets/toolbar/models/types.dart';

/// Keys

const String kBoldItemKey = 'item_key_bold';
const String kItalicItemKey = 'item_key_italic';
const String kUnderItemKey = 'item_key_underline';
const String kStrikeItemKey = 'item_key_strike';
const String kQuoteItemKey = 'item_key_quote';
const String kCodeItemKey = 'item_key_code';
const String kNumberItemKey = 'item_key_number';
const String kBulletItemKey = 'item_key_bullet';
const String kOptionItemKey = 'item_key_option';
const String kLinkItemKey = 'item_key_link';
const String kSizeItemKey = 'item_key_size';
const String kSizePlusItemKey = 'item_key_size_plus';
const String kSizeMinusItemKey = 'item_key_size_plus';
const String kIndentItemKey = 'item_key_indent';
const String kIndentPlusItemKey = 'item_key_indent_plus';
const String kIndentMinusItemKey = 'item_key_indent_plus';
const String kStyleItemKey = 'item_key_style';
const String kBlockItemKey = 'item_key_section';
const String kListItemKey = 'item_key_list';
const String kAlignItemKey = 'item_key_align';

String popItemKey(ToolbarPopupType type) {
  switch (type) {
    case ToolbarPopupType.align:
      return kAlignItemKey;
    case ToolbarPopupType.block:
      return kBlockItemKey;
    case ToolbarPopupType.indent:
      return kIndentItemKey;
    case ToolbarPopupType.list:
      return kListItemKey;
    case ToolbarPopupType.size:
      return kSizeItemKey;
    case ToolbarPopupType.style:
      return kStyleItemKey;
  }
}

String toolbarToggleItemKey(ToolbarToggleType type) {
  switch (type) {
    case ToolbarToggleType.bold:
      return kBoldItemKey;
    case ToolbarToggleType.bullet:
      return kBulletItemKey;
    case ToolbarToggleType.code:
      return kCodeItemKey;
    case ToolbarToggleType.italic:
      return kItalicItemKey;
    case ToolbarToggleType.link:
      return kLinkItemKey;
    case ToolbarToggleType.number:
      return kNumberItemKey;
    case ToolbarToggleType.quote:
      return kQuoteItemKey;
    case ToolbarToggleType.strike:
      return kStrikeItemKey;
    case ToolbarToggleType.under:
      return kUnderItemKey;
  }
}

/// Labels

const String kBoldLabel = 'Bold';
const String kItalicLabel = 'Italic';
const String kUnderLabel = 'Under';
const String kStrikeLabel = 'Strike';
const String kQuoteLabel = 'Quote';
const String kCodeLabel = 'Code';
const String kNumberLabel = 'Number';
const String kBulletLabel = 'Bullet';
const String kSizeLabel = 'Size';
const String kIndentLabel = 'Indent';
const String kStyleLabel = 'Style';
const String kBlockLabel = 'Block';
const String kListLabel = 'List';
const String kLinkLabel = 'Link';
const String kAlignLabel = 'Align';

/// Tooltips

const String kBoldTooltip = 'Make text bold';
const String kItalicTooltip = 'Make text italic';
const String kUnderTooltip = 'Underline text';
const String kStrikeTooltip = 'Strike_thru text';
const String kQuoteTooltip = 'Format text as quote block';
const String kCodeTooltip = 'Format text as code block';
const String kNumberTooltip = 'Format text as numbered list';
const String kBulletTooltip = 'Format text as bulleted list';
const String kSizePlusTooltip = 'Increase font size';
const String kSizeMinusTooltip = 'Decrease font size';
const String kIndentPlusTooltip = 'Increase indentation';
const String kIndentMinusTooltip = 'Decrease indentation';
const String kSizeTooltip = 'Change text size';
const String kIndentTooltip = 'Change indentation';
const String kStyleTooltip = 'Change text style';
const String kBlockTooltip = 'Format text block';
const String kListTooltip = 'Format text as a List';
const String kLinkTooltip = 'Format text as a link';
const String kAlignTooltip = 'Align text';
const String kLeftAlignTooltip = 'Left align text';
const String kRightAlignTooltip = 'Right align text';
const String kCenterAlignTooltip = 'Center align text';
const String kJustifyAlignTooltip = 'Justify align text';
