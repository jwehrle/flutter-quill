import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/utils/controller_utility.dart';
import 'package:flutter_quill/widgets/toolbar/utils/toolbar_utility.dart';
import 'package:flutter_quill/widgets/toolbar/models/types.dart';

class RichTextToolbar extends StatefulWidget {
  final QuillController controller;
  final ToolbarData toolbarData;
  final ButtonStyling toolbarButtonStyling;
  final ButtonStyling popupButtonStyling;
  final bool isExpanded;
  final OptionButtonData? optionButton;

  const RichTextToolbar({
    Key? key,
    required this.controller,
    required this.toolbarData,
    required this.toolbarButtonStyling,
    required this.popupButtonStyling,
    this.isExpanded = false,
    this.optionButton,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => RichTextToolbarState();
}

class RichTextToolbarState extends State<RichTextToolbar> {
  late final ControllerUtility _ctrlUtil;
  late final ToolbarUtility _toolUtil;

  @override
  void initState() {
    _ctrlUtil = ControllerUtility(controller: widget.controller);
    _toolUtil = ToolbarUtility(
      ctrlUtil: _ctrlUtil,
      alignment: widget.toolbarData.alignment,
      toolbarButtonStyling: widget.toolbarButtonStyling,
      popupButtonStyling: widget.popupButtonStyling,
      optionButtonData: widget.optionButton,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingToolbar(
      data: widget.toolbarData,
      items: widget.isExpanded
          ? [
              if (widget.optionButton != null) _toolUtil.optionItem(),
              _toolUtil.noPopItem(ToolbarToggleType.bold),
              _toolUtil.noPopItem(ToolbarToggleType.italic),
              _toolUtil.noPopItem(ToolbarToggleType.under),
              _toolUtil.noPopItem(ToolbarToggleType.strike),
              _toolUtil.popItem(ToolbarPopupType.size),
              _toolUtil.popItem(ToolbarPopupType.indent),
              _toolUtil.noPopItem(ToolbarToggleType.bullet),
              _toolUtil.noPopItem(ToolbarToggleType.number),
              _toolUtil.noPopItem(ToolbarToggleType.quote),
              _toolUtil.noPopItem(ToolbarToggleType.code),
              _toolUtil.popItem(ToolbarPopupType.align),
              _toolUtil.noPopItem(ToolbarToggleType.link),
            ]
          : [
              if (widget.optionButton != null) _toolUtil.optionItem(),
              _toolUtil.popItem(ToolbarPopupType.style),
              _toolUtil.popItem(ToolbarPopupType.size),
              _toolUtil.popItem(ToolbarPopupType.indent),
              _toolUtil.popItem(ToolbarPopupType.list),
              _toolUtil.popItem(ToolbarPopupType.block),
              _toolUtil.popItem(ToolbarPopupType.align),
              _toolUtil.noPopItem(ToolbarToggleType.link),
            ],
    );
  }

  @override
  void dispose() {
    _ctrlUtil.dispose();
    super.dispose();
  }
}
