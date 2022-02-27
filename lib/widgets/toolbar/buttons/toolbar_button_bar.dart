import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/button_flex.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

class ToolbarButtonBar extends StatelessWidget {
  final ScrollController scrollController;
  final QuillController controller;
  final FocusNode? focusNode;

  const ToolbarButtonBar({
    Key? key,
    required this.scrollController,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarAlignment>(
      valueListenable: Toolbar.of(context).alignmentNotifier,
      builder: (context, alignment, child) {
        return Align(
          alignment: convertAlignment(alignment),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: toolbarAxisFromAlignment(alignment),
            reverse: isReverse(alignment),
            clipBehavior: Clip.none,
            child: ValueListenableBuilder<Color>(
                valueListenable: Toolbar.of(context).backgroundColor,
                builder: (context, background, child) {
                  return Card(
                    margin: EdgeInsets.all(kToolbarMargin),
                    color: background,
                    child: ButtonFlex(
                      controller: controller,
                      focusNode: focusNode,
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
