import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/attribute_toggle_mixin.dart';

const double kToolbarIconSize = 24.0;
const double kToolbarTilePadding = 2.0;
const double kToolbarTileWidth = 45.0;
const double kToolbarTileHeight = 40.0;
const double kToolbarCellWidth = kToolbarTileWidth + kToolbarTilePadding;
const double kToolbarCellHeight = kToolbarTileHeight + kToolbarTilePadding;

class ToolbarTile extends StatelessWidget {
  final ToggleState state;
  final Color accent;
  final Color background;
  final Color disabled;
  final IconData iconData;
  final String label;
  final String? tooltip;
  final Axis direction;

  const ToolbarTile({
    Key? key,
    required this.state,
    required this.accent,
    required this.background,
    required this.disabled,
    required this.iconData,
    required this.label,
    required this.direction,
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
    EdgeInsets edgeInsets;
    switch (direction) {
      case Axis.horizontal:
        edgeInsets = EdgeInsets.symmetric(vertical: kToolbarTilePadding);
        break;
      case Axis.vertical:
        edgeInsets = EdgeInsets.symmetric(horizontal: kToolbarTilePadding);
        break;
    }
    Widget result = Container(
      height: kToolbarTileHeight,
      width: kToolbarTileWidth,
      margin: edgeInsets,
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
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: iconText,
                  ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );

    if (effectiveTooltip != null) {
      result = Tooltip(
        message: effectiveTooltip,
        preferBelow: false,
        verticalOffset: kToolbarTileHeight,
        excludeFromSemantics: true,
        child: result,
      );
    }

    result = Semantics(
      container: true,
      child: Stack(
        children: <Widget>[
          result,
          Semantics(
            label: tooltip,
          ),
        ],
      ),
    );

    return result;
  }
}
