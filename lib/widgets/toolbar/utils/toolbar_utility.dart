import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/models/constants.dart';
import 'package:flutter_quill/widgets/toolbar/models/types.dart';
import 'package:flutter_quill/widgets/toolbar/utils/controller_utility.dart';
import 'package:flutter_quill/widgets/toolbar/widgets/tiles.dart';
import 'package:mdi/mdi.dart';

class ToolbarUtility {
  final ControllerUtility ctrlUtil;
  final ToolbarAlignment alignment;
  late final bool _preferTooltipBelow;
  final ButtonStyling toolbarButtonStyling;
  final ButtonStyling popupButtonStyling;
  final OptionButtonData? optionButtonData;

  ToolbarUtility({
    required this.ctrlUtil,
    required this.alignment,
    required this.toolbarButtonStyling,
    required this.popupButtonStyling,
    this.optionButtonData,
  }) {
    switch (alignment) {
      case ToolbarAlignment.topLeftVertical:
      case ToolbarAlignment.topLeftHorizontal:
      case ToolbarAlignment.topCenterHorizontal:
      case ToolbarAlignment.topRightHorizontal:
      case ToolbarAlignment.topRightVertical:
      case ToolbarAlignment.centerLeftVertical:
      case ToolbarAlignment.centerRightVertical:
        _preferTooltipBelow = true;
        break;
      case ToolbarAlignment.bottomLeftVertical:
      case ToolbarAlignment.bottomRightVertical:
      case ToolbarAlignment.bottomLeftHorizontal:
      case ToolbarAlignment.bottomCenterHorizontal:
      case ToolbarAlignment.bottomRightHorizontal:
        _preferTooltipBelow = false;
        break;
    }
  }

  ToolbarItem popItem(ToolbarPopupType type) => ToolbarItem.pop(
        itemKey: popItemKey(type),
        popupButtonBuilder: (data) => popBuild(type: type, data: data),
        popupListBuilder: (data) => popListBuild(type: type, data: data),
      );

  PopupButton popBuild({
    required ToolbarPopupType type,
    required PopupButtonData data,
  }) {
    final IconData iconData;
    final String label;
    final String tooltip;
    switch (type) {
      case ToolbarPopupType.align:
        iconData = Icons.format_align_left;
        label = kAlignLabel;
        tooltip = kAlignTooltip;
        break;
      case ToolbarPopupType.block:
        iconData = Mdi.formatPilcrow;
        label = kBlockLabel;
        tooltip = kBlockTooltip;
        break;
      case ToolbarPopupType.indent:
        iconData = Icons.format_indent_increase;
        label = kIndentLabel;
        tooltip = kIndentTooltip;
        break;
      case ToolbarPopupType.list:
        iconData = Mdi.viewList;
        label = kListLabel;
        tooltip = kListTooltip;
        break;
      case ToolbarPopupType.size:
        iconData = Icons.format_size;
        label = kSizeLabel;
        tooltip = kSizeTooltip;
        break;
      case ToolbarPopupType.style:
        iconData = Mdi.formatFont;
        label = kStyleLabel;
        tooltip = kStyleTooltip;
        break;
    }
    return PopupButton(
      data: data,
      unselectedButton: OffTile(
        iconData: iconData,
        label: label,
        tooltip: tooltip,
        styling: toolbarButtonStyling,
        preferTooltipBelow: _preferTooltipBelow,
      ),
      selectedButton: OnTile(
        iconData: Icons.format_align_left,
        label: kAlignLabel,
        tooltip: kAlignTooltip,
        styling: toolbarButtonStyling,
        preferTooltipBelow: _preferTooltipBelow,
      ),
    );
  }

  PopupList popListBuild({
    required ToolbarPopupType type,
    required PopupListData data,
  }) {
    switch (type) {
      case ToolbarPopupType.style:
        return PopupList(
          data: data,
          buttons: [
            attributeTogglePopup(PopupToggleType.bold),
            attributeTogglePopup(PopupToggleType.italic),
            attributeTogglePopup(PopupToggleType.under),
            attributeTogglePopup(PopupToggleType.strike),
          ],
        );
      case ToolbarPopupType.size:
        return PopupList(
          data: data,
          buttons: [
            attributeScalarPopup(PopupScalarType.sizePlus),
            attributeScalarPopup(PopupScalarType.sizeMinus),
          ],
        );
      case ToolbarPopupType.indent:
        return PopupList(
          data: data,
          buttons: [
            attributeScalarPopup(PopupScalarType.indentPlus),
            attributeScalarPopup(PopupScalarType.indentMinus),
          ],
        );
      case ToolbarPopupType.list:
        return PopupList(
          data: data,
          buttons: [
            attributeTogglePopup(PopupToggleType.number),
            attributeTogglePopup(PopupToggleType.bullet),
          ],
        );
      case ToolbarPopupType.block:
        return PopupList(
          data: data,
          buttons: [
            attributeTogglePopup(PopupToggleType.quote),
            attributeTogglePopup(PopupToggleType.code),
          ],
        );
      case ToolbarPopupType.align:
        return PopupList(
          data: data,
          buttons: [
            attributeScalarPopup(PopupScalarType.leftAlign),
            attributeScalarPopup(PopupScalarType.rightAlign),
            attributeScalarPopup(PopupScalarType.centerAlign),
            attributeScalarPopup(PopupScalarType.justifyAlign),
          ],
        );
    }
  }

  Widget attributeTogglePopup(PopupToggleType type) => PopupToggleTile(
        type: type,
        notifier: ctrlUtil.popupToggleNotifier(type),
        controller: ctrlUtil.controller,
        styling: popupButtonStyling,
        preferTooltipBelow: _preferTooltipBelow,
        isLabeled: false,
      );

  Widget attributeScalarPopup(PopupScalarType type) => ScalarTile(
        type: type,
        notifier: ctrlUtil.popupScalarNotifier(type),
        controller: ctrlUtil.controller,
        styling: popupButtonStyling,
        preferTooltipBelow: _preferTooltipBelow,
        tooltipOffset: popupButtonStyling.tooltipOffset,
      );

  ToolbarItem noPopItem(ToolbarToggleType type) => ToolbarItem.noPop(
        itemKey: toolbarToggleItemKey(type),
        selectableButtonBuilder: (data) => SelectableButton(
          data: data,
          unselectedButton: ToolbarToggleTile(
            type: type,
            notifier: ctrlUtil.toolbarToggleNotifier(type),
            controller: ctrlUtil.controller,
            styling: toolbarButtonStyling,
            preferTooltipBelow: _preferTooltipBelow,
          ),
        ),
      );

  ToolbarItem optionItem() {
    assert(optionButtonData != null, 'No option button provided!');
    return ToolbarItem.noPop(
      itemKey: kOptionItemKey,
      selectableButtonBuilder: (data) => SelectableButton(
        data: data,
        unselectedButton: GestureDetector(
          onTap: optionButtonData!.onPressed,
          child: StyledTile(
            state: optionButtonData!.state,
            iconData: optionButtonData!.iconData,
            styling: optionButtonData!.styling,
            label: optionButtonData!.label,
            tooltip: optionButtonData!.tooltip,
            preferTooltipBelow: optionButtonData!.preferTooltipBelow,
          ),
        ),
      ),
    );
  }
}
