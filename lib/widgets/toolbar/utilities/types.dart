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

enum ToolbarAlignment {
  leftTop,
  leftCenter,
  leftBottom,
  topLeft,
  topCenter,
  topRight,
  rightTop,
  rightCenter,
  rightBottom,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

enum ToolbarType { condensed, expanded, condensedOption, expandedOption }

class PositionParameters {
  double? top;
  double? left;
  double? right;
  double? bottom;
  PositionParameters({this.top, this.left, this.right, this.bottom});

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
    if (other is PositionParameters) {
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

class OptionButtonParameters {
  final IconData iconData;
  final String label;
  final String tooltip;
  final VoidCallback onPressed;
  final ValueNotifier<ToggleState> toggleStateNotifier;

  OptionButtonParameters({
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
    if (other is OptionButtonParameters) {
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
