import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/floating/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/operations.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class RichTextToolbar extends StatefulWidget {
  final RichTextToolbarType toolbarType;
  final QuillController controller;
  final ToolbarData toolbarData;
  final ButtonData toolbarButtonData;
  final ButtonData popupButtonData;
  final OptionButtonData? optionButtonParameters;

  const RichTextToolbar({
    Key? key,
    required this.toolbarType,
    required this.controller,
    required this.toolbarData,
    this.optionButtonParameters,
    required this.toolbarButtonData,
    required this.popupButtonData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => RichTextToolbarState();

  static RichTextToolbarState of(BuildContext context) {
    final result = context.findAncestorStateOfType<RichTextToolbarState>();
    assert(result != null,
        'ToolbarFrameState is not an ancestor of the calling widget.');
    return result!;
  }
}

class RichTextToolbarState extends State<RichTextToolbar> {
  late final ValueNotifier<RichTextToolbarType> toolbarTypeNotifier;

  @override
  void initState() {
    toolbarTypeNotifier = ValueNotifier(widget.toolbarType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RichTextToolbarType>(
        valueListenable: toolbarTypeNotifier,
        builder: (context, type, _) {
          return FloatingToolbar(
            toolbarData: widget.toolbarData,
            toolbarButtonData: widget.toolbarButtonData,
            popupButtonData: widget.popupButtonData,
            toolbarButtons: toolbarButtons(
              type: type,
              controller: widget.controller,
              optionButtonParameters: widget.optionButtonParameters,
            ),
            popupFlexes: toolbarPopups(
              type: type,
              controller: widget.controller,
            ),
          );
        });
  }

  @override
  void didUpdateWidget(covariant RichTextToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    toolbarTypeNotifier.value = widget.toolbarType;
  }

  @override
  void dispose() {
    toolbarTypeNotifier.dispose();
    super.dispose();
  }
}
