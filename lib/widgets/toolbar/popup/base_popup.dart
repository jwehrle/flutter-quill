import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/attribute_toggle_mixin.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

class BasePopup extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final Color disabled;
  final ToggleState state;
  final ToolbarAlignment alignment;

  const BasePopup({
    Key? key,
    required this.iconData,
    this.onPressed,
    required this.background,
    required this.foreground,
    required this.disabled,
    required this.state,
    required this.alignment,
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
    switch (alignment) {
      case ToolbarAlignment.topLeft:
      case ToolbarAlignment.topCenter:
      case ToolbarAlignment.topRight:
        edgeInsets = EdgeInsets.only(top: 8.0);
        break;
      case ToolbarAlignment.bottomLeft:
      case ToolbarAlignment.bottomCenter:
      case ToolbarAlignment.bottomRight:
        edgeInsets = EdgeInsets.only(bottom: 8.0);
        break;
      case ToolbarAlignment.leftTop:
      case ToolbarAlignment.leftCenter:
      case ToolbarAlignment.leftBottom:
        edgeInsets = EdgeInsets.only(left: 8.0);
        break;
      case ToolbarAlignment.rightTop:
      case ToolbarAlignment.rightCenter:
      case ToolbarAlignment.rightBottom:
        edgeInsets = EdgeInsets.only(right: 8.0);
        break;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: state == ToggleState.disabled ? null : onPressed,
      child: Padding(
        padding: edgeInsets,
        child: Container(
          width: 40.0,
          height: 40.0,
          child: Material(
            color: background,
            shape: CircleBorder(),
            elevation: 2.0,
            child: Container(
              margin: EdgeInsets.all(2.0),
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: decoration,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(iconData, color: iconColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
