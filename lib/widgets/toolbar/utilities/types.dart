import 'package:flutter/material.dart';

enum ToggleState { disabled, off, on }

enum ToggleType {
  code,
  bold,
  bullet,
  italic,
  number,
  quote,
  strike,
  under,
}

enum ToolbarPopupType { block, indent, list, size, style }

enum PopupActionType {
  indentMinus,
  indentPlus,
  sizeMinus,
  sizePlus,
}

enum RichTextToolbarType {
  condensed,
  expanded,
  condensedOption,
  expandedOption
}

class OptionButtonData {
  final IconData iconData;
  final String label;
  final String tooltip;
  final VoidCallback onPressed;
  final ValueNotifier<ToggleState> toggleStateNotifier;

  OptionButtonData({
    required this.iconData,
    required this.label,
    required this.tooltip,
    required this.onPressed,
    required this.toggleStateNotifier,
  });

  @override
  String toString() {
    return 'OptionalButton: ' + label + ', ' + tooltip;
  }

  @override
  int get hashCode {
    return iconData.hashCode * label.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (other is OptionButtonData) {
      if (other.label != label) {
        return false;
      }
      if (other.iconData != iconData) {
        return false;
      }
      return true;
    }
    return false;
  }
}
