import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';

class ToolbarTile extends StatelessWidget {
  final ToggleState state;
  final Color accent;
  final Color background;
  final Color disabled;
  final IconData iconData;
  final String label;
  final String? tooltip;
  final ToolbarAlignment alignment;

  const ToolbarTile({
    Key? key,
    required this.state,
    required this.accent,
    required this.background,
    required this.disabled,
    required this.iconData,
    required this.label,
    required this.alignment,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? effectiveTooltip = tooltip == '' ? null : tooltip ?? label;
    Color iconText;
    Color decoration;
    switch (state) {
      case ToggleState.on:
        iconText = background;
        decoration = accent;
        break;
      case ToggleState.off:
        iconText = accent;
        decoration = background;
        break;
      case ToggleState.disabled:
        iconText = disabled;
        decoration = background;
        break;
    }
    bool preferBelow;
    switch (alignment) {
      case ToolbarAlignment.topLeft:
      case ToolbarAlignment.topCenter:
      case ToolbarAlignment.topRight:
      case ToolbarAlignment.leftTop:
      case ToolbarAlignment.rightTop:
        preferBelow = true;
        break;
      case ToolbarAlignment.bottomLeft:
      case ToolbarAlignment.bottomCenter:
      case ToolbarAlignment.bottomRight:
      case ToolbarAlignment.leftCenter:
      case ToolbarAlignment.leftBottom:
      case ToolbarAlignment.rightCenter:
      case ToolbarAlignment.rightBottom:
        preferBelow = false;
        break;
    }
    Widget result = Container(
      height: kToolbarTileHeight,
      width: kToolbarTileWidth,
      decoration: BoxDecoration(
        color: decoration,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Icon(iconData, color: iconText),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: iconText),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );

    if (effectiveTooltip != null) {
      result = Tooltip(
        message: effectiveTooltip,
        preferBelow: preferBelow,
        verticalOffset: (kToolbarTileHeight / 2.0) + kToolbarTilePadding,
        excludeFromSemantics: true,
        child: result,
      );
    }

    result = Semantics(
      container: true,
      child: Stack(
        children: <Widget>[
          result,
          Semantics(label: tooltip),
        ],
      ),
    );

    return result;
  }
}
