import 'package:floating_toolbar/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/models/constants.dart';
import 'package:flutter_quill/widgets/toolbar/models/types.dart';

/// h1 > h2 > h3 > header
Attribute? _incrementSize(Attribute? attribute) {
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
}

/// indentL3 > indentL2 > indentL1
Attribute? _incrementIndent(Attribute? attribute) {
  if (attribute == null) {
    return Attribute.indentL1;
  }
  if (attribute == Attribute.indentL3) {
    return null;
  }
  return Attribute.getIndentLevel(attribute.value + 1);
}

/// indentL1 < indentL2 < indentL3
Attribute? _decrementIndent(Attribute? attribute) {
  if (attribute == null) {
    return null;
  }
  if (attribute == Attribute.indentL1) {
    return Attribute.clone(Attribute.indentL1, null);
  }
  return Attribute.getIndentLevel(attribute.value - 1);
}

final Attribute _noAlignment = Attribute(
  key: 'align',
  scope: AttributeScope.BLOCK,
  value: null,
);

class ScalarTile extends StatelessWidget {
  final PopupScalarType type;
  final ValueNotifier<Attribute?> notifier;
  final QuillController controller;
  final ButtonStyling styling;
  final bool preferTooltipBelow;
  final double tooltipOffset;

  const ScalarTile({
    Key? key,
    required this.type,
    required this.notifier,
    required this.controller,
    required this.styling,
    required this.preferTooltipBelow,
    required this.tooltipOffset,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    IconData iconData;
    String tooltip;
    VoidCallback onPressed;
    switch (type) {
      case PopupScalarType.indentMinus:
        iconData = Icons.arrow_back;
        tooltip = kIndentMinusTooltip;
        onPressed = () {
          final attr = _decrementIndent(notifier.value);
          if (attr != null) {
            controller.formatSelection(attr);
          }
        };
        break;
      case PopupScalarType.indentPlus:
        iconData = Icons.arrow_forward;
        tooltip = kIndentPlusTooltip;
        onPressed = () {
          final attr = _incrementIndent(notifier.value);
          if (attr != null) {
            controller.formatSelection(attr);
          }
        };
        break;
      case PopupScalarType.sizeMinus:
        iconData = Icons.arrow_downward;
        tooltip = kSizeMinusTooltip;
        onPressed = () {
          final attr = _decrementSize(notifier.value);
          if (attr != null) {
            controller.formatSelection(attr);
          }
        };
        break;
      case PopupScalarType.sizePlus:
        iconData = Icons.arrow_upward;
        tooltip = kSizePlusTooltip;
        onPressed = () {
          final attr = _incrementSize(notifier.value);
          if (attr != null) {
            controller.formatSelection(attr);
          }
        };
        break;
      case PopupScalarType.leftAlign:
        iconData = Icons.format_align_left;
        tooltip = kLeftAlignTooltip;
        onPressed = () {
          if (notifier.value == Attribute.leftAlignment) {
            controller.formatSelection(_noAlignment);
          } else {
            controller.formatSelection(Attribute.leftAlignment);
          }
        };
        break;
      case PopupScalarType.rightAlign:
        iconData = Icons.format_align_right;
        tooltip = kRightAlignTooltip;
        onPressed = () {
          if (notifier.value == Attribute.rightAlignment) {
            controller.formatSelection(_noAlignment);
          } else {
            controller.formatSelection(Attribute.rightAlignment);
          }
        };
        break;
      case PopupScalarType.centerAlign:
        iconData = Icons.format_align_center;
        tooltip = kCenterAlignTooltip;
        onPressed = () {
          if (notifier.value == Attribute.centerAlignment) {
            controller.formatSelection(_noAlignment);
          } else {
            controller.formatSelection(Attribute.centerAlignment);
          }
        };
        break;
      case PopupScalarType.justifyAlign:
        iconData = Icons.format_align_justify;
        tooltip = kJustifyAlignTooltip;
        onPressed = () {
          if (notifier.value == Attribute.justifyAlignment) {
            controller.formatSelection(_noAlignment);
          } else {
            controller.formatSelection(Attribute.justifyAlignment);
          }
        };
        break;
    }
    return ValueListenableBuilder<Attribute?>(
      valueListenable: notifier,
      builder: (context, attribute, _) {
        Attribute? nextAttr;
        bool isOn = false;
        switch (type) {
          case PopupScalarType.indentMinus:
            nextAttr = _decrementIndent(notifier.value);
            break;
          case PopupScalarType.indentPlus:
            nextAttr = _incrementIndent(notifier.value);
            break;
          case PopupScalarType.sizeMinus:
            nextAttr = _decrementSize(notifier.value);
            break;
          case PopupScalarType.sizePlus:
            nextAttr = _incrementSize(notifier.value);
            break;
          case PopupScalarType.leftAlign:
            isOn = notifier.value == Attribute.leftAlignment;
            nextAttr = isOn ? _noAlignment : Attribute.leftAlignment;
            break;
          case PopupScalarType.rightAlign:
            isOn = notifier.value == Attribute.rightAlignment;
            nextAttr = isOn ? _noAlignment : Attribute.rightAlignment;
            break;
          case PopupScalarType.centerAlign:
            isOn = notifier.value == Attribute.centerAlignment;
            nextAttr = isOn ? _noAlignment : Attribute.centerAlignment;
            break;
          case PopupScalarType.justifyAlign:
            isOn = notifier.value == Attribute.justifyAlignment;
            nextAttr = isOn ? _noAlignment : Attribute.justifyAlignment;
            break;
        }
        bool isDisabled = nextAttr == null;
        return GestureDetector(
          onTap: isDisabled ? null : onPressed,
          child: ButtonTile(
            iconData: iconData,
            foregroundColor: isOn
                ? styling.backgroundColor
                : isDisabled
                    ? styling.disabledColor
                    : styling.accentColor,
            decorationColor:
                isOn ? styling.accentColor : styling.backgroundColor,
            backgroundColor: styling.backgroundColor,
            buttonShape: styling.buttonShape,
            borderStyle: styling.borderStyle,
            borderRadius: styling.borderRadius,
            borderWidth: styling.borderWidth,
            internalPadding: styling.internalPadding,
            isMaterialized: styling.isMaterialized,
            radius: styling.radius,
            width: styling.width,
            height: styling.height,
            elevation: styling.elevation,
            tooltip: tooltip,
            preferTooltipBelow: preferTooltipBelow,
            tooltipOffset: tooltipOffset,
          ),
        );
      },
    );
  }
}

class PopupToggleTile extends StatelessWidget {
  final PopupToggleType type;
  final QuillController controller;
  final ValueNotifier<ToggleState> notifier;
  final ButtonStyling styling;
  final bool isLabeled;
  final bool? preferTooltipBelow;

