import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/popup_buttons/popup_button.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class PopupToolbarButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;
  final String tooltip;

  const PopupToolbarButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
    required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarData>(
      valueListenable: FloatingToolbar.of(context).toolbarDataNotifier,
      builder: (context, data, _) {
        return PopupButton(
          iconData: iconData,
          onPressed: onPressed,
          state: onPressed == null ? ToggleState.disabled : ToggleState.off,
          alignment: data.alignment,
          tooltip: tooltip,
        );
      },
    );
  }
}
