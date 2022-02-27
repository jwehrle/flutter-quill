import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/keyboard_button.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/link_toolbar_button.dart';
import 'package:flutter_quill/widgets/toolbar/popup/popup_button.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/toggle_button.dart';
import 'package:flutter_quill/widgets/toolbar/popup/popup_flex.dart';

class ToolbarItem {
  final String itemKey;
  Widget button;
  final PopupFlex popUp;

  @override
  bool operator ==(Object other) =>
      other is ToolbarItem ? this.itemKey == other.itemKey : false;

  @override
  int get hashCode => itemKey.hashCode;

  ToolbarItem({
    required this.itemKey,
    required this.button,
    required this.popUp,
  });

  ToolbarItem.bold({required QuillController controller})
      : this.itemKey = kBoldItemKey,
        this.button = ToggleButton.bold(controller: controller),
        this.popUp = PopupFlex.bold();

  ToolbarItem.italic({required QuillController controller})
      : this.itemKey = kItalicItemKey,
        this.button = ToggleButton.italic(controller: controller),
        this.popUp = PopupFlex.italic();

  ToolbarItem.under({required QuillController controller})
      : this.itemKey = kUnderItemKey,
        this.button = ToggleButton.under(controller: controller),
        this.popUp = PopupFlex.under();

  ToolbarItem.strike({required QuillController controller})
      : this.itemKey = kStrikeItemKey,
        this.button = ToggleButton.strike(controller: controller),
        this.popUp = PopupFlex.strike();

  ToolbarItem.size({required QuillController controller})
      : this.itemKey = kSizeItemKey,
        this.button = PopupButton.size(controller: controller),
        this.popUp = PopupFlex.size(controller: controller);

  ToolbarItem.indent({required QuillController controller})
      : this.itemKey = kIndentItemKey,
        this.button = PopupButton.indent(controller: controller),
        this.popUp = PopupFlex.indent(controller: controller);

  ToolbarItem.style({required QuillController controller})
      : this.itemKey = kStyleItemKey,
        this.button = PopupButton.style(controller: controller),
        this.popUp = PopupFlex.style(controller: controller);

  ToolbarItem.list({required QuillController controller})
      : this.itemKey = kListItemKey,
        this.button = PopupButton.list(controller: controller),
        this.popUp = PopupFlex.list(controller: controller);

  ToolbarItem.block({required QuillController controller})
      : this.itemKey = kBlockItemKey,
        this.button = PopupButton.block(controller: controller),
        this.popUp = PopupFlex.block(controller: controller);

  ToolbarItem.bullet({required QuillController controller})
      : this.itemKey = kBulletItemKey,
        this.button = ToggleButton.bullet(controller: controller),
        this.popUp = PopupFlex.bullet();

  ToolbarItem.number({required QuillController controller})
      : this.itemKey = kNumberItemKey,
        this.button = ToggleButton.number(controller: controller),
        this.popUp = PopupFlex.number();

  ToolbarItem.quote({required QuillController controller})
      : this.itemKey = kQuoteItemKey,
        this.button = ToggleButton.quote(controller: controller),
        this.popUp = PopupFlex.quote();

  ToolbarItem.code({required QuillController controller})
      : this.itemKey = kCodeItemKey,
        this.button = ToggleButton.code(controller: controller),
        this.popUp = PopupFlex.code();

  ToolbarItem.keyboard({required FocusNode focusNode})
      : this.itemKey = kKeyboardItemKey,
        this.button = KeyboardButton(focusNode: focusNode),
        this.popUp = PopupFlex.empty(itemKey: kKeyboardItemKey);

  ToolbarItem.link({required QuillController controller})
      : this.itemKey = kLinkItemKey,
        this.button = LinkToolbarButton(controller: controller),
        this.popUp = PopupFlex.empty(itemKey: kLinkItemKey);
}
