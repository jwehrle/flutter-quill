import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_quill/widgets/toolbar/floating/flexes/popup_flex.dart';
import 'package:flutter_quill/widgets/toolbar/floating/utilities/operations.dart';
import 'package:flutter_quill/widgets/toolbar/floating/utilities/types.dart';
import 'package:flutter_quill/widgets/toolbar/floating/positioners/popup_positioner.dart';
import 'package:flutter_quill/widgets/toolbar/floating/positioners/toolbar_positioner.dart';

class FloatingToolbar extends StatefulWidget {
  final ToolbarData toolbarData;
  final ButtonData toolbarButtonData;
  final ButtonData popupButtonData;
  final List<Widget> toolbarButtons;
  final List<PopupFlex> popupFlexes;

  const FloatingToolbar({
    Key? key,
    required this.toolbarData,
    required this.toolbarButtonData,
    required this.popupButtonData,
    required this.toolbarButtons,
    required this.popupFlexes,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FloatingToolbarState();

  static FloatingToolbarState of(BuildContext context) {
    final result = context.findAncestorStateOfType<FloatingToolbarState>();
    assert(
      result != null,
      'FloatingToolbarState is not an ancestor of the calling widget.',
    );
    return result!;
  }
}

class FloatingToolbarState extends State<FloatingToolbar> {
  late final ValueNotifier<ToolbarData> toolbarDataNotifier;
  late final ValueNotifier<ButtonData> toolbarButtonDataNotifier;
  late final ValueNotifier<ButtonData> popupButtonDataNotifier;

  final ValueNotifier<double> toolbarOffsetNotifier = ValueNotifier(0.0);
  final ValueNotifier<String?> selectionNotifier = ValueNotifier(null);
  final ValueNotifier<BoxConstraints?> _constraintsNotifier =
      ValueNotifier(null);

  final ScrollController _scrollController = ScrollController();

  void _setToolbarOffset() {
    if (_constraintsNotifier.value != null) {
      int buttonCount = widget.toolbarButtons.length;
      toolbarDataNotifier.value = toolbarDataNotifier.value.fitted(
        _constraintsNotifier.value!,
        toolbarButtonDataNotifier.value,
        buttonCount,
      );
      toolbarOffsetNotifier.value = toolbarOffset(
        toolbarData: toolbarDataNotifier.value,
        constraints: _constraintsNotifier.value!,
        scrollOffset: _scrollController.offset,
        buttonData: toolbarButtonDataNotifier.value,
        buttonCount: buttonCount,
      );
    }
  }

  @override
  void initState() {
    toolbarDataNotifier = ValueNotifier(widget.toolbarData);
    toolbarButtonDataNotifier = ValueNotifier(widget.toolbarButtonData);
    popupButtonDataNotifier = ValueNotifier(widget.popupButtonData);
    _scrollController.addListener(_setToolbarOffset);
    _constraintsNotifier.addListener(_setToolbarOffset);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
          _constraintsNotifier.value = constraints;
        });
        return ValueListenableBuilder<ToolbarData>(
          valueListenable: toolbarDataNotifier,
          builder: (context, data, _) {
            Axis direction = toolbarAxisFromAlignment(data.alignment);
            EdgeInsets padding;
            switch (direction) {
              case Axis.horizontal:
                padding = EdgeInsets.only(left: data.buttonSpacing);
                break;
              case Axis.vertical:
                padding = EdgeInsets.only(top: data.buttonSpacing);
                break;
            }
            assert(widget.toolbarButtons.isNotEmpty);
            List<Widget> children = [widget.toolbarButtons.first];
            for (int index = 1; index < widget.toolbarButtons.length; index++) {
              children.add(Padding(padding: padding));
              children.add(widget.toolbarButtons[index]);
            }
            return ConstrainedBox(
              constraints: constraints,
              child: Stack(
                children: [
                  ToolbarPositioner(
                    scrollController: _scrollController,
                    children: children,
                  ),
                  PopupPositioner(
                    buttonCount: widget.toolbarButtons.length,
                    children: widget.popupFlexes,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant FloatingToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    toolbarDataNotifier.value = widget.toolbarData;
    toolbarButtonDataNotifier.value = widget.toolbarButtonData;
    popupButtonDataNotifier.value = widget.popupButtonData;
    if (_constraintsNotifier.value != null) {
      toolbarDataNotifier.value = toolbarDataNotifier.value.fitted(
        _constraintsNotifier.value!,
        toolbarButtonDataNotifier.value,
        widget.toolbarButtons.length,
      );
    }
  }

  @override
  void dispose() {
    toolbarDataNotifier.dispose();
    selectionNotifier.dispose();
    _scrollController.dispose();
    _constraintsNotifier.dispose();
    toolbarOffsetNotifier.dispose();
    toolbarButtonDataNotifier.dispose();
    popupButtonDataNotifier.dispose();
    super.dispose();
  }
}
