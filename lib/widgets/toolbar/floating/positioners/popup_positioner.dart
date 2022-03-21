import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/floating/flexes/popup_flex.dart';
import 'package:flutter_quill/widgets/toolbar/floating/positioners/positioned_follower.dart';

class PopupPositioner extends StatelessWidget {
  final int buttonCount;
  final List<PopupFlex> children;

  const PopupPositioner({
    Key? key,
    required this.buttonCount,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> popups = [];
    for (int index = 0; index < children.length; index++) {
      final popupFlex = children[index];
      popups.add(
        PositionedFollower(
          index: index,
          child: popupFlex,
          buttonCount: buttonCount,
        ),
      );
    }
    return Stack(
      children: popups,
    );
  }
}
