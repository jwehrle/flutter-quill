import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/floating/floating_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/floating/utilities/operations.dart';
import 'package:flutter_quill/widgets/toolbar/floating/utilities/types.dart';

class ButtonFlex extends StatelessWidget {
  final List<Widget> children;

  const ButtonFlex({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarData>(
      valueListenable: FloatingToolbar.of(context).toolbarDataNotifier,
      builder: (context, data, child) {
        Axis direction = toolbarAxisFromAlignment(data.alignment);
        return Flex(
          direction: direction,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      },
    );
  }
}
