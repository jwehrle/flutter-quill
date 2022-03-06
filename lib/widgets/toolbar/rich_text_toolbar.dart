import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/positioners/toolbar_positioner.dart';
import 'package:flutter_quill/widgets/toolbar/positioners/popup_positioner.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/operations.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class RichTextToolbar extends StatefulWidget {
  final QuillController controller;
  final ToolbarType type;
  final Color foreground;
  final Color background;
  final ToolbarAlignment alignment;
  final Color disabled;
  final OptionButtonParameters? optionButtonParameters;

  const RichTextToolbar({
    Key? key,
    required this.type,
    required this.background,
    required this.foreground,
    required this.controller,
    this.alignment = ToolbarAlignment.bottomCenter,
    this.disabled = Colors.grey,
    this.optionButtonParameters,
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
  late final ValueNotifier<Color> foregroundColor;
  late final ValueNotifier<Color> backgroundColor;
  late final ValueNotifier<Color> disabledColor;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<BoxConstraints?> _constraintsNotifier =
      ValueNotifier(null);
  final ValueNotifier<double> toolbarOffsetNotifier = ValueNotifier(0.0);
  late final ValueNotifier<ToolbarType> toolbarTypeNotifier;
  late final ValueNotifier<ToolbarAlignment> alignmentNotifier;
  final ValueNotifier<String?> selectionNotifier = ValueNotifier(null);

  @override
  void initState() {
    foregroundColor = ValueNotifier(widget.foreground);
    backgroundColor = ValueNotifier(widget.background);
    disabledColor = ValueNotifier(widget.disabled);
    toolbarTypeNotifier = ValueNotifier(widget.type);
    alignmentNotifier = ValueNotifier(widget.alignment);
    alignmentNotifier.addListener(_setToolbarOffset);
    _scrollController.addListener(_setToolbarOffset);
    _constraintsNotifier.addListener(_setToolbarOffset);
    super.initState();
  }

  void _setToolbarOffset() {
    if (_constraintsNotifier.value != null) {
      int itemCount = toolbarItemCount(toolbarTypeNotifier.value);
      alignmentNotifier.value = layoutAlignment(
        constraints: _constraintsNotifier.value!,
        buttonCount: itemCount,
        alignment: widget.alignment,
      );
      toolbarOffsetNotifier.value = toolbarOffset(
        itemsCount: itemCount,
        alignment: alignmentNotifier.value,
        constraints: _constraintsNotifier.value!,
        scrollOffset: _scrollController.offset,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        _constraintsNotifier.value = constraints;
      });
      return ConstrainedBox(
        constraints: constraints,
        child: Stack(
          children: [
            PopupPositioner(controller: widget.controller),
            ToolbarPositioner(
              controller: widget.controller,
              scrollController: _scrollController,
              optionButtonParameters: widget.optionButtonParameters,
            ),
          ],
        ),
      );
    });
  }

  @override
  void didUpdateWidget(covariant RichTextToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    toolbarTypeNotifier.value = widget.type;
    foregroundColor.value = widget.foreground;
    backgroundColor.value = widget.background;
    disabledColor.value = widget.disabled;
    if (_constraintsNotifier.value != null) {
      alignmentNotifier.value = layoutAlignment(
        constraints: _constraintsNotifier.value!,
        buttonCount: toolbarItemCount(toolbarTypeNotifier.value),
        alignment: widget.alignment,
      );
    }
  }

  @override
  void dispose() {
    selectionNotifier.dispose();
    _scrollController.dispose();
    alignmentNotifier.dispose();
    _constraintsNotifier.dispose();
    toolbarOffsetNotifier.dispose();
    foregroundColor.dispose();
    backgroundColor.dispose();
    disabledColor.dispose();
    super.dispose();
  }
}
