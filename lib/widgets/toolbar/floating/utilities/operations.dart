import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/floating/utilities/types.dart';

double toolbarOffset({
  required ToolbarData toolbarData,
  required BoxConstraints constraints,
  required ButtonData buttonData,
  required int buttonCount,
  double scrollOffset = 0.0,
}) {
  switch (toolbarData.alignment) {
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.bottomLeft:
      return toolbarData.margin.left +
          toolbarData.contentPadding.left -
          scrollOffset;
    case ToolbarAlignment.topRight:
    case ToolbarAlignment.bottomRight:
      return toolbarData.margin.right +
          toolbarData.contentPadding.right -
          scrollOffset;
    case ToolbarAlignment.leftTop:
    case ToolbarAlignment.rightTop:
      return toolbarData.margin.top +
          toolbarData.contentPadding.top -
          scrollOffset;
    case ToolbarAlignment.leftBottom:
    case ToolbarAlignment.rightBottom:
      return toolbarData.margin.bottom +
          toolbarData.contentPadding.bottom -
          scrollOffset;
    case ToolbarAlignment.topCenter:
    case ToolbarAlignment.bottomCenter:
      return toolbarCenterOffset(
        itemsCount: buttonCount,
        axis: Axis.horizontal,
        containerSize: constraints.maxWidth,
        buttonSpacing: toolbarData.buttonSpacing,
        buttonWidth: buttonData.effectiveWidth,
        buttonHeight: buttonData.effectiveHeight,
      );
    case ToolbarAlignment.leftCenter:
    case ToolbarAlignment.rightCenter:
      return toolbarCenterOffset(
        itemsCount: buttonCount,
        axis: Axis.vertical,
        containerSize: constraints.maxHeight,
        buttonSpacing: toolbarData.buttonSpacing,
        buttonWidth: buttonData.effectiveWidth,
        buttonHeight: buttonData.effectiveHeight,
      );
  }
}

