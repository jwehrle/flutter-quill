import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/popup_buttons/popup_action_button.dart';
import 'package:flutter_quill/widgets/toolbar/popup_buttons/popup_toggle_button.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_buttons/buttons.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';
import 'package:floating_toolbar/toolbar.dart';

List<Widget> toolbarButtons({
  required RichTextToolbarType type,
  required QuillController controller,
  OptionButtonData? optionButtonParameters,
}) {
  switch (type) {
    case RichTextToolbarType.condensed:
      return [
        ToolbarPopupButton.style(controller: controller),
        ToolbarPopupButton.size(controller: controller),
        ToolbarPopupButton.indent(controller: controller),
        ToolbarPopupButton.list(controller: controller),
        ToolbarPopupButton.block(controller: controller),
        ToolbarLinkButton(controller: controller),
      ];
    case RichTextToolbarType.expanded:
      return [
        ToolbarToggleButton.bold(controller: controller),
        ToolbarToggleButton.italic(controller: controller),
        ToolbarToggleButton.under(controller: controller),
        ToolbarToggleButton.strike(controller: controller),
        ToolbarPopupButton.size(controller: controller),
        ToolbarPopupButton.indent(controller: controller),
        ToolbarToggleButton.bullet(controller: controller),
        ToolbarToggleButton.number(controller: controller),
        ToolbarToggleButton.quote(controller: controller),
        ToolbarToggleButton.code(controller: controller),
        ToolbarLinkButton(controller: controller),
      ];
    case RichTextToolbarType.condensedOption:
      assert(
        optionButtonParameters != null,
        'OptionalButtonParameters must not be null',
      );
      return [
        ToolbarOptionButton(optionButtonData: optionButtonParameters!),
        ToolbarPopupButton.style(controller: controller),
        ToolbarPopupButton.size(controller: controller),
        ToolbarPopupButton.indent(controller: controller),
        ToolbarPopupButton.list(controller: controller),
        ToolbarPopupButton.block(controller: controller),
        ToolbarLinkButton(controller: controller),
      ];
    case RichTextToolbarType.expandedOption:
      assert(
        optionButtonParameters != null,
        'OptionalButtonParameters must not be null',
      );
      return [
        ToolbarOptionButton(optionButtonData: optionButtonParameters!),
        ToolbarToggleButton.bold(controller: controller),
        ToolbarToggleButton.italic(controller: controller),
        ToolbarToggleButton.under(controller: controller),
        ToolbarToggleButton.strike(controller: controller),
        ToolbarPopupButton.size(controller: controller),
        ToolbarPopupButton.indent(controller: controller),
        ToolbarToggleButton.bullet(controller: controller),
        ToolbarToggleButton.number(controller: controller),
        ToolbarToggleButton.quote(controller: controller),
        ToolbarToggleButton.code(controller: controller),
        ToolbarLinkButton(controller: controller),
      ];
  }
}

