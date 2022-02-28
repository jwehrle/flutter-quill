import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/richtext_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_item.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/toolbar_tile.dart';

const double kPopupAnchorPadding =
    kToolbarTileHeight + (2.0 * kToolbarTilePadding);

enum ToolbarAlignment {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
  leftTop,
  leftCenter,
  leftBottom,
  rightTop,
  rightCenter,
  rightBottom,
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

enum ToolbarType { condensed, expanded, condensedHide, expandedHide }

int toolbarItemCount(ToolbarType type) {
  switch (type) {
    case ToolbarType.condensed:
      return 6;
    case ToolbarType.expanded:
      return 11;
    case ToolbarType.condensedHide:
      return 7;
    case ToolbarType.expandedHide:
      return 12;
  }
}

List<ToolbarItem> toolbarItems({
  required ToolbarType type,
  required QuillController controller,
  FocusNode? focusNode,
}) {
  switch (type) {
    case ToolbarType.condensed:
      return List<ToolbarItem>.unmodifiable([
        ToolbarItem.style(controller: controller),
        ToolbarItem.size(controller: controller),
        ToolbarItem.indent(controller: controller),
        ToolbarItem.list(controller: controller),
        ToolbarItem.block(controller: controller),
        ToolbarItem.link(controller: controller),
      ]);
    case ToolbarType.expanded:
      return List<ToolbarItem>.unmodifiable([
        ToolbarItem.bold(controller: controller),
        ToolbarItem.italic(controller: controller),
        ToolbarItem.under(controller: controller),
        ToolbarItem.strike(controller: controller),
        ToolbarItem.size(controller: controller),
        ToolbarItem.indent(controller: controller),
        ToolbarItem.bullet(controller: controller),
        ToolbarItem.number(controller: controller),
        ToolbarItem.quote(controller: controller),
        ToolbarItem.code(controller: controller),
        ToolbarItem.link(controller: controller),
      ]);
    case ToolbarType.condensedHide:
      assert(
        focusNode != null,
        'ToolbarType condensedHide requires non-null FocusNode',
      );
      return List<ToolbarItem>.unmodifiable([
        ToolbarItem.keyboard(focusNode: focusNode!),
        ToolbarItem.style(controller: controller),
        ToolbarItem.size(controller: controller),
        ToolbarItem.indent(controller: controller),
        ToolbarItem.list(controller: controller),
        ToolbarItem.block(controller: controller),
        ToolbarItem.link(controller: controller),
      ]);
    case ToolbarType.expandedHide:
      assert(
        focusNode != null,
        'ToolbarType expandedHide requires non-null FocusNode',
      );
      return List<ToolbarItem>.unmodifiable([
        ToolbarItem.keyboard(focusNode: focusNode!),
        ToolbarItem.bold(controller: controller),
        ToolbarItem.italic(controller: controller),
        ToolbarItem.under(controller: controller),
        ToolbarItem.strike(controller: controller),
        ToolbarItem.size(controller: controller),
        ToolbarItem.indent(controller: controller),
        ToolbarItem.bullet(controller: controller),
        ToolbarItem.number(controller: controller),
        ToolbarItem.quote(controller: controller),
        ToolbarItem.code(controller: controller),
        ToolbarItem.link(controller: controller),
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

class PosParam {
  double? top;
  double? left;
  double? right;
  double? bottom;
  PosParam({this.top, this.left, this.right, this.bottom});

  @override
  String toString() {
    String params = '';
    params += top == null ? '' : ' top: $top,';
    params += left == null ? '' : ' left: $left,';
    params += right == null ? '' : ' right: $right,';
    params += bottom == null ? '' : ' bottom: $bottom,';
    return 'PosParam:' + params;
  }

  @override
  int get hashCode {
    int hash = top?.hashCode ?? 1;
    hash *= left?.hashCode ?? 1;
    hash *= right?.hashCode ?? 1;
    hash *= bottom?.hashCode ?? 1;
    return hash;
  }

  @override
  bool operator ==(Object other) {
    if (other is PosParam) {
      if (top != other.top) {
        return false;
      }
      if (left != other.left) {
        return false;
      }
      if (right != other.right) {
        return false;
      }
      if (bottom != other.bottom) {
        return false;
      }
      return true;
    }
    return false;
  }
}

PosParam itemPosition({
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
  switch (alignment) {
    case ToolbarAlignment.topLeft:
    case ToolbarAlignment.topCenter:
      return PosParam(
        top: kPopupAnchorPadding,
        left: offset,
        right: null,
        bottom: null,
      );
    case ToolbarAlignment.topRight:
      return PosParam(
        top: kPopupAnchorPadding,
        left: null,
        right: offset,
        bottom: null,
      );
    case ToolbarAlignment.bottomLeft:
    case ToolbarAlignment.bottomCenter:
      return PosParam(
        top: null,
        left: offset,
        right: null,
        bottom: kPopupAnchorPadding,
      );
    case ToolbarAlignment.bottomRight:
      return PosParam(
        top: null,
        left: null,
        right: offset,
        bottom: kPopupAnchorPadding,
      );
    case ToolbarAlignment.leftTop:
    case ToolbarAlignment.leftCenter:
      return PosParam(
        top: offset,
        left: kPopupAnchorPadding,
        right: null,
        bottom: null,
      );
    case ToolbarAlignment.leftBottom:
      return PosParam(
        top: null,
        left: kPopupAnchorPadding,
        right: null,
        bottom: offset,
      );
    case ToolbarAlignment.rightTop:
    case ToolbarAlignment.rightCenter:
      return PosParam(
        top: offset,
        left: null,
        right: kPopupAnchorPadding,
        bottom: null,
      );
    case ToolbarAlignment.rightBottom:
      return PosParam(
        top: null,
        left: null,
        right: kPopupAnchorPadding,
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
      ? kToolbarCellWidth
      : kToolbarCellHeight;
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
