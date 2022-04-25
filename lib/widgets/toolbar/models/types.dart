import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';

enum ToggleState { disabled, off, on }

enum PopType { align, block, indent, list, size, style }

enum NoPopType {
  bold,
  italic,
  under,
  strike,
  bullet,
  number,
  quote,
  code,
  link,
}

enum PopupActionType {
  indentMinus,
  indentPlus,
  sizeMinus,
  sizePlus,
  leftAlign,
  rightAlign,
  centerAlign,
  justifyAlign,
}

enum RichTextToolbarType {
  condensed,
  expanded,
  condensedOption,
  expandedOption
}

class OptionButtonData {
  final Widget child;
  final VoidCallback onPressed;

  OptionButtonData({
    required this.onPressed,
    required this.child,
  });

  @override
  String toString() {
    return 'OptionalButton';
  }

  @override
  int get hashCode {
    int hash = child.hashCode;
    return hash %= onPressed.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is OptionButtonData
        ? other.child == child && other.onPressed == onPressed
        : false;
  }
}

class ButtonStyling {
  final Color backgroundColor;
  final Color accentColor;
  final Color disabledColor;
  final ButtonShape buttonShape;
  final BorderStyle borderStyle;
  final double internalPadding;
  final double borderWidth;
  final BorderRadiusGeometry borderRadius;
  final bool isMaterialized;
  final double? radius;
  final double width;
  final double height;
  final double elevation;
  final double tooltipOffset;

  ButtonStyling({
    required this.backgroundColor,
    required this.accentColor,
    required this.disabledColor,
    this.buttonShape = ButtonShape.roundedRectangle,
    this.borderStyle = BorderStyle.solid,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.internalPadding = 2.0,
    this.borderWidth = 0.0,
    this.isMaterialized = false,
    this.radius,
    this.width = 45.0,
    this.height = 40.0,
    this.elevation = 0.0,
    this.tooltipOffset = 8.0,
  });
}