  const PopupToggleTile({
    Key? key,
    required this.type,
    required this.notifier,
    required this.controller,
    required this.styling,
    required this.isLabeled,
    this.preferTooltipBelow,
  }) : super(key: key);

  _toggle(ValueNotifier<ToggleState> stateNotifier, Attribute attribute) {
    switch (stateNotifier.value) {
      case ToggleState.on:
        controller.formatSelection(Attribute.clone(attribute, null));
        stateNotifier.value = ToggleState.off;
        break;
      case ToggleState.off:
        controller.formatSelection(attribute);
        stateNotifier.value = ToggleState.on;
        break;
      case ToggleState.disabled:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback onPressed;
    IconData iconData;
    String tooltip;
    String? label;
    switch (type) {
      case PopupToggleType.bold:
        onPressed = () => _toggle(notifier, Attribute.bold);
        iconData = Icons.format_bold;
        tooltip = kBoldTooltip;
        label = isLabeled ? kBoldLabel : null;
        break;
      case PopupToggleType.bullet:
        onPressed = () => _toggle(notifier, Attribute.ul);
        iconData = Icons.format_list_bulleted;
        tooltip = kBulletTooltip;
        label = isLabeled ? kBulletLabel : null;
        break;
      case PopupToggleType.code:
        onPressed = () => _toggle(notifier, Attribute.codeBlock);
        iconData = Icons.code;
        tooltip = kCodeTooltip;
        label = isLabeled ? kCodeLabel : null;
        break;
      case PopupToggleType.italic:
        onPressed = () => _toggle(notifier, Attribute.italic);
        iconData = Icons.format_italic;
        tooltip = kItalicTooltip;
        label = isLabeled ? kItalicLabel : null;
        break;
      case PopupToggleType.number:
        onPressed = () => _toggle(notifier, Attribute.ol);
        iconData = Icons.format_list_numbered;
        tooltip = kNumberTooltip;
        label = isLabeled ? kNumberLabel : null;
        break;
      case PopupToggleType.quote:
        onPressed = () => _toggle(notifier, Attribute.blockQuote);
        iconData = Icons.format_quote;
        tooltip = kQuoteTooltip;
        label = isLabeled ? kQuoteLabel : null;
        break;
      case PopupToggleType.strike:
        onPressed = () => _toggle(notifier, Attribute.strikeThrough);
        iconData = Icons.format_strikethrough;
        tooltip = kStrikeTooltip;
        label = isLabeled ? kStrikeLabel : null;
        break;
      case PopupToggleType.under:
        onPressed = () => _toggle(notifier, Attribute.underline);
        iconData = Icons.format_underline;
        tooltip = kUnderTooltip;
        label = isLabeled ? kUnderLabel : null;
        break;
    }
    return GestureDetector(
      onTap: onPressed,
      child: ValueListenableBuilder<ToggleState>(
        valueListenable: notifier,
        builder: (context, state, child) {
          Color toggleForeground;
          Color toggleDecoration;
          switch (state) {
            case ToggleState.on:
              toggleForeground = styling.backgroundColor;
              toggleDecoration = styling.accentColor;
              break;
            case ToggleState.off:
              toggleForeground = styling.accentColor;
              toggleDecoration = styling.backgroundColor;
              break;
            case ToggleState.disabled:
              toggleForeground = styling.disabledColor;
              toggleDecoration = styling.backgroundColor;
              break;
          }
          return ButtonTile(
            iconData: iconData,
            label: label,
            foregroundColor: toggleForeground,
            decorationColor: toggleDecoration,
            backgroundColor: styling.backgroundColor,
            buttonShape: styling.buttonShape,
            borderStyle: styling.borderStyle,
            borderRadius: styling.borderRadius,
            internalPadding: styling.internalPadding,
            borderWidth: styling.borderWidth,
            radius: styling.radius,
            width: styling.width,
            height: styling.height,
            isMaterialized: styling.isMaterialized,
            elevation: styling.elevation,
            tooltip: tooltip,
            preferTooltipBelow: preferTooltipBelow,
            tooltipOffset: styling.tooltipOffset,
          );
        },
      ),
    );
  }
}

class _LinkDialog extends StatefulWidget {
  const _LinkDialog({Key? key}) : super(key: key);

