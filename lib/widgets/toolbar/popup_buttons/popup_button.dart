import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/tiles/popup_tile.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';

class PopupButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final Color disabled;
  final ToggleState state;
  final ToolbarAlignment alignment;
  final String tooltip;

  const PopupButton({
    Key? key,
    required this.iconData,
    this.onPressed,
    required this.background,
    required this.foreground,
    required this.disabled,
    required this.state,
    required this.alignment,
    required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    Color decoration;
    switch (state) {
      case ToggleState.on:
        iconColor = background;
        decoration = foreground;
        break;
      case ToggleState.off:
        iconColor = foreground;
        decoration = background;
        break;
      case ToggleState.disabled:
        iconColor = disabled;
        decoration = background;
        break;
    }
    EdgeInsets edgeInsets;
    bool preferBelow;
    switch (alignment) {
      case ToolbarAlignment.topLeft:
      case ToolbarAlignment.topCenter:
      case ToolbarAlignment.topRight:
        edgeInsets = EdgeInsets.only(top: kPopupPadding);
        preferBelow = true;
        break;
      case ToolbarAlignment.bottomLeft:
      case ToolbarAlignment.bottomCenter:
      case ToolbarAlignment.bottomRight:
        edgeInsets = EdgeInsets.only(bottom: kPopupPadding);
        preferBelow = false;
        break;
      case ToolbarAlignment.leftTop:
        preferBelow = true;
        edgeInsets = EdgeInsets.only(left: kPopupPadding);
        break;
      case ToolbarAlignment.leftCenter:
      case ToolbarAlignment.leftBottom:
        edgeInsets = EdgeInsets.only(left: kPopupPadding);
        preferBelow = false;
        break;
      case ToolbarAlignment.rightTop:
        edgeInsets = EdgeInsets.only(right: kPopupPadding);
        preferBelow = true;
        break;
      case ToolbarAlignment.rightCenter:
      case ToolbarAlignment.rightBottom:
        edgeInsets = EdgeInsets.only(right: kPopupPadding);
        preferBelow = false;
        break;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: state == ToggleState.disabled ? null : onPressed,
      child: Tooltip(
        message: tooltip,
        verticalOffset: (kPopupSize / 2.0) + kPopupPadding,
        preferBelow: preferBelow,
        child: PopupTile(
          edgeInsets: edgeInsets,
          background: background,
          decoration: decoration,
          iconColor: iconColor,
          iconData: iconData,
        ),
      ),
    );
  }
}
