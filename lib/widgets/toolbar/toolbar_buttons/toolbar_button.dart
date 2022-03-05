import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/tiles/toolbar_tile.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class ToolbarButton extends StatelessWidget {
  final String itemKey;
  final IconData iconData;
  final String label;
  final String? tooltip;
  final Color foreground;
  final Color background;
  final Color disabled;
  final VoidCallback? onPressed;
  final ValueNotifier<ToggleState> toggleState;
  final ToolbarAlignment alignment;

  const ToolbarButton({
    Key? key,
    required this.itemKey,
    required this.iconData,
    required this.label,
    this.tooltip,
    required this.foreground,
    required this.background,
    required this.toggleState,
    required this.onPressed,
    required this.disabled,
    required this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToggleState>(
      valueListenable: toggleState,
      builder: (context, state, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: state == ToggleState.disabled ? null : onPressed,
          child: ToolbarTile(
            state: state,
            accent: foreground,
            background: background,
            disabled: disabled,
            iconData: iconData,
            label: label,
            tooltip: tooltip,
            alignment: alignment,
          ),
        );
      },
    );
  }
}
