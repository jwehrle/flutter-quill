import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/models/types.dart';

class ToggleTile extends StatelessWidget {
  final ValueNotifier<ToggleState> notifier;
  final IconData iconData;
  final String? label;
  final ButtonStyling styling;
  final String? tooltip;
  final bool? preferTooltipBelow;

  const ToggleTile({
    Key? key,
    required this.notifier,
    required this.iconData,
    required this.styling,
    this.label,
    this.tooltip,
    this.preferTooltipBelow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToggleState>(
      valueListenable: notifier,
      builder: (context, state, child) {
        Color toggleForeground;
        Color toggleDecoration;
        switch (state) {
          case ToggleState.on:
            toggleForeground = styling.backgroundColor;
            toggleDecoration = styling.accentColor;
            break;
          case ToggleState.off:
            toggleForeground = styling.accentColor;
            toggleDecoration = styling.backgroundColor;
            break;
          case ToggleState.disabled:
            toggleForeground = styling.disabledColor;
            toggleDecoration = styling.backgroundColor;
            break;
        }
        return ButtonTile(
          iconData: iconData,
          label: label,
          foregroundColor: toggleForeground,
          decorationColor: toggleDecoration,
          backgroundColor: styling.backgroundColor,
          buttonShape: styling.buttonShape,
          borderStyle: styling.borderStyle,
          borderRadius: styling.borderRadius,
          internalPadding: styling.internalPadding,
          borderWidth: styling.borderWidth,
          radius: styling.radius,
          width: styling.width,
          height: styling.height,
          isMaterialized: styling.isMaterialized,
          elevation: styling.elevation,
          tooltip: tooltip,
          preferTooltipBelow: preferTooltipBelow,
          tooltipOffset: styling.tooltipOffset,
        );
      },
    );
  }
}

class OnTile extends StatelessWidget {
  final IconData iconData;
  final String? label;
  final ButtonStyling styling;
  final String? tooltip;
  final bool? preferTooltipBelow;

  const OnTile({
    Key? key,
    required this.iconData,
    required this.styling,
    this.label,
    this.tooltip,
    this.preferTooltipBelow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTile(
      iconData: iconData,
      label: label,
      foregroundColor: styling.backgroundColor,
      decorationColor: styling.accentColor,
      backgroundColor: styling.backgroundColor,
      buttonShape: styling.buttonShape,
      borderStyle: styling.borderStyle,
      borderRadius: styling.borderRadius,
      internalPadding: styling.internalPadding,
      borderWidth: styling.borderWidth,
      radius: styling.radius,
      width: styling.width,
      height: styling.height,
      isMaterialized: styling.isMaterialized,
      elevation: styling.elevation,
      tooltip: tooltip,
      preferTooltipBelow: preferTooltipBelow,
      tooltipOffset: styling.tooltipOffset,
    );
  }
}

class OffTile extends StatelessWidget {
  final IconData iconData;
  final String? label;
  final ButtonStyling styling;
  final String? tooltip;
  final bool? preferTooltipBelow;

  const OffTile({
    Key? key,
    required this.iconData,
    required this.styling,
    this.label,
    this.tooltip,
    this.preferTooltipBelow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTile(
      iconData: iconData,
      label: label,
      foregroundColor: styling.accentColor,
      decorationColor: styling.backgroundColor,
      backgroundColor: styling.backgroundColor,
      buttonShape: styling.buttonShape,
      borderStyle: styling.borderStyle,
      borderRadius: styling.borderRadius,
      internalPadding: styling.internalPadding,
      borderWidth: styling.borderWidth,
      radius: styling.radius,
      width: styling.width,
      height: styling.height,
      isMaterialized: styling.isMaterialized,
      elevation: styling.elevation,
      tooltip: tooltip,
      preferTooltipBelow: preferTooltipBelow,
      tooltipOffset: styling.tooltipOffset,
    );
  }
}

class DisabledTile extends StatelessWidget {
  final IconData iconData;
  final String? label;
  final ButtonStyling styling;
  final String? tooltip;
  final bool? preferTooltipBelow;

  const DisabledTile({
    Key? key,
    required this.iconData,
    required this.styling,
    this.label,
    this.tooltip,
    this.preferTooltipBelow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTile(
      iconData: iconData,
      label: label,
      foregroundColor: styling.disabledColor,
      decorationColor: styling.backgroundColor,
      backgroundColor: styling.backgroundColor,
      buttonShape: styling.buttonShape,
      borderStyle: styling.borderStyle,
      borderRadius: styling.borderRadius,
      internalPadding: styling.internalPadding,
      borderWidth: styling.borderWidth,
      radius: styling.radius,
      width: styling.width,
      height: styling.height,
      isMaterialized: styling.isMaterialized,
      elevation: styling.elevation,
      tooltip: tooltip,
      preferTooltipBelow: preferTooltipBelow,
      tooltipOffset: styling.tooltipOffset,
    );
  }
}
