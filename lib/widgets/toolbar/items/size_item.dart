import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/controllers/buttons/size_controller.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/utils/labels.dart';
import 'package:flutter_quill/widgets/toolbar/items/quill_item.dart';
import 'package:iconic_button/iconic_button.dart';

/// Makes a [FloatingToolbarItem] with sizePlus and sizeMinus popups
class SizeItem extends QuillItem {
  SizeItem({
    required QuillController controller,
    required Disposer disposer,
    required super.style,
    super.onFinished,
    super.iconData = Icons.format_size,
    super.label = kSizeLabel,
    super.tooltip = kSizeTooltip,
    super.preferBelow = false,
    this.sizePlusIconData = Icons.arrow_upward,
    this.sizePlusLabel,
    this.sizePlusTooltip = kSizePlusTooltip,
    this.sizeMinusIconData = Icons.arrow_downward,
    this.sizeMinusLabel,
    this.sizeMinusTooltip = kSizeMinusTooltip,
  }) {
    _sizeController = SizeController(controller);
    _sizePlusController = ButtonController(
      value: _sizePlusStateFromAttribute(_sizeController.size),
    );
    _sizeMinusController = ButtonController(
      value: _sizeMinusStateFromAttribute(_sizeController.size),
    );
    _sizeController.sizeListenable.addListener(() => _onSizeChanged(
          size: _sizeController.size,
          plusController: _sizePlusController,
          minusController: _sizeMinusController,
        ));
    disposer.onDispose.then((_) {
      _sizeController.dispose();
      _sizePlusController.dispose();
      _sizeMinusController.dispose();
    });
  }

  late final SizeController _sizeController;
  late final ButtonController _sizePlusController;
  late final ButtonController _sizeMinusController;

  /// Size plus popup button IconData, defaults to [Icons.arrow_upward]
  final IconData sizePlusIconData;

  /// Size plus popup button label, defaults to [Null]
  final String? sizePlusLabel;

  /// Size plus popup button tooltip, defaults to 'Increase font size'
  final String sizePlusTooltip;

  /// Size minus popup button IconData, defaults to [Icons.arrow_downward]
  final IconData sizeMinusIconData;

  /// Size minus popup button label, defaults to [Null]
  final String? sizeMinusLabel;

  /// Size minus popup button tooltip, defaults to 'Decrease font size'
  final String sizeMinusTooltip;

  Set<ButtonState> _sizePlusStateFromAttribute(Attribute? attribute) {
    if (attribute?.value == 1) {
      return {};
    } else {
      return {ButtonState.enabled};
    }
  }

  Set<ButtonState> _sizeMinusStateFromAttribute(Attribute? attribute) {
    if (attribute?.value == null) {
      return {};
    } else {
      return {ButtonState.enabled};
    }
  }

  void _onSizeChanged({
    required Attribute? size,
    required ButtonController plusController,
    required ButtonController minusController,
  }) {
    if (_sizePlusStateFromAttribute(size).contains(ButtonState.enabled)) {
      plusController.enable();
    } else {
      plusController.disable();
    }
    if (_sizeMinusStateFromAttribute(size).contains(ButtonState.enabled)) {
      minusController.enable();
    } else {
      minusController.disable();
    }
  }

  /// h1 > h2 > h3 > header
  Attribute? _incrementSize(Attribute? attribute) {
    print('incrementSize called with $attribute');
    if (attribute == null) {
      attribute = Attribute.header;
    }
    if (attribute == Attribute.h1) {
      return null;
    }
    if (attribute == Attribute.h2) {
      return Attribute.h1;
    }
    if (attribute == Attribute.h3) {
      return Attribute.h2;
    }
    if (attribute == Attribute.header) {
      return Attribute.h3;
    }
    return null;
  }

  /// header < h3 < h2 < h1
  Attribute? _decrementSize(Attribute? attribute) {
    if (attribute == null) {
      attribute = Attribute.header;
    }
    if (attribute == Attribute.header) {
      return null;
    }
    if (attribute == Attribute.h1) {
      return Attribute.h2;
    }
    if (attribute == Attribute.h2) {
      return Attribute.h3;
    }
    if (attribute == Attribute.h3) {
      return Attribute.header;
    }
    return null;
  }

  Attribute? _alterSize(SizePopup type) {
    switch (type) {
      case SizePopup.minus:
        return _decrementSize(_sizeController.size);
      case SizePopup.plus:
        return _incrementSize(_sizeController.size);
    }
  }

  PopupData popupData(SizePopup type, Set<ButtonState> state) {
    final icon;
    final label;
    final tooltip;
    switch (type) {
      case SizePopup.minus:
        icon = sizeMinusIconData;
        label = sizeMinusLabel;
        tooltip = sizeMinusTooltip;
        break;
      case SizePopup.plus:
        icon = sizePlusIconData;
        label = sizePlusLabel;
        tooltip = sizePlusTooltip;
        break;
    }
    final onPressed = () {
      final attr = _alterSize(type);
      if (attr != null) {
        _sizeController.controller.formatSelection(attr);
      }
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
          controller: _sizePlusController,
          builder: (context, state, _) =>
              popupFrom(popupData(SizePopup.plus, state)),
        ),
        PopupItemBuilder(
          controller: _sizeMinusController,
          builder: (context, state, _) =>
              popupFrom(popupData(SizePopup.minus, state)),
        ),
      ],
    );
  }
}
