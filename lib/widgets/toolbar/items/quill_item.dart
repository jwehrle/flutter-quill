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

/// The logic and content of a popup button
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
    required this.preferBelow,
    required this.style,
    this.onFinished,
  });

  /// The icon for the toolbar button of this item
  final IconData iconData;

  /// The label for the toolbar button of this item
  final String label;

  /// The tooltip for the toolbar button of this item
  final String tooltip;

  /// Whether to place the tooltuip below the button if there is room
  final bool preferBelow;

  /// A callback triggered when popup logic is complete
  final VoidCallback? onFinished;

  /// Styling fields for popups
  final ButtonStyle style;

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
      preferTooltipBelow: preferBelow,
      onPressed: data.onPressed,
      style: style,
    );
  }
}