List<PopupFlex> toolbarPopups({
  required RichTextToolbarType type,
  required QuillController controller,
}) {
  switch (type) {
    case RichTextToolbarType.condensed:
      return [
        stylePopupFlex(controller: controller),
        sizePopupFlex(controller: controller),
        indentPopupFlex(controller: controller),
        listPopupFlex(controller: controller),
        blockPopupFlex(controller: controller),
        PopupFlex.empty(itemKey: kLinkItemKey),
      ];
    case RichTextToolbarType.expanded:
      return [
        PopupFlex.empty(itemKey: kBoldItemKey),
        PopupFlex.empty(itemKey: kItalicItemKey),
        PopupFlex.empty(itemKey: kUnderItemKey),
        PopupFlex.empty(itemKey: kStrikeItemKey),
        sizePopupFlex(controller: controller),
        indentPopupFlex(controller: controller),
        PopupFlex.empty(itemKey: kBulletItemKey),
        PopupFlex.empty(itemKey: kNumberItemKey),
        PopupFlex.empty(itemKey: kQuoteItemKey),
        PopupFlex.empty(itemKey: kCodeItemKey),
        PopupFlex.empty(itemKey: kLinkItemKey),
      ];
    case RichTextToolbarType.condensedOption:
      return [
        PopupFlex.empty(itemKey: kOptionItemKey),
        stylePopupFlex(controller: controller),
        sizePopupFlex(controller: controller),
        indentPopupFlex(controller: controller),
        listPopupFlex(controller: controller),
        blockPopupFlex(controller: controller),
        PopupFlex.empty(itemKey: kLinkItemKey),
      ];
    case RichTextToolbarType.expandedOption:
      return [
        PopupFlex.empty(itemKey: kOptionItemKey),
        PopupFlex.empty(itemKey: kBoldItemKey),
        PopupFlex.empty(itemKey: kItalicItemKey),
        PopupFlex.empty(itemKey: kUnderItemKey),
        PopupFlex.empty(itemKey: kStrikeItemKey),
        sizePopupFlex(controller: controller),
        indentPopupFlex(controller: controller),
        PopupFlex.empty(itemKey: kBulletItemKey),
        PopupFlex.empty(itemKey: kNumberItemKey),
        PopupFlex.empty(itemKey: kQuoteItemKey),
        PopupFlex.empty(itemKey: kCodeItemKey),
        PopupFlex.empty(itemKey: kLinkItemKey),
      ];
  }
}

PopupFlex stylePopupFlex({required QuillController controller}) {
  return PopupFlex(
    itemKey: kStyleItemKey,
    buttons: [
      PopupToggleButton(
        type: ToggleType.bold,
        controller: controller,
      ),
      PopupToggleButton(
        type: ToggleType.italic,
        controller: controller,
      ),
      PopupToggleButton(
        type: ToggleType.under,
        controller: controller,
      ),
      PopupToggleButton(
        type: ToggleType.strike,
        controller: controller,
      ),
    ],
  );
}

PopupFlex sizePopupFlex({required QuillController controller}) {
  return PopupFlex(
    itemKey: kSizeItemKey,
    buttons: [
      PopupActionButton(
        type: PopupActionType.sizePlus,
        controller: controller,
      ),
      PopupActionButton(
        type: PopupActionType.sizeMinus,
        controller: controller,
      ),
    ],
  );
}

PopupFlex indentPopupFlex({required QuillController controller}) {
  return PopupFlex(
    itemKey: kIndentItemKey,
    buttons: [
      PopupActionButton(
        type: PopupActionType.indentPlus,
        controller: controller,
      ),
      PopupActionButton(
        type: PopupActionType.indentMinus,
        controller: controller,
      )
    ],
  );
}

PopupFlex listPopupFlex({required QuillController controller}) {
  return PopupFlex(
    itemKey: kListItemKey,
    buttons: [
      PopupToggleButton(
        type: ToggleType.number,
        controller: controller,
      ),
      PopupToggleButton(
        type: ToggleType.bullet,
        controller: controller,
      ),
    ],
  );
}

PopupFlex blockPopupFlex({required QuillController controller}) {
  return PopupFlex(
    itemKey: kBlockItemKey,
    buttons: [
      PopupToggleButton(
        type: ToggleType.quote,
        controller: controller,
      ),
      PopupToggleButton(
        type: ToggleType.code,
        controller: controller,
      ),
    ],
  );
}

Attribute? incrementSize(Attribute? attribute) {
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
}

Attribute? incrementIndent(Attribute? attribute) {
  if (attribute == null) {
    return Attribute.indentL1;
  }
  if (attribute == Attribute.indentL3) {
    return null;
  }
  return Attribute.getIndentLevel(attribute.value + 1);
}

Attribute? decrementIndent(Attribute? attribute) {
  if (attribute == null) {
    return null;
  }
  if (attribute == Attribute.indentL1) {
    return Attribute.clone(Attribute.indentL1, null);
  }
  return Attribute.getIndentLevel(attribute.value - 1);
}
