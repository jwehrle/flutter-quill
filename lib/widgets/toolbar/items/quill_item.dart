import 'dart:async';

import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:iconic_button/iconic_button.dart';

enum ToolbarButton { align, block, indent, insert, list, size, style }

enum AlignPopup { centerAlign, justifyAlign, leftAlign, rightAlign }

enum BlockPopup { code, quote }

enum IndentPopup { minus, plus }

enum InsertPopup { image, text }

enum ListPopup { bulleted, numbered }

enum SizePopup { minus, plus }

enum StylePopup { bold, italic, strikeThru, underline }

/// Utility class wrapping a Completer used to call dispose on controllers
/// in [QuillItem] sublclasses.
class Disposer {
  final Completer _completer = Completer();

  Future get onDispose => _completer.future;

  void dispose() {
    _completer.complete();
  }
}

class PopupStyle {
  PopupStyle({
    required this.shape,
    required this.elevation,
    required this.padding,
    required this.primary,
    required this.onPrimary,
    required this.onSurface,
    required this.shadowColor,
    required this.textStyle,
    required this.preferBelow,
  });

  final OutlinedBorder? shape;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final Color? primary;
  final Color? onPrimary;
  final Color? onSurface;
  final Color? shadowColor;
  final TextStyle? textStyle;
  final bool? preferBelow;
}

class PopupData {
  final bool isSelectable;
  final bool isSelected;
  final bool isEnabled;
  final IconData iconData;
  final String? label;
  final String? tooltip;
  final VoidCallback onPressed;

  PopupData({
    required this.isSelectable,
    required this.isSelected,
    required this.isEnabled,
    required this.iconData,
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });
}

/// Utility class for building a [FloatingToolbarItem]
abstract class QuillItem {
  QuillItem({
    required this.iconData,
    required this.label,
    required this.tooltip,
    required this.style,
    this.onFinished,
  });

  /// The icon for the toolbar button of this item
  final IconData iconData;

  /// The label for the toolbar button of this item
  final String label;

  /// The tooltip for the toolbar button of this item
  final String tooltip;

  /// A callback triggered when popup logic is complete
  final VoidCallback? onFinished;

  /// Styling fields for popups
  final PopupStyle style;

  /// Builds a [FloatingToolbarItem] that follows and alters
  /// a [QuillController]
  FloatingToolbarItem build();

  /// An [IconicItem] build from [iconData], [labe], and [tooltip]
  IconicItem get toolbarButton => IconicItem(
        iconData: iconData,
        label: label,
        tooltip: tooltip,
      );

  /// Creates a [BasicIconicButton] from [style] and [data]
  BaseIconicButton popupFrom(PopupData data) {
    return BaseIconicButton(
      isSelectable: data.isSelectable,
      isSelected: data.isSelected,
      isEnabled: data.isEnabled,
      iconData: data.iconData,
      label: data.label,
      tooltip: data.tooltip,
      onPressed: data.onPressed,
      shape: style.shape,
      elevation: style.elevation,
      padding: style.padding,
      primary: style.primary,
      onPrimary: style.onPrimary,
      onSurface: style.onSurface,
      shadowColor: style.shadowColor,
      textStyle: style.textStyle,
      preferTooltipBelow: style.preferBelow,
    );
  }
}
