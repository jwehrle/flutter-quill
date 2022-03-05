import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_buttons/buttons.dart';
import 'package:flutter_quill/widgets/toolbar/flexes/popup_flex.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

Alignment convertAlignment(ToolbarAlignment alignment) {
  switch (alignment) {
    case ToolbarAlignment.bottomCenter:
      return Alignment.bottomCenter;
    case ToolbarAlignment.topCenter:
      return Alignment.topCenter;
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.leftTop:
      return Alignment.topLeft;
    case ToolbarAlignment.leftCenter:
      return Alignment.centerLeft;
    case ToolbarAlignment.bottomLeft:
    case ToolbarAlignment.leftBottom:
      return Alignment.bottomLeft;
    case ToolbarAlignment.topRight:
    case ToolbarAlignment.rightTop:
      return Alignment.topRight;
    case ToolbarAlignment.rightCenter:
      return Alignment.centerRight;
    case ToolbarAlignment.bottomRight:
    case ToolbarAlignment.rightBottom:
      return Alignment.bottomRight;
  }
}

Axis toolbarAxisFromAlignment(ToolbarAlignment alignment) {
  switch (alignment) {
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.topCenter:
    case ToolbarAlignment.topRight:
    case ToolbarAlignment.bottomLeft:
    case ToolbarAlignment.bottomCenter:
    case ToolbarAlignment.bottomRight:
      return Axis.horizontal;
    case ToolbarAlignment.leftTop:
    case ToolbarAlignment.leftCenter:
    case ToolbarAlignment.leftBottom:
    case ToolbarAlignment.rightTop:
    case ToolbarAlignment.rightCenter:
    case ToolbarAlignment.rightBottom:
      return Axis.vertical;
  }
}

int toolbarItemCount(ToolbarType type) {
  switch (type) {
    case ToolbarType.condensed:
      return 6;
    case ToolbarType.expanded:
      return 11;
    case ToolbarType.condensedOption:
      return 7;
    case ToolbarType.expandedOption:
      return 12;
  }
}

List<Widget> toolbarButtons({
  required ToolbarType type,
  required QuillController controller,
  IconData? optionIconData,
  String? optionLabel,
  String? optionTooltip,
  VoidCallback? optionOnPressed,
  ValueNotifier<ToggleState>? optionToggleStateNotifier,
}) {
  switch (type) {
    case ToolbarType.condensed:
      return List<Widget>.unmodifiable([
        ToolbarPopupButton.style(controller: controller),
        ToolbarPopupButton.size(controller: controller),
        ToolbarPopupButton.indent(controller: controller),
        ToolbarPopupButton.list(controller: controller),
        ToolbarPopupButton.block(controller: controller),
        ToolbarLinkButton(controller: controller),
      ]);
    case ToolbarType.expanded:
      return List<Widget>.unmodifiable([
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
      ]);
    case ToolbarType.condensedOption:
      assert(
        optionIconData != null,
        'optionIconData must not be null',
      );
      assert(
        optionLabel != null,
        'optionLabel must not be null',
      );
      assert(
        optionOnPressed != null,
        'optionOnPressed must not be null',
      );
      assert(
        optionToggleStateNotifier != null,
        'optionToggleStateNotifier must not be null',
      );
      return List<Widget>.unmodifiable([
        ToolbarOptionButton(
          iconData: optionIconData!,
          label: optionLabel!,
          tooltip: optionTooltip,
          onPressed: optionOnPressed!,
          toggleStateNotifier: optionToggleStateNotifier!,
        ),
        ToolbarPopupButton.style(controller: controller),
        ToolbarPopupButton.size(controller: controller),
        ToolbarPopupButton.indent(controller: controller),
        ToolbarPopupButton.list(controller: controller),
        ToolbarPopupButton.block(controller: controller),
        ToolbarLinkButton(controller: controller),
      ]);
    case ToolbarType.expandedOption:
      assert(
        optionIconData != null,
        'optionIconData must not be null',
      );
      assert(
        optionLabel != null,
        'optionLabel must not be null',
      );
      assert(
        optionOnPressed != null,
        'optionOnPressed must not be null',
      );
      assert(
        optionToggleStateNotifier != null,
        'optionToggleStateNotifier must not be null',
      );
      return List<Widget>.unmodifiable([
        ToolbarOptionButton(
          iconData: optionIconData!,
          label: optionLabel!,
          tooltip: optionTooltip,
          onPressed: optionOnPressed!,
          toggleStateNotifier: optionToggleStateNotifier!,
        ),
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
      ]);
  }
}

