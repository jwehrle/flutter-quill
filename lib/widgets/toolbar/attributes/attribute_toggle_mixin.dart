import 'package:flutter/foundation.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

abstract class AttributeToggle {
  late final ValueNotifier<ToggleState> stateNotifier;
  bool isFormattingWhileTyping = false;
  int? previousCursorPos;

  ToggleState getState(QuillController controller, Attribute attribute) {
    bool sectionContainsCodeBlock = controller
        .getSelectionStyle()
        .attributes
        .containsKey(Attribute.codeBlock.key);
    bool shouldDisable =
        sectionContainsCodeBlock && attribute.key != Attribute.codeBlock.key;
    if (shouldDisable) {
      return ToggleState.disabled;
    }
    bool selectionContainsAttribute =
        isCursorInFormattedSelection(controller, attribute) ||
            isFormattingWhileTyping;
    return selectionContainsAttribute ? ToggleState.on : ToggleState.off;
  }

  void attributeInit(QuillController controller, Attribute attribute) {
    stateNotifier = ValueNotifier(getState(controller, attribute));
  }

  /// wrap in setState() when using mixin
  void onEditingValueChanged(QuillController controller, Attribute attribute) {
    // Assume formatting while typing
    isFormattingWhileTyping = stateNotifier.value == ToggleState.on;
    // Verify that selection is collapsed and cursor position change is no more
    // than one than character
    checkIfStillFormattingWhileTyping(controller);
    stateNotifier.value = getState(controller, attribute);
  }

  void checkIfStillFormattingWhileTyping(QuillController controller) {
    int? currentPos = collapsedCursorPos(controller);
    if (currentPos != null && previousCursorPos != currentPos) {
      if (previousCursorPos == null) {
        previousCursorPos = currentPos;
      } else {
        int diff = 0;
        if (currentPos < previousCursorPos!) {
          diff = previousCursorPos! - currentPos;
        } else {
          diff = currentPos - previousCursorPos!;
        }
        //if moved more than one position then not typing
        if (diff > 1) {
          isFormattingWhileTyping = false;
        } else if (isFormattingWhileTyping) {
          previousCursorPos = currentPos;
        }
      }
    }
  }

  int? collapsedCursorPos(QuillController controller) {
    if (!controller.selection.isValid) {
      return null;
    }
    if (!controller.selection.isCollapsed) {
      return null;
    }
    return controller.selection.extentOffset;
  }

  bool isCursorInFormattedSelection(
      QuillController controller, Attribute attribute) {
    final attrs = controller.getSelectionStyle().attributes;
    if (attribute.key == Attribute.list.key) {
      Attribute? att = attrs[attribute.key];
      if (att == null) {
        return false;
      }
      return att.value == attribute.value;
    }
    return attrs.containsKey(attribute.key);
  }

  /// wrap in setState() when using mixin
  toggleAttribute(QuillController controller, Attribute attribute) {
    switch (stateNotifier.value) {
      case ToggleState.on:
        isFormattingWhileTyping = false;
        controller.formatSelection(Attribute.clone(attribute, null));
        stateNotifier.value = ToggleState.off;
        break;
      case ToggleState.off:
        isFormattingWhileTyping = true;
        controller.formatSelection(attribute);
        stateNotifier.value = ToggleState.on;
        break;
      case ToggleState.disabled:
        isFormattingWhileTyping = false;
        break;
    }
  }

  /// call in dispose method.
  void toggleDispose() {
    stateNotifier.dispose();
  }
}
