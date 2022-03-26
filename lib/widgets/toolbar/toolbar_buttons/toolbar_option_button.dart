import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_buttons/toolbar_button.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class ToolbarOptionButton extends StatelessWidget {
  final OptionButtonData optionButtonData;

  const ToolbarOptionButton({
    Key? key,
    required this.optionButtonData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ToolbarData>(
      valueListenable: FloatingToolbar.of(context).toolbarDataNotifier,
      builder: (context, toolbarData, child) {
        return ToolbarButton(
          itemKey: kOptionItemKey,
          iconData: optionButtonData.iconData,
          label: optionButtonData.label,
          tooltip: optionButtonData.tooltip,
          toggleStateNotifier: optionButtonData.toggleStateNotifier,
          onPressed: optionButtonData.onPressed,
          alignment: toolbarData.alignment,
        );
      },
    );
  }
}
