import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/attribute_toggle_mixin.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/button_flex.dart';
import 'package:flutter_quill/widgets/toolbar/richtext_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

class ToolbarButtonBar extends StatelessWidget {
  final ScrollController scrollController;
  final QuillController controller;
  final IconData? optionIconData;
  final String? optionLabel;
  final VoidCallback? optionOnPressed;
  final ValueNotifier<ToggleState>? optionToggleStateNotifier;

  const ToolbarButtonBar({
    Key? key,
    required this.scrollController,
    required this.controller,
    this.optionIconData,
    this.optionLabel,
    this.optionOnPressed,
    this.optionToggleStateNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarAlignment>(
      valueListenable: RichTextToolbar.of(context).alignmentNotifier,
      builder: (context, alignment, child) {
        return Align(
          alignment: convertAlignment(alignment),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: toolbarAxisFromAlignment(alignment),
            reverse: isReverse(alignment),
            clipBehavior: Clip.none,
            child: ValueListenableBuilder<Color>(
                valueListenable: RichTextToolbar.of(context).backgroundColor,
                builder: (context, background, child) {
                  return Card(
                    margin: EdgeInsets.all(kToolbarMargin),
                    color: background,
                    child: ButtonFlex(
                      controller: controller,
                      optionIconData: optionIconData,
                      optionLabel: optionLabel,
                      optionOnPressed: optionOnPressed,
                      optionToggleStateNotifier: optionToggleStateNotifier,
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