double toolbarCenterOffset({
  required int itemsCount,
  required Axis axis,
  required double containerSize,
  required double buttonSpacing,
  required double buttonWidth,
  required double buttonHeight,
}) {
  double buttonSize;
  switch (axis) {
    case Axis.horizontal:
      buttonSize = buttonWidth;
      break;
    case Axis.vertical:
      buttonSize = buttonHeight;
      break;
  }
  double center = containerSize / 2.0;
  if (itemsCount.isEven) {
    //split padding
    center += buttonSpacing / 2.0;
  } else {
    //split button
    center -= buttonSize / 2.0;
  }
  return center;
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

double calculateToolbarSize({
  required ToolbarData toolbarData,
  required ButtonData buttonData,
  required int buttonCount,
}) {
  Axis axis = toolbarAxisFromAlignment(toolbarData.alignment);
  double tileSize = axis == Axis.horizontal
      ? buttonData.effectiveHeight
      : buttonData.effectiveWidth;
  double tileSum = buttonCount * tileSize;
  double interTilePaddingSum = (buttonCount - 1) * toolbarData.buttonSpacing;
  double buttonSection = tileSum + interTilePaddingSum;
  double outerPadding = axis == Axis.horizontal
      ? toolbarData.contentPadding.horizontal
      : toolbarData.contentPadding.vertical;
  double marginSum = toolbarData.margin.horizontal;
  return buttonSection + outerPadding + marginSum;
}

ToolbarAlignment layoutAlignment({
  required BoxConstraints constraints,
  required ToolbarData toolbarData,
  required ButtonData buttonData,
  required int buttonCount,
}) {
  double toolbarSize = calculateToolbarSize(
    toolbarData: toolbarData,
    buttonData: buttonData,
    buttonCount: buttonCount,
  );
  switch (toolbarData.alignment) {
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

Positioned positionedItem({
  required int index,
  required double toolbarOffset,
  required ToolbarData toolbarData,
  required ButtonData toolbarButtonData,
  required Widget child,
  required int buttonCount,
}) {
  double offset = itemOffset(
    toolbarOffset: toolbarOffset,
    index: index,
    toolbarData: toolbarData,
    buttonData: toolbarButtonData,
    itemCount: buttonCount,
  );
  double verticalAnchor =
      toolbarButtonData.effectiveHeight + toolbarData.contentPadding.vertical;
  double horizontalAnchor =
      toolbarButtonData.effectiveWidth + toolbarData.contentPadding.horizontal;
  switch (toolbarData.alignment) {
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.topCenter:
      return Positioned(
        top: verticalAnchor,
        left: offset,
        right: null,
        bottom: null,
        child: child,
      );
    case ToolbarAlignment.topRight:
      return Positioned(
        top: verticalAnchor,
        left: null,
        right: offset,
        bottom: null,
        child: child,
      );
    case ToolbarAlignment.bottomLeft:
    case ToolbarAlignment.bottomCenter:
      return Positioned(
        top: null,
        left: offset,
        right: null,
        bottom: verticalAnchor,
        child: child,
      );
    case ToolbarAlignment.bottomRight:
      return Positioned(
        top: null,
        left: null,
        right: offset,
        bottom: verticalAnchor,
        child: child,
      );
    case ToolbarAlignment.leftTop:
    case ToolbarAlignment.leftCenter:
      return Positioned(
        top: offset,
        left: horizontalAnchor,
        right: null,
        bottom: null,
        child: child,
      );
    case ToolbarAlignment.leftBottom:
      return Positioned(
        top: null,
        left: horizontalAnchor,
        right: null,
        bottom: offset,
        child: child,
      );
    case ToolbarAlignment.rightTop:
    case ToolbarAlignment.rightCenter:
      return Positioned(
        top: offset,
        left: null,
        right: horizontalAnchor,
        bottom: null,
        child: child,
      );
    case ToolbarAlignment.rightBottom:
      return Positioned(
        top: null,
        left: null,
        right: horizontalAnchor,
        bottom: offset,
        child: child,
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

double itemOffsetFromEdge({
  required double toolbarOffset,
  required int itemsFromEdge,
  required double contentPadding,
  required double buttonSpacing,
  required double buttonWidth,
  required double buttonHeight,
  required Axis axis,
}) {
  toolbarOffset += contentPadding;
  toolbarOffset += (itemsFromEdge - 1) * buttonSpacing;
  switch (axis) {
    case Axis.horizontal:
      toolbarOffset += itemsFromEdge * buttonWidth;
      break;
    case Axis.vertical:
      toolbarOffset += itemsFromEdge * buttonHeight;
      break;
  }
  return toolbarOffset;
}

double itemCenterOffset({
  required int itemCount,
  required int index,
  required double buttonSize,
  required double buttonSpacing,
}) {
  int centerIndex = (itemCount / 2).floor();
  int indexDiff = index - centerIndex;
  double offset = indexDiff * buttonSize;
  offset += indexDiff * buttonSpacing;
  return offset;
}

double itemOffset({
  required double toolbarOffset,
  required int index,
  required ToolbarData toolbarData,
  required ButtonData buttonData,
  required int itemCount,
}) {
  assert(index < itemCount, 'Out of range error');
  switch (toolbarData.alignment) {
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.bottomLeft:
      return itemOffsetFromEdge(
        toolbarOffset: toolbarOffset,
        itemsFromEdge: index,
        axis: Axis.horizontal,
        contentPadding: toolbarData.contentPadding.left,
        buttonSpacing: toolbarData.buttonSpacing,
        buttonWidth: buttonData.effectiveWidth,
        buttonHeight: buttonData.effectiveHeight,
      );
    case ToolbarAlignment.topRight:
    case ToolbarAlignment.bottomRight:
      return itemOffsetFromEdge(
        toolbarOffset: toolbarOffset,
        itemsFromEdge: (itemCount - 1) - index,
        axis: Axis.horizontal,
        contentPadding: toolbarData.contentPadding.right,
        buttonSpacing: toolbarData.buttonSpacing,
        buttonWidth: buttonData.effectiveWidth,
        buttonHeight: buttonData.effectiveHeight,
      );
    case ToolbarAlignment.leftTop:
    case ToolbarAlignment.rightTop:
      return itemOffsetFromEdge(
        toolbarOffset: toolbarOffset,
        itemsFromEdge: index,
        axis: Axis.vertical,
        contentPadding: toolbarData.contentPadding.top,
        buttonSpacing: toolbarData.buttonSpacing,
        buttonWidth: buttonData.effectiveWidth,
        buttonHeight: buttonData.effectiveHeight,
      );
    case ToolbarAlignment.leftBottom:
    case ToolbarAlignment.rightBottom:
      return itemOffsetFromEdge(
        toolbarOffset: toolbarOffset,
        itemsFromEdge: (itemCount - 1) - index,
        axis: Axis.vertical,
        contentPadding: toolbarData.contentPadding.bottom,
        buttonSpacing: toolbarData.buttonSpacing,
        buttonWidth: buttonData.effectiveWidth,
        buttonHeight: buttonData.effectiveHeight,
      );
    case ToolbarAlignment.topCenter:
    case ToolbarAlignment.bottomCenter:
      return toolbarOffset +
          itemCenterOffset(
            index: index,
            itemCount: itemCount,
            buttonSize: buttonData.effectiveWidth,
            buttonSpacing: toolbarData.buttonSpacing,
          );
    case ToolbarAlignment.leftCenter:
    case ToolbarAlignment.rightCenter:
      return toolbarOffset +
          itemCenterOffset(
            index: index,
            itemCount: itemCount,
            buttonSize: buttonData.effectiveHeight,
            buttonSpacing: toolbarData.buttonSpacing,
          );
  }
}

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

bool tooltipPreferBelow(ToolbarAlignment alignment) {
  switch (alignment) {
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.topCenter:
    case ToolbarAlignment.topRight:
      return true;
    case ToolbarAlignment.bottomLeft:
    case ToolbarAlignment.bottomCenter:
    case ToolbarAlignment.bottomRight:
      return false;
    case ToolbarAlignment.leftTop:
      return true;
    case ToolbarAlignment.leftCenter:
    case ToolbarAlignment.leftBottom:
      return false;
    case ToolbarAlignment.rightTop:
      return true;
    case ToolbarAlignment.rightCenter:
    case ToolbarAlignment.rightBottom:
      return false;
  }
}
