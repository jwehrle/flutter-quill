import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';

enum ToggleState { disabled, off, on }

enum ToolbarPopupType {
  align,
  block,
  indent,
  list,
  size,
  style,
}

enum PopupToggleType {
  bold,
  bullet,
  code,
  italic,
  number,
  quote,
  strike,
  under,
}

enum ToolbarToggleType {
  bold,
  bullet,
  code,
  italic,
  link,
  number,
  quote,
  strike,
  under,
}

enum PopupScalarType {
  centerAlign,
  indentMinus,
  indentPlus,
  justifyAlign,
  leftAlign,
  rightAlign,
  sizeMinus,
  sizePlus,
}

class OptionButtonData {
  final ToggleState state;
  final IconData iconData;
  final String label;
  final String tooltip;
  final bool preferTooltipBelow;
  final ButtonStyling styling;
  final VoidCallback onPressed;

  OptionButtonData({
    required this.state,
    required this.iconData,
    required this.label,
    required this.tooltip,
    required this.preferTooltipBelow,
    required this.styling,
    required this.onPressed,
  });

  // @override
  // String toString() {
  //   return 'OptionalButton';
  // }

  // @override
  // int get hashCode {
  //   int hash = child.hashCode;
  //   return hash %= onPressed.hashCode;
  // }

  // @override
  // bool operator ==(Object other) {
  //   return other is OptionButtonData
  //       ? other.child == child && other.onPressed == onPressed
  //       : false;
  // }
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
