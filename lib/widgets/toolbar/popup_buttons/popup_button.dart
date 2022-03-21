import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/floating/floating_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/floating/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';

class PopupButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;
  final ToggleState state;
  final ToolbarAlignment alignment;
  final String tooltip;

  const PopupButton({
    Key? key,
    required this.iconData,
    this.onPressed,
    required this.state,
    required this.alignment,
    required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return Padding(
      padding: edgeInsets,
      child: ValueListenableBuilder<ButtonData>(
        valueListenable: FloatingToolbar.of(context).popupButtonDataNotifier,
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
            foregroundColor: foregroundColor,
            decorationColor: decorationColor,
            backgroundColor: data.backgroundColor,
            borderStyle: data.borderStyle,
            radius: data.radius,
            width: data.width,
            height: data.height,
            isMaterialized: data.isMaterialized,
            elevation: data.elevation,
            buttonShape: data.buttonShape,
            borderRadius: data.borderRadius,
            internalPadding: data.internalPadding,
            borderWidth: data.borderWidth,
            onPressed: state == ToggleState.disabled ? null : onPressed,
            tooltip: tooltip,
            preferBelow: preferBelow,
            tooltipOffset: (data.effectiveHeight / 2.0) + 5.0,
          );
        },
      ),
    );
  }
}