List<PopupFlex> toolbarPopups({
  required ToolbarType type,
  required QuillController controller,
}) {
  switch (type) {
    case ToolbarType.condensed:
      return List<PopupFlex>.unmodifiable([
        PopupFlex.style(controller: controller),
        PopupFlex.size(controller: controller),
        PopupFlex.indent(controller: controller),
        PopupFlex.list(controller: controller),
        PopupFlex.block(controller: controller),
        PopupFlex.empty(itemKey: kLinkItemKey),
      ]);
    case ToolbarType.expanded:
      return List<PopupFlex>.unmodifiable([
        PopupFlex.bold(),
        PopupFlex.italic(),
        PopupFlex.under(),
        PopupFlex.strike(),
        PopupFlex.size(controller: controller),
        PopupFlex.indent(controller: controller),
        PopupFlex.bullet(),
        PopupFlex.number(),
        PopupFlex.quote(),
        PopupFlex.code(),
        PopupFlex.empty(itemKey: kLinkItemKey),
      ]);
    case ToolbarType.condensedOption:
      return List<PopupFlex>.unmodifiable([
        PopupFlex.empty(itemKey: kOptionItemKey),
        PopupFlex.style(controller: controller),
        PopupFlex.size(controller: controller),
        PopupFlex.indent(controller: controller),
        PopupFlex.list(controller: controller),
        PopupFlex.block(controller: controller),
        PopupFlex.empty(itemKey: kLinkItemKey),
      ]);
    case ToolbarType.expandedOption:
      return List<PopupFlex>.unmodifiable([
        PopupFlex.empty(itemKey: kOptionItemKey),
        PopupFlex.bold(),
        PopupFlex.italic(),
        PopupFlex.under(),
        PopupFlex.strike(),
        PopupFlex.size(controller: controller),
        PopupFlex.indent(controller: controller),
        PopupFlex.bullet(),
        PopupFlex.number(),
        PopupFlex.quote(),
        PopupFlex.code(),
        PopupFlex.empty(itemKey: kLinkItemKey),
      ]);
  }
}

double itemOffsetFromEdge({
  required double toolbarOffset,
  required int itemsFromEdge,
  required Axis axis,
}) {
  toolbarOffset += itemsFromEdge * kToolbarTilePadding;
  switch (axis) {
    case Axis.horizontal:
      toolbarOffset += itemsFromEdge * kToolbarTileWidth;
      break;
    case Axis.vertical:
      toolbarOffset += itemsFromEdge * kToolbarTileHeight;
      break;
  }
  return toolbarOffset;
}

double toolbarCenterOffset({
  required int itemsCount,
  required Axis axis,
  required double containerSize,
}) {
  double tileSize;
  switch (axis) {
    case Axis.horizontal:
      tileSize = kToolbarTileWidth;
      break;
    case Axis.vertical:
      tileSize = kToolbarTileHeight;
      break;
  }
  double center = containerSize / 2.0;
  if (itemsCount.isEven) {
    //split padding
    center += kToolbarTilePadding / 2.0;
  } else {
    //split tile
    center -= tileSize / 2.0;
  }
  return center;
}

