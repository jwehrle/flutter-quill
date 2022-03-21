import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/floating/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/floating/buttons/better_icon_button.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class ToolbarButton extends StatelessWidget {
  final String itemKey;
  final IconData iconData;
  final String label;
  final String? tooltip;
  final VoidCallback? onPressed;
  final ValueNotifier<ToggleState> toggleStateNotifier;
  final ToolbarAlignment alignment;

  const ToolbarButton({
    Key? key,
    required this.itemKey,
    required this.iconData,
    required this.label,
    this.tooltip,
    required this.toggleStateNotifier,
    required this.onPressed,
    required this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToggleState>(
      valueListenable: toggleStateNotifier,
      builder: (context, state, child) {
        return ValueListenableBuilder<ButtonData>(
          valueListenable:
              FloatingToolbar.of(context).toolbarButtonDataNotifier,
          builder: (context, data, child) {
            Color foregroundColor;
            Color decorationColor;
            switch (state) {
              case ToggleState.on:
                foregroundColor = data.backgroundColor;
                decorationColor = data.accentColor;
                break;
              case ToggleState.off:
                foregroundColor = data.accentColor;
                decorationColor = data.backgroundColor;
                break;
              case ToggleState.disabled:
                foregroundColor = data.disabledColor;
                decorationColor = data.backgroundColor;
                break;
            }
            return BetterIconButton(
              iconData: iconData,
              label: label,
              onPressed: state == ToggleState.disabled ? null : onPressed,
              foregroundColor: foregroundColor,
              decorationColor: decorationColor,
              backgroundColor: data.backgroundColor,
              buttonShape: data.buttonShape,
              borderStyle: data.borderStyle,
              borderRadius: data.borderRadius,
              internalPadding: data.internalPadding,
              borderWidth: data.borderWidth,
              radius: data.radius,
              width: data.width,
              height: data.height,
              isMaterialized: data.isMaterialized,
              elevation: data.elevation,
              tooltip: tooltip,
              preferBelow: tooltipPreferBelow(alignment),
              tooltipOffset: data.effectiveHeight + 5.0,
            );
          },
        );
      },
    );
  }
}