  @override
  _LinkDialogState createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  String _link = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        decoration: InputDecoration(labelText: 'Paste a link'),
        autofocus: true,
        onChanged: _linkChanged,
      ),
      actions: [
        TextButton(
          onPressed: _link.isNotEmpty ? _applyLink : null,
          child: Text('Apply'),
        ),
      ],
    );
  }

  void _linkChanged(String value) {
    setState(() {
      _link = value;
    });
  }

  void _applyLink() {
    Navigator.pop(context, _link);
  }
}

class ToolbarToggleTile extends StatelessWidget {
  final ToolbarToggleType type;
  final QuillController controller;
  final ValueNotifier<ToggleState> notifier;
  final ButtonStyling styling;
  final bool? preferTooltipBelow;

  const ToolbarToggleTile({
    Key? key,
    required this.type,
    required this.notifier,
    required this.controller,
    required this.styling,
    this.preferTooltipBelow,
  }) : super(key: key);

  _toggle(ValueNotifier<ToggleState> stateNotifier, Attribute attribute) {
    switch (stateNotifier.value) {
      case ToggleState.on:
        controller.formatSelection(Attribute.clone(attribute, null));
        stateNotifier.value = ToggleState.off;
        break;
      case ToggleState.off:
        controller.formatSelection(attribute);
        stateNotifier.value = ToggleState.on;
        break;
      case ToggleState.disabled:
        break;
    }
  }

  void _openLinkDialog(
    BuildContext context,
    ValueNotifier<ToggleState> notifier,
  ) {
    notifier.value = ToggleState.on;
    showDialog<String>(
      context: context,
      builder: (ctx) {
        return _LinkDialog();
      },
    ).then((value) => _linkSubmitted(context, notifier, value));
  }

