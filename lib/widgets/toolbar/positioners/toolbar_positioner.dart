import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/flexes/button_flex.dart';
import 'package:flutter_quill/widgets/toolbar/rich_text_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/operations.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class ToolbarPositioner extends StatelessWidget {
  final ScrollController scrollController;
  final QuillController controller;
  final OptionButtonParameters? optionButtonParameters;

  const ToolbarPositioner({
    Key? key,
    required this.scrollController,
    required this.controller,
    this.optionButtonParameters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarAlignment>(
      valueListenable: RichTextToolbar.of(context).alignmentNotifier,
      builder: (context, alignment, child) {
        Axis axis = toolbarAxisFromAlignment(alignment);
        return Align(
          alignment: convertAlignment(alignment),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: axis,
            reverse: isReverse(alignment),
            clipBehavior: Clip.none,
            child: ValueListenableBuilder<Color>(
                valueListenable: RichTextToolbar.of(context).backgroundColor,
                builder: (context, background, child) {
                  return Card(
                    margin: EdgeInsets.all(kToolbarMargin),
                    color: background,
                    child: Padding(
                      padding: axis == Axis.horizontal
                          ? EdgeInsets.symmetric(vertical: kToolbarTilePadding)
                          : EdgeInsets.symmetric(
                              horizontal: kToolbarTilePadding),
                      child: ButtonFlex(
                        controller: controller,
                        optionButtonParameters: optionButtonParameters,
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
