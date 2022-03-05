import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/flexes/popup_flex.dart';
import 'package:flutter_quill/widgets/toolbar/rich_text_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/positioners/positioned_follower.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/operations.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class PopupPositioner extends StatelessWidget {
  final QuillController controller;

  const PopupPositioner({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarType>(
      valueListenable: RichTextToolbar.of(context).toolbarTypeNotifier,
      builder: (context, value, child) {
        final List<PopupFlex> popupFlexList = toolbarPopups(
          type: value,
          controller: controller,
        );
        final List<Widget> popups = [];
        for (int index = 0; index < popupFlexList.length; index++) {
          final popupFlex = popupFlexList[index];
          popups.add(
            PositionedFollower(
              index: index,
              child: popupFlex,
            ),
          );
        }
        return Stack(
          children: popups,
        );
      },
    );
  }
}