  void _linkSubmitted(BuildContext context, ValueNotifier<ToggleState> notifier,
      String? value) {
    notifier.value = controller.selection.isCollapsed
        ? ToggleState.disabled
        : ToggleState.off;
    if (value == null || value.isEmpty) {
      controller.selection = TextSelection.collapsed(offset: 0);
      return;
    }
    controller.formatSelection(LinkAttribute(value));
    controller.selection = TextSelection.collapsed(offset: 0);
    notifier.value = ToggleState.off;
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback onPressed;
    IconData iconData;
    String tooltip;
    String label;
    switch (type) {
      case ToolbarToggleType.bold:
        onPressed = () => _toggle(notifier, Attribute.bold);
        iconData = Icons.format_bold;
        tooltip = kBoldTooltip;
        label = kBoldLabel;
        break;
      case ToolbarToggleType.bullet:
        onPressed = () => _toggle(notifier, Attribute.ul);
        iconData = Icons.format_list_bulleted;
        tooltip = kBulletTooltip;
        label = kBulletLabel;
        break;
      case ToolbarToggleType.code:
        onPressed = () => _toggle(notifier, Attribute.codeBlock);
        iconData = Icons.code;
        tooltip = kCodeTooltip;
        label = kCodeLabel;
        break;
      case ToolbarToggleType.italic:
        onPressed = () => _toggle(notifier, Attribute.italic);
        iconData = Icons.format_italic;
        tooltip = kItalicTooltip;
        label = kItalicLabel;
        break;
      case ToolbarToggleType.number:
        onPressed = () => _toggle(notifier, Attribute.ol);
        iconData = Icons.format_list_numbered;
        tooltip = kNumberTooltip;
        label = kNumberLabel;
        break;
      case ToolbarToggleType.quote:
        onPressed = () => _toggle(notifier, Attribute.blockQuote);
        iconData = Icons.format_quote;
        tooltip = kQuoteTooltip;
        label = kQuoteLabel;
        break;
      case ToolbarToggleType.strike:
        onPressed = () => _toggle(notifier, Attribute.strikeThrough);
        iconData = Icons.format_strikethrough;
        tooltip = kStrikeTooltip;
        label = kStrikeLabel;
        break;
      case ToolbarToggleType.under:
        onPressed = () => _toggle(notifier, Attribute.underline);
        iconData = Icons.format_underline;
        tooltip = kUnderTooltip;
        label = kUnderLabel;
        break;
      case ToolbarToggleType.link:
        onPressed = () {
          if (notifier.value == ToggleState.off) {
            _openLinkDialog(context, notifier);
          }
        };
        iconData = Icons.link;
        tooltip = kLinkTooltip;
        label = kLinkLabel;
        break;
    }
    return GestureDetector(
      onTap: onPressed,
      child: ValueListenableBuilder<ToggleState>(
        valueListenable: notifier,
        builder: (context, state, child) {
          Color toggleForeground;
          Color toggleDecoration;
          switch (state) {
            case ToggleState.on:
              toggleForeground = styling.backgroundColor;
              toggleDecoration = styling.accentColor;
              break;
            case ToggleState.off:
              toggleForeground = styling.accentColor;
              toggleDecoration = styling.backgroundColor;
              break;
            case ToggleState.disabled:
              toggleForeground = styling.disabledColor;
              toggleDecoration = styling.backgroundColor;
              break;
          }
          return ButtonTile(
            iconData: iconData,
            label: label,
            foregroundColor: toggleForeground,
            decorationColor: toggleDecoration,
            backgroundColor: styling.backgroundColor,
            buttonShape: styling.buttonShape,
            borderStyle: styling.borderStyle,
            borderRadius: styling.borderRadius,
            internalPadding: styling.internalPadding,
            borderWidth: styling.borderWidth,
            radius: styling.radius,
            width: styling.width,
            height: styling.height,
            isMaterialized: styling.isMaterialized,
            elevation: styling.elevation,
            tooltip: tooltip,
            preferTooltipBelow: preferTooltipBelow,
            tooltipOffset: styling.tooltipOffset,
          );
        },
      ),
    );
  }
}

class StyledTile extends StatelessWidget {
  final ToggleState state;
  final IconData iconData;
  final String? label;
  final ButtonStyling styling;
  final String? tooltip;
  final bool? preferTooltipBelow;

