import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:iconic_button/iconic_button.dart';

/// The three mutually exclusive states that a toggle type button can be in
enum ToggleState { disabled, off, on }

/// Provides methods for dealing with [ToggleState]
mixin ToggleMixin {
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


  Set<ButtonState> initButtonStateFromToggleState(ToggleState toggleState) {
    switch (toggleState) {
      case ToggleState.disabled:
        return {};
      case ToggleState.off:
        return {ButtonState.enabled};
      case ToggleState.on:
        return {ButtonState.selected, ButtonState.enabled};
    }
  }

  void toggleListener(ToggleState state, ButtonController controller) {
    switch (state) {
      case ToggleState.disabled:
        controller.disable();
        break;
      case ToggleState.off:
        // controller.unSelect();
        controller.value = {ButtonState.enabled};
        break;
      case ToggleState.on:
        // controller.select();
        controller.value = {ButtonState.enabled, ButtonState.selected};
        break;
    }
  }
}
