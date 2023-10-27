import 'package:community_material_icon/community_material_icon.dart';
import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/buttons/block_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/toggles/toggle.dart';
import 'package:flutter_quill/utils/labels.dart';
import 'package:flutter_quill/widgets/toolbar/items/quill_item.dart';
import 'package:iconic_button/iconic_button.dart';

/// Makes a [FloatingToolbarItem] with quote and code popups
class BlockItem extends QuillItem with ToggleMixin {
  BlockItem({
    required QuillController controller,
    required Disposer disposer,
    required super.style,
    super.onFinished,
    super.iconData = CommunityMaterialIcons.format_pilcrow,
    super.label = kBlockLabel,
    super.tooltip = kBlockTooltip,
    this.quoteBlockIconData = Icons.format_quote,
    this.quoteBlockLabel,
    this.quoteBlockTooltip = kQuoteTooltip,
    this.codeBlockIconData = Icons.code,
    this.codeBlocklabel,
    this.codeBlockTooltip = kCodeTooltip,
  }) {
    _blockController = BlockController(controller);
    _quoteController = ButtonController(
        value: initButtonStateFromToggleState(_blockController.quote));
    _codeController = ButtonController(
        value: initButtonStateFromToggleState(_blockController.code));
    _blockController.quoteListenable.addListener(() => toggleListener(
          _blockController.quote,
          _quoteController,
        ));
    _blockController.codeListenable.addListener(() => toggleListener(
          _blockController.code,
          _codeController,
        ));
    disposer.onDispose.then((_) {
      _blockController.dispose();
      _quoteController.dispose();
      _codeController.dispose();
    });
  }

  late final BlockController _blockController;
  late final ButtonController _quoteController;
  late final ButtonController _codeController;

  /// Quote block popup button IconData, defaults to [Icons.format_quote]
  final IconData quoteBlockIconData;

  /// Quote block popup button label, defaults to [Null]
  final String? quoteBlockLabel;

  /// Quote block popup button tooltip, defaults to 'Format text as quote block'
  final String quoteBlockTooltip;

  /// Code block popup button IconData, defaults to [Icons.code]
  final IconData codeBlockIconData;

  /// Code block popup button label, defaults to [Null]
  final String? codeBlocklabel;

  /// code block popup button tooltip, defaults to 'Format text as code block',
  final String codeBlockTooltip;

  PopupData popupData(BlockPopup type, Set<ButtonState> state) {
    final icon;
    final label;
    final tooltip;
    final attribute;
    
    switch (type) {
      case BlockPopup.code:
        icon = codeBlockIconData;
        label = codeBlocklabel;
        tooltip = codeBlockTooltip;
        attribute = Attribute.codeBlock;
        break;
      case BlockPopup.quote:
        icon = quoteBlockIconData;
        label = quoteBlockLabel;
        tooltip = quoteBlockTooltip;
        attribute = Attribute.blockQuote;
        break;
    }
    final onPressed = () {
      toggle(
        state: _blockController.quote,
        attribute: attribute,
        controller: _blockController.controller,
      );
      if (onFinished != null) {
        onFinished!();
      }
    };
    return PopupData(
      isSelectable: false,
      isSelected: state.contains(ButtonState.selected),
      isEnabled: state.contains(ButtonState.enabled),
      iconData: icon,
      label: label,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }

  @override
  FloatingToolbarItem build() {
    return FloatingToolbarItem.popup(
      toolbarButton,
      [
        PopupItemBuilder(
          controller: _quoteController,
          builder: (context, state, _) =>
              popupFrom(popupData(BlockPopup.quote, state)),
        ),
        PopupItemBuilder(
          controller: _codeController,
          builder: (context, state, _) =>
              popupFrom(popupData(BlockPopup.code, state)),
        ),
      ],
    );
  }
}