double itemCenterOffset({
  required int itemCount,
  required int index,
  required double tileSize,
}) {
  int centerIndex = (itemCount / 2).floor();
  int indexDiff = index - centerIndex;
  double offset = indexDiff * tileSize;
  offset += indexDiff * kToolbarTilePadding;
  return offset;
}

double toolbarOffset({
  required int itemsCount,
  required ToolbarAlignment alignment,
  required BoxConstraints constraints,
  double scrollOffset = 0.0,
}) {
  switch (alignment) {
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.bottomLeft:
    case ToolbarAlignment.topRight:
    case ToolbarAlignment.bottomRight:
    case ToolbarAlignment.leftTop:
    case ToolbarAlignment.rightTop:
    case ToolbarAlignment.leftBottom:
    case ToolbarAlignment.rightBottom:
      return kToolbarMargin + kToolbarTilePadding - scrollOffset;
    case ToolbarAlignment.topCenter:
    case ToolbarAlignment.bottomCenter:
      return toolbarCenterOffset(
        itemsCount: itemsCount,
        axis: Axis.horizontal,
        containerSize: constraints.maxWidth,
      );
    case ToolbarAlignment.leftCenter:
    case ToolbarAlignment.rightCenter:
      return toolbarCenterOffset(
        itemsCount: itemsCount,
        axis: Axis.vertical,
        containerSize: constraints.maxHeight,
      );
  }
}

double itemOffset({
  required double toolbarOffset,
  required ToolbarAlignment alignment,
  required int index,
  required int itemCount,
}) {
  switch (alignment) {
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.bottomLeft:
      return itemOffsetFromEdge(
        toolbarOffset: toolbarOffset,
        itemsFromEdge: index,
        axis: Axis.horizontal,
      );
    case ToolbarAlignment.topRight:
    case ToolbarAlignment.bottomRight:
      return itemOffsetFromEdge(
        toolbarOffset: toolbarOffset,
        itemsFromEdge: (itemCount - 1) - index,
        axis: Axis.horizontal,
      );
    case ToolbarAlignment.leftTop:
    case ToolbarAlignment.rightTop:
      return itemOffsetFromEdge(
        toolbarOffset: toolbarOffset,
        itemsFromEdge: index,
        axis: Axis.vertical,
      );
    case ToolbarAlignment.leftBottom:
    case ToolbarAlignment.rightBottom:
      return itemOffsetFromEdge(
        toolbarOffset: toolbarOffset,
        itemsFromEdge: (itemCount - 1) - index,
        axis: Axis.vertical,
      );
    case ToolbarAlignment.topCenter:
    case ToolbarAlignment.bottomCenter:
      return toolbarOffset +
          itemCenterOffset(
            index: index,
            itemCount: itemCount,
            tileSize: kToolbarTileWidth,
          );
    case ToolbarAlignment.leftCenter:
    case ToolbarAlignment.rightCenter:
      return toolbarOffset +
          itemCenterOffset(
            index: index,
            itemCount: itemCount,
            tileSize: kToolbarTileHeight,
          );
  }
}

PositionParameters itemPosition({
  required int index,
  required double toolbarOffset,
  required ToolbarAlignment alignment,
  required ToolbarType type,
}) {
  int count = toolbarItemCount(type);
  assert(index < count, 'Out of range error');
  double offset = itemOffset(
    toolbarOffset: toolbarOffset,
    alignment: alignment,
    index: index,
    itemCount: count,
  );
  double anchor = kToolbarTileHeight + (2.0 * kToolbarTilePadding);
  switch (alignment) {
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.topCenter:
      return PositionParameters(
        top: anchor,
        left: offset,
        right: null,
        bottom: null,
      );
    case ToolbarAlignment.topRight:
      return PositionParameters(
        top: anchor,
        left: null,
        right: offset,
        bottom: null,
      );
    case ToolbarAlignment.bottomLeft:
    case ToolbarAlignment.bottomCenter:
      return PositionParameters(
        top: null,
        left: offset,
        right: null,
        bottom: anchor,
      );
    case ToolbarAlignment.bottomRight:
      return PositionParameters(
        top: null,
        left: null,
        right: offset,
        bottom: anchor,
      );
    case ToolbarAlignment.leftTop:
    case ToolbarAlignment.leftCenter:
      return PositionParameters(
        top: offset,
        left: anchor,
        right: null,
        bottom: null,
      );
    case ToolbarAlignment.leftBottom:
      return PositionParameters(
        top: null,
        left: anchor,
        right: null,
        bottom: offset,
      );
    case ToolbarAlignment.rightTop:
    case ToolbarAlignment.rightCenter:
      return PositionParameters(
        top: offset,
        left: null,
        right: anchor,
        bottom: null,
      );
    case ToolbarAlignment.rightBottom:
      return PositionParameters(
        top: null,
        left: null,
        right: anchor,
        bottom: offset,
      );
  }
}

