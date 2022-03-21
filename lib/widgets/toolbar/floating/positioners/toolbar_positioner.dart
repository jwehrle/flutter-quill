import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/floating/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/floating/utilities/utilities.dart';

class ToolbarPositioner extends StatelessWidget {
  final ScrollController scrollController;
  final List<Widget> children;

  const ToolbarPositioner({
    Key? key,
    required this.scrollController,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarData>(
      valueListenable: FloatingToolbar.of(context).toolbarDataNotifier,
      builder: (context, data, child) {
        return Align(
          alignment: convertAlignment(data.alignment),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: toolbarAxisFromAlignment(data.alignment),
            reverse: isReverse(data.alignment),
            clipBehavior: Clip.none,
            child: Padding(
              padding: data.margin,
              child: Material(
                color: data.backgroundColor,
                shape: data.shape,
                clipBehavior: data.clip,
                elevation: data.elevation,
                child: Padding(
                  padding: data.contentPadding,
                  child: ButtonFlex(
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
