import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/richtext_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_item.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/toolbar_tile.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

class ButtonFlex extends StatelessWidget {
  final QuillController controller;
  final FocusNode? focusNode;

  const ButtonFlex({
    Key? key,
    required this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarAlignment>(
      valueListenable: RichTextToolbar.of(context).alignmentNotifier,
      builder: (context, alignment, child) {
        return ValueListenableBuilder<ToolbarType>(
          valueListenable: RichTextToolbar.of(context).toolbarTypeNotifier,
          builder: (context, type, child) {
            final List<ToolbarItem> items = toolbarItems(
              type: type,
              controller: controller,
              focusNode: focusNode,
            );
            List<Widget> buttons = items.map((e) => e.button).toList();
            Axis direction = toolbarAxisFromAlignment(alignment);
            EdgeInsets padding;
            switch (direction) {
              case Axis.horizontal:
                padding = EdgeInsets.only(left: kToolbarTilePadding);
                break;
              case Axis.vertical:
                padding = EdgeInsets.only(top: kToolbarTilePadding);
                break;
            }
            List<Widget> children = [Padding(padding: padding)];
            buttons.forEach((button) {
              children.add(button);
              children.add(Padding(padding: padding));
            });
            return Flex(
              direction: direction,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: children,
            );
          },
        );
      },
    );
  }
}
