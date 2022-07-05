import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/controllers/controller.dart';

/// The three mutually exclusive states that a toggle type button can be in
enum ToggleState { disabled, off, on }

/// Provides methods for dealing with [ToggleState]
class ToggleMixin {
  void toggle({
    required ToggleState state,
    required Attribute attribute,
    required QuillController controller,
  }) {
    switch (state) {
      case ToggleState.disabled:
        break;
      case ToggleState.off:
        controller.formatSelection(attribute);
        break;
      case ToggleState.on:
        controller.formatSelection(Attribute.clone(attribute, null));
        break;
    }
  }

  ButtonState toButton(ToggleState state) {
    switch (state) {
      case ToggleState.disabled:
        return ButtonState.disabled;
      case ToggleState.off:
        return ButtonState.unselected;
      case ToggleState.on:
        return ButtonState.selected;
    }
  }

  void toggleListener(ToggleState state, ButtonController controller) {
    switch (state) {
      case ToggleState.disabled:
        controller.disable();
        break;
      case ToggleState.off:
        controller.unSelect();
        break;
      case ToggleState.on:
        controller.select();
        break;
    }
  }
}
