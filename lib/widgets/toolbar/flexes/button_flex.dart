import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/rich_text_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/operations.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class ButtonFlex extends StatelessWidget {
  final QuillController controller;
  final IconData? optionIconData;
  final String? optionLabel;
  final String? optionTooltip;
  final VoidCallback? optionOnPressed;
  final ValueNotifier<ToggleState>? optionToggleStateNotifier;

  const ButtonFlex({
    Key? key,
    required this.controller,
    this.optionIconData,
    this.optionLabel,
    this.optionTooltip,
    this.optionOnPressed,
    this.optionToggleStateNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarAlignment>(
      valueListenable: RichTextToolbar.of(context).alignmentNotifier,
      builder: (context, alignment, child) {
        return ValueListenableBuilder<ToolbarType>(
          valueListenable: RichTextToolbar.of(context).toolbarTypeNotifier,
          builder: (context, type, child) {
            List<Widget> buttons = toolbarButtons(
              type: type,
              controller: controller,
              optionIconData: optionIconData,
              optionLabel: optionLabel,
              optionTooltip: optionTooltip,
              optionOnPressed: optionOnPressed,
              optionToggleStateNotifier: optionToggleStateNotifier,
            );
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