bool isReverse(ToolbarAlignment alignment) {
  switch (alignment) {
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.topCenter:
    case ToolbarAlignment.bottomLeft:
    case ToolbarAlignment.bottomCenter:
    case ToolbarAlignment.leftTop:
    case ToolbarAlignment.leftCenter:
    case ToolbarAlignment.rightTop:
    case ToolbarAlignment.rightCenter:
      return false;
    case ToolbarAlignment.topRight:
    case ToolbarAlignment.bottomRight:
    case ToolbarAlignment.leftBottom:
    case ToolbarAlignment.rightBottom:
      return true;
  }
}

double calculateToolbarSize({
  required int buttonCount,
  required ToolbarAlignment alignment,
}) {
  double cellSize = toolbarAxisFromAlignment(alignment) == Axis.horizontal
      ? kToolbarTileWidth + kToolbarTilePadding
      : kToolbarTileHeight + kToolbarTilePadding;
  double cellSum = buttonCount * cellSize;
  double paddingSum = (buttonCount + 1) * kToolbarTilePadding;
  double marginSum = 2.0 * kToolbarMargin;
  return cellSum + paddingSum + marginSum;
}

ToolbarAlignment layoutAlignment({
  required BoxConstraints constraints,
  required int buttonCount,
  required ToolbarAlignment alignment,
}) {
  double toolbarSize = calculateToolbarSize(
    buttonCount: buttonCount,
    alignment: alignment,
  );
  switch (alignment) {
    case ToolbarAlignment.topLeft:
      return ToolbarAlignment.topLeft;
    case ToolbarAlignment.topCenter:
      return toolbarSize > constraints.maxWidth
          ? ToolbarAlignment.topLeft
          : ToolbarAlignment.topCenter;
    case ToolbarAlignment.topRight:
      return ToolbarAlignment.topRight;
    case ToolbarAlignment.bottomLeft:
      return ToolbarAlignment.bottomLeft;
    case ToolbarAlignment.bottomCenter:
      return toolbarSize > constraints.maxWidth
          ? ToolbarAlignment.bottomLeft
          : ToolbarAlignment.bottomCenter;
    case ToolbarAlignment.bottomRight:
      return ToolbarAlignment.bottomRight;
    case ToolbarAlignment.leftTop:
      return ToolbarAlignment.leftTop;
    case ToolbarAlignment.leftCenter:
      return toolbarSize > constraints.maxHeight
          ? ToolbarAlignment.leftTop
          : ToolbarAlignment.leftCenter;
    case ToolbarAlignment.leftBottom:
      return ToolbarAlignment.leftBottom;
    case ToolbarAlignment.rightTop:
      return ToolbarAlignment.rightTop;
    case ToolbarAlignment.rightCenter:
      return toolbarSize > constraints.maxHeight
          ? ToolbarAlignment.rightTop
          : ToolbarAlignment.rightCenter;
    case ToolbarAlignment.rightBottom:
      return ToolbarAlignment.rightBottom;
  }
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
