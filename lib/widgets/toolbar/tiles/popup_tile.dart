import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';

class PopupTile extends StatelessWidget {
  final EdgeInsets edgeInsets;
  final Color background;
  final Color decoration;
  final Color iconColor;
  final IconData iconData;

  const PopupTile({
    Key? key,
    required this.edgeInsets,
    required this.background,
    required this.decoration,
    required this.iconColor,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kPopupSize,
      height: kPopupSize,
      padding: edgeInsets,
      child: Material(
        color: background,
        shape: CircleBorder(),
        elevation: kPopupElevation,
        child: Container(
          margin: EdgeInsets.all(kPopupMargin),
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
    );
  }
}
