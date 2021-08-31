import 'package:flutter/rendering.dart';
import 'package:flutter_quill/models/documents/nodes/container.dart';

abstract class RenderContentProxyBox implements RenderBox {
  double getPreferredLineHeight();

  Offset getOffsetForCaret(TextPosition position, Rect caretPrototype);

  TextPosition getPositionForOffset(Offset offset);

  double? getFullHeightForCaret(TextPosition position);

  TextRange getWordBoundary(TextPosition position);

  List<TextBox> getBoxesForSelection(TextSelection textSelection);
}

abstract class RenderEditableBox extends RenderBox {
  Container getContainer();

  double preferredLineHeight(TextPosition position);

  Offset getOffsetForCaret(TextPosition position);

  TextPosition getPositionForOffset(Offset offset);

  /// Returns the position relative to the [node] content
  ///
  /// The `position` must be within the [node] content
  TextPosition globalToLocalPosition(TextPosition position);

  TextPosition? getPositionAbove(TextPosition position);

  TextPosition? getPositionBelow(TextPosition position);

  TextRange getWordBoundary(TextPosition position);

  TextRange getLineBoundary(TextPosition position);

  TextSelectionPoint getBaseEndpointForSelection(TextSelection textSelection);

  TextSelectionPoint getExtentEndpointForSelection(TextSelection textSelection);

  /// Returns the [Rect] in local coordinates for the caret at the given text
  /// position.
  Rect getLocalRectForCaret(TextPosition position);
}
