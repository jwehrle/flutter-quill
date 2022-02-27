import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/popup/positioned_follower.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_item.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

class PopupPositionedButtons extends StatelessWidget {
  final QuillController controller;
  final FocusNode? focusNode;

  const PopupPositionedButtons({
    Key? key,
    required this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarType>(
      valueListenable: Toolbar.of(context).toolbarTypeNotifier,
      builder: (context, value, child) {
        final List<ToolbarItem> items = toolbarItems(
          type: value,
          controller: controller,
          focusNode: focusNode,
        );
        final List<Widget> popups = [];
        for (int index = 0; index < items.length; index++) {
          final item = items[index];
          popups.add(
            PositionedFollower(
              index: index,
              child: item.popUp,
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