  const StyledTile({
    Key? key,
    required this.state,
    required this.iconData,
    required this.styling,
    this.label,
    this.tooltip,
    this.preferTooltipBelow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color toggleForeground;
    Color toggleDecoration;
    switch (state) {
      case ToggleState.on:
        toggleForeground = styling.backgroundColor;
        toggleDecoration = styling.accentColor;
        break;
      case ToggleState.off:
        toggleForeground = styling.accentColor;
        toggleDecoration = styling.backgroundColor;
        break;
      case ToggleState.disabled:
        toggleForeground = styling.disabledColor;
        toggleDecoration = styling.backgroundColor;
        break;
    }
    return ButtonTile(
      iconData: iconData,
      label: label,
      foregroundColor: toggleForeground,
      decorationColor: toggleDecoration,
      backgroundColor: styling.backgroundColor,
      buttonShape: styling.buttonShape,
      borderStyle: styling.borderStyle,
      borderRadius: styling.borderRadius,
      internalPadding: styling.internalPadding,
      borderWidth: styling.borderWidth,
      radius: styling.radius,
      width: styling.width,
      height: styling.height,
      isMaterialized: styling.isMaterialized,
      elevation: styling.elevation,
      tooltip: tooltip,
      preferTooltipBelow: preferTooltipBelow,
      tooltipOffset: styling.tooltipOffset,
    );
  }
}

class OnTile extends StatelessWidget {
  final IconData iconData;
  final String? label;
  final ButtonStyling styling;
  final String? tooltip;
  final bool? preferTooltipBelow;

  const OnTile({
    Key? key,
    required this.iconData,
    required this.styling,
    this.label,
    this.tooltip,
    this.preferTooltipBelow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTile(
      iconData: iconData,
      label: label,
      foregroundColor: styling.backgroundColor,
      decorationColor: styling.accentColor,
      backgroundColor: styling.backgroundColor,
      buttonShape: styling.buttonShape,
      borderStyle: styling.borderStyle,
      borderRadius: styling.borderRadius,
      internalPadding: styling.internalPadding,
      borderWidth: styling.borderWidth,
      radius: styling.radius,
      width: styling.width,
      height: styling.height,
      isMaterialized: styling.isMaterialized,
      elevation: styling.elevation,
      tooltip: tooltip,
      preferTooltipBelow: preferTooltipBelow,
      tooltipOffset: styling.tooltipOffset,
    );
  }
}

class OffTile extends StatelessWidget {
  final IconData iconData;
  final String? label;
  final ButtonStyling styling;
  final String? tooltip;
  final bool? preferTooltipBelow;

  const OffTile({
    Key? key,
    required this.iconData,
    required this.styling,
    this.label,
    this.tooltip,
    this.preferTooltipBelow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTile(
      iconData: iconData,
      label: label,
      foregroundColor: styling.accentColor,
      decorationColor: styling.backgroundColor,
      backgroundColor: styling.backgroundColor,
      buttonShape: styling.buttonShape,
      borderStyle: styling.borderStyle,
      borderRadius: styling.borderRadius,
      internalPadding: styling.internalPadding,
      borderWidth: styling.borderWidth,
      radius: styling.radius,
      width: styling.width,
      height: styling.height,
      isMaterialized: styling.isMaterialized,
      elevation: styling.elevation,
      tooltip: tooltip,
      preferTooltipBelow: preferTooltipBelow,
      tooltipOffset: styling.tooltipOffset,
    );
  }
}

class DisabledTile extends StatelessWidget {
  final IconData iconData;
  final String? label;
  final ButtonStyling styling;
  final String? tooltip;
  final bool? preferTooltipBelow;

  const DisabledTile({
    Key? key,
    required this.iconData,
    required this.styling,
    this.label,
    this.tooltip,
    this.preferTooltipBelow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTile(
      iconData: iconData,
      label: label,
      foregroundColor: styling.disabledColor,
      decorationColor: styling.backgroundColor,
      backgroundColor: styling.backgroundColor,
      buttonShape: styling.buttonShape,
      borderStyle: styling.borderStyle,
      borderRadius: styling.borderRadius,
      internalPadding: styling.internalPadding,
      borderWidth: styling.borderWidth,
      radius: styling.radius,
      width: styling.width,
      height: styling.height,
      isMaterialized: styling.isMaterialized,
      elevation: styling.elevation,
      tooltip: tooltip,
      preferTooltipBelow: preferTooltipBelow,
      tooltipOffset: styling.tooltipOffset,
    );
  }
}
