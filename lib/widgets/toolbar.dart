import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:mdi/mdi.dart';

import 'controller.dart';

const int _kAnimationDuration = 500;
const double _kElevation = 4.0;
const double _kCollapsedDiameter = 56.0;
const double _kToolbarPadding = 4.0;
const double _kControlSpacing = 8.0;
const double _kDisabledOpacity = 0.67;
const double _kButtonDiameter = 48.0;

///Builder for [SectionControl]. Returns generic Widget so that so that control
///can be wrapped, for instance with feature discovery widget.
typedef NotifierBuilder = Widget Function(BuildContext, ValueNotifier<bool>);

/// Provides a scrollable toolbar of [SelectionControl] that allows one control
/// to be expanded at a time. Intended to be placed in a Stack above a [QuillEditor]
/// and probably within an [Align] for positioning.
class QuillToolbar extends StatefulWidget {
  final List<NotifierBuilder> notifierBuilderList;
  final double padding;
  final double spacing;
  final KeyboardHideButton? keyboardHideButton;

  const QuillToolbar({
    Key? key,
    required this.notifierBuilderList,
    this.padding = _kToolbarPadding,
    this.spacing = _kControlSpacing,
    this.keyboardHideButton,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuillToolbarState();
}

class _QuillToolbarState extends State<QuillToolbar> {
  int? _isExpanded;
  late final List<ValueNotifier<bool>> _notifierList = [];
  late final List<Widget> _children = [];

  @override
  void initState() {
    bool showHide = widget.keyboardHideButton != null;
    if (showHide) {
      _children.add(widget.keyboardHideButton!);
      _children.add(Padding(padding: EdgeInsets.only(right: widget.spacing)));
    }
    for (int i = 0; i < widget.notifierBuilderList.length; i++) {
      ValueNotifier<bool> notifier = ValueNotifier<bool>(true);
      notifier.addListener(() {
        if (!notifier.value) {
          _notifierListener(i);
        }
      });
      _notifierList.add(notifier);
      _children.add(widget.notifierBuilderList[i](context, notifier));
      if (i != widget.notifierBuilderList.length - 1) {
        _children.add(Padding(padding: EdgeInsets.only(right: widget.spacing)));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: IntrinsicHeight(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _children,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notifierList.forEach((notifier) => notifier.dispose());
    super.dispose();
  }

  void _notifierListener(int expandedIndex) {
    _isExpanded = expandedIndex;
    for (int i = 0; i < _notifierList.length; i++) {
      if (i != _isExpanded) {
        _notifierList[i].value = true;
      }
    }
  }
}

class StyleSectionControl extends SectionControl {
  StyleSectionControl({
    Key? key,
    required ValueNotifier<bool> notifier,
    required QuillController controller,
    IconData iconData = Mdi.informationVariant,
    double? elevation,
    Duration? duration,
    double? diameter,
    Color? background,
    Color? contrast,
  }) : super(
          iconData: iconData,
          isCollapsedNotifier: notifier,
          elevation: elevation,
          duration: duration,
          diameter: diameter,
          background: background,
          contrast: contrast,
          children: [
            AttributeToggleButton(
              attribute: Attribute.bold,
              icon: Icons.format_bold,
              controller: controller,
            ),
            AttributeToggleButton(
              attribute: Attribute.italic,
              icon: Icons.format_italic,
              controller: controller,
            ),
            AttributeToggleButton(
              attribute: Attribute.underline,
              icon: Icons.format_underline,
              controller: controller,
            ),
            AttributeToggleButton(
              attribute: Attribute.strikeThrough,
              icon: Icons.format_strikethrough,
              controller: controller,
            ),
            CollapsibleSizeButton(
              controller: controller,
            ),
          ],
        );
}

class SizeSectionControl extends SectionControl {
  SizeSectionControl({
    Key? key,
    required ValueNotifier<bool> notifier,
    required QuillController controller,
    IconData iconData = Icons.format_size_outlined,
    double? elevation,
    Duration? duration,
    double? diameter,
    Color? background,
    Color? contrast,
  }) : super(
          iconData: iconData,
          isCollapsedNotifier: notifier,
          elevation: elevation,
          duration: duration,
          diameter: diameter,
          background: background,
          contrast: contrast,
          children: [
            SizeButton(
              icon: Mdi.formatFontSizeIncrease,
              controller: controller,
              isIncrease: true,
            ),
            SizeButton(
              icon: Mdi.formatFontSizeDecrease,
              controller: controller,
              isIncrease: false,
            ),
          ],
        );
}

class IndentSectionControl extends SectionControl {
  IndentSectionControl({
    Key? key,
    required ValueNotifier<bool> notifier,
    required QuillController controller,
    IconData iconData = Icons.format_indent_increase,
    double? elevation,
    Duration? duration,
    double? diameter,
    Color? background,
    Color? contrast,
  }) : super(
          iconData: iconData,
          isCollapsedNotifier: notifier,
          elevation: elevation,
          duration: duration,
          diameter: diameter,
          background: background,
          contrast: contrast,
          children: [
            IndentButton(
              icon: Icons.arrow_back,
              controller: controller,
              isIncrease: false,
            ),
            IndentButton(
              icon: Icons.arrow_forward,
              controller: controller,
              isIncrease: true,
            ),
          ],
        );
}

class ListSectionControl extends SectionControl {
  ListSectionControl({
    Key? key,
    required ValueNotifier<bool> notifier,
    required QuillController controller,
    IconData iconData = Mdi.viewList,
    double? elevation,
    Duration? duration,
    double? diameter,
    Color? background,
    Color? contrast,
  }) : super(
          iconData: iconData,
          isCollapsedNotifier: notifier,
          elevation: elevation,
          duration: duration,
          diameter: diameter,
          background: background,
          contrast: contrast,
          children: [
            AttributeToggleButton(
              attribute: Attribute.ol,
              controller: controller,
              icon: Icons.format_list_numbered,
            ),
            AttributeToggleButton(
              attribute: Attribute.ul,
              controller: controller,
              icon: Icons.format_list_bulleted,
            ),
          ],
        );
}

class BlockSectionControl extends SectionControl {
  BlockSectionControl({
    Key? key,
    required ValueNotifier<bool> notifier,
    required QuillController controller,
    IconData iconData = Mdi.text, //Mdi.formatSection,
    double? elevation,
    Duration? duration,
    double? diameter,
    Color? background,
    Color? contrast,
  }) : super(
          iconData: iconData,
          isCollapsedNotifier: notifier,
          elevation: elevation,
          duration: duration,
          diameter: diameter,
          background: background,
          contrast: contrast,
          children: [
            LinkButton(
              controller: controller,
              icon: Icons.link,
            ),
            AttributeToggleButton(
              attribute: Attribute.blockQuote,
              controller: controller,
              icon: Icons.format_quote,
            ),
            AttributeToggleButton(
              attribute: Attribute.codeBlock,
              controller: controller,
              icon: Icons.code,
            ),
            CollapsibleIndentButton(controller: controller),
            ListExclusiveCollapsibleButton(
              controller: controller,
            )
          ],
        );
}

/// Organizes a list of buttons by expanding and collapsing and by using a
/// standard theme.
/// See also:
/// [StyleSectionControl] handles bold, italic, underline, strikethrough
/// [SizeSectionControl] handles text size changes
/// [IndentSectionControl] handles indentation changes
/// [ListSectionControl] handles bulleted and numbered lists
/// [BlockSectionControl] handles links, quote blocks, and code blocks
class SectionControl extends StatefulWidget {
  final IconData iconData;
  final ValueNotifier<bool> isCollapsedNotifier;
  final List<Widget> children;
  final double? elevation;
  final Duration? duration;
  final double? diameter;
  final Color? background;
  final Color? contrast;

  const SectionControl({
    Key? key,
    required this.iconData,
    required this.isCollapsedNotifier,
    required this.children,
    this.elevation,
    this.duration,
    this.diameter,
    this.background,
    this.contrast,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SectionControlState();
}

class SectionControlState extends State<SectionControl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandController;

  @override
  void initState() {
    _expandController = AnimationController(
      vsync: this,
      value: 0.0, //begin collapsed
      upperBound: 1.0,
      duration: widget.duration ?? Duration(milliseconds: _kAnimationDuration),
    );
    widget.isCollapsedNotifier.addListener(_collapseListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color background = widget.background ?? themeData.accentColor;
    Color contrast = widget.contrast ?? themeData.accentIconTheme.color!;
    return PhysicalShape(
      elevation: widget.elevation ?? _kElevation,
      color: background,
      clipper: ShapeBorderClipper(
        shape: StadiumBorder(),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                height: widget.diameter ?? _kCollapsedDiameter,
                width: widget.diameter ?? _kCollapsedDiameter,
                decoration: ShapeDecoration(shape: CircleBorder()),
                child: ValueListenableBuilder<bool>(
                  valueListenable: widget.isCollapsedNotifier,
                  builder: (context, value, child) {
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: ShapeDecoration(
                        shape: value
                            ? CircleBorder()
                            : CircleBorder(
                                side: BorderSide(color: contrast),
                              ),
                      ),
                      child: Icon(widget.iconData, color: contrast),
                    );
                  },
                ),
              ),
              onTap: () => widget.isCollapsedNotifier.value =
                  !widget.isCollapsedNotifier.value,
            ),
            SizeTransition(
              axis: Axis.horizontal,
              sizeFactor: _expandController,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.isCollapsedNotifier.removeListener(_collapseListener);
    _expandController.dispose();
    super.dispose();
  }

  void _collapseListener() {
    if (widget.isCollapsedNotifier.value) {
      _expandController.reverse();
    } else {
      _expandController.forward();
    }
  }
}

class CollapsibleButton extends StatefulWidget {
  final IconData iconData;
  final QuillController controller;
  final List<Widget> children;

  CollapsibleButton({
    Key? key,
    required this.iconData,
    required this.controller,
    required this.children,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CollapsibleButtonState();
}

class CollapsibleButtonState extends State<CollapsibleButton>
    with SingleTickerProviderStateMixin {
  bool _isCollapsed = true;
  late final AnimationController _expandController;

  @override
  void initState() {
    _expandController = AnimationController(
      vsync: this,
      value: 0.0, //begin collapsed
      upperBound: 1.0,
      duration: Duration(milliseconds: _kAnimationDuration),
    );
    widget.children.add(Padding(padding: EdgeInsets.only(right: 4.0)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color contrast = themeData.accentIconTheme.color!;
    return Container(
      margin: EdgeInsets.only(right: _isCollapsed ? 0.0 : 4.0),
      height: _kButtonDiameter,
      decoration: ShapeDecoration(
          shape: _isCollapsed
              ? StadiumBorder()
              : StadiumBorder(side: BorderSide(color: contrast))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(left: 8.0, right: 16.0),
              child: Icon(widget.iconData, color: contrast),
            ),
            onTap: () => setState(() {
              if (_expandController.isCompleted) {
                _expandController.reverse().then(
                    (value) => setState(() => _isCollapsed = !_isCollapsed));
              } else {
                _expandController.forward().then(
                    (value) => setState(() => _isCollapsed = !_isCollapsed));
              }
            }),
          ),
          SizeTransition(
            axis: Axis.horizontal,
            sizeFactor: _expandController,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }
}

class CollapsibleSizeButton extends CollapsibleButton {
  CollapsibleSizeButton({
    Key? key,
    required QuillController controller,
  }) : super(
          key: key,
          controller: controller,
          iconData: Icons.format_size_outlined,
          children: [
            SizeButton(
              icon: Mdi.formatFontSizeIncrease,
              controller: controller,
              isIncrease: true,
            ),
            SizeButton(
              icon: Mdi.formatFontSizeDecrease,
              controller: controller,
              isIncrease: false,
            ),
          ],
        );
}

class CollapsibleIndentButton extends CollapsibleButton {
  CollapsibleIndentButton({
    Key? key,
    required QuillController controller,
  }) : super(
          key: key,
          controller: controller,
          iconData: Icons.format_indent_increase,
          children: [
            IndentButton(
              icon: Icons.arrow_back,
              controller: controller,
              isIncrease: false,
            ),
            IndentButton(
              icon: Icons.arrow_forward,
              controller: controller,
              isIncrease: true,
            ),
          ],
        );
}

class CollapsibleListButton extends CollapsibleButton {
  CollapsibleListButton({
    Key? key,
    required QuillController controller,
  }) : super(
          key: key,
          controller: controller,
          iconData: Mdi.viewList,
          children: [
            AttributeToggleButton(
              attribute: Attribute.ol,
              controller: controller,
              icon: Icons.format_list_numbered,
            ),
            AttributeToggleButton(
              attribute: Attribute.ul,
              controller: controller,
              icon: Icons.format_list_bulleted,
            ),
          ],
        );
}

class LinkButton extends StatefulWidget {
  final QuillController controller;
  final IconData icon;
  final double? buttonDiameter;

  const LinkButton({
    Key? key,
    required this.controller,
    required this.icon,
    this.buttonDiameter = _kButtonDiameter,
  }) : super(key: key);

  @override
  _LinkButtonState createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeSelection);
  }

  @override
  void didUpdateWidget(covariant LinkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeSelection);
      widget.controller.addListener(_didChangeSelection);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_didChangeSelection);
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = !widget.controller.selection.isCollapsed;
    final VoidCallback? pressedHandler =
        isEnabled ? () => _openLinkDialog(context) : null;
    return SectionButton(
      iconData: widget.icon,
      onPressed: pressedHandler,
      buttonDiameter: widget.buttonDiameter,
    );
  }

  void _openLinkDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        return _LinkDialog();
      },
    ).then(_linkSubmitted);
  }

  void _linkSubmitted(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }
    widget.controller.formatSelection(LinkAttribute(value));
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

class ListExclusiveCollapsibleButton extends ExclusiveCollapsibleButton {
  ListExclusiveCollapsibleButton({
    Key? key,
    required QuillController controller,
  }) : super(
            iconData: Mdi.viewList,
            controller: controller,
            exclusiveAttributeGroup: ExclusiveAttributeGroup(
              notifierBuilderList: [
                (context, notifier) {
                  return AttributeToggleButton(
                    attribute: Attribute.ol,
                    controller: controller,
                    icon: Icons.format_list_numbered,
                    groupNotifier: notifier,
                  );
                },
                (context, notifier) {
                  return AttributeToggleButton(
                    attribute: Attribute.ul,
                    controller: controller,
                    icon: Icons.format_list_bulleted,
                    groupNotifier: notifier,
                  );
                },
              ],
            ));
}

class ExclusiveCollapsibleButton extends CollapsibleButton {
  ExclusiveCollapsibleButton({
    Key? key,
    required IconData iconData,
    required QuillController controller,
    required ExclusiveAttributeGroup exclusiveAttributeGroup,
  }) : super(
          iconData: iconData,
          controller: controller,
          children: [exclusiveAttributeGroup],
        );
}

class ExclusiveAttributeGroup extends StatefulWidget {
  final List<NotifierBuilder> notifierBuilderList;

  const ExclusiveAttributeGroup({
    Key? key,
    required this.notifierBuilderList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExclusiveAttributeGroupState();
}

class ExclusiveAttributeGroupState extends State<ExclusiveAttributeGroup> {
  int? _isOn;
  late final List<ValueNotifier<bool>> _notifierList = [];
  late final List<Widget> _children = [];

  @override
  void initState() {
    for (int i = 0; i < widget.notifierBuilderList.length; i++) {
      ValueNotifier<bool> notifier = ValueNotifier<bool>(false);
      notifier.addListener(() {
        if (notifier.value) {
          _notifyChildren(i);
        }
      });
      _notifierList.add(notifier);
      _children.add(widget.notifierBuilderList[i](context, notifier));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _children,
    );
  }

  @override
  void dispose() {
    _notifierList.forEach((notifier) => notifier.dispose());
    super.dispose();
  }

  void _notifyChildren(int isOnIndex) {
    _isOn = isOnIndex;
    for (int i = 0; i < _notifierList.length; i++) {
      if (i != _isOn) {
        _notifierList[i].value = false;
      }
    }
  }
}

/// Toggles an [Attribute] on or off based on either cursor location in document
/// or button-press.
/// See also:
/// [SectionToggleButton]
class AttributeToggleButton extends StatefulWidget {
  final Attribute attribute;
  final IconData icon;
  final QuillController controller;
  final double? buttonDiameter;
  final ValueNotifier<bool>? groupNotifier;

  AttributeToggleButton({
    Key? key,
    required this.attribute,
    required this.icon,
    required this.controller,
    this.buttonDiameter = _kButtonDiameter,
    this.groupNotifier,
  }) : super(key: key);

  @override
  _AttributeToggleButtonState createState() => _AttributeToggleButtonState();
}

class _AttributeToggleButtonState extends State<AttributeToggleButton> {
  late final ValueNotifier<bool> _isToggled = ValueNotifier(false);
  bool _isFormattingWhileTyping = false;
  int? _previousCursorPos;
  late bool _isInCodeBlock;
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    if (widget.groupNotifier != null) {
      widget.groupNotifier!.addListener(_groupListener);
      _isToggled.addListener(_toggleListener);
    }
    _isToggled.value =
        _isCursorInFormattedSelection() || _isFormattingWhileTyping;
    _disableIfInCodeBlock();
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  Widget build(BuildContext context) {
    return SectionToggleButton(
      iconData: widget.icon,
      valueListenable: _isToggled,
      buttonDiameter: widget.buttonDiameter,
      onChanged: _isEnabled ? _toggleAttribute : null,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    if (widget.groupNotifier != null) {
      widget.groupNotifier!.removeListener(_groupListener);
      _isToggled.removeListener(_toggleListener);
    }
    _isToggled.dispose();
    super.dispose();
  }

  void _groupListener() {
    if (!widget.groupNotifier!.value) {
      _toggleAttribute(false);
    }
  }

  void _toggleListener() {
    if (_isToggled.value) {
      widget.groupNotifier?.value = true;
    }
  }

  void _didChangeEditingValue() {
    setState(() {
      //Assume formatting while typing == toggle value
      _isFormattingWhileTyping = _isToggled.value;
      //Verify that selection is collapsed and cursor position change is no more
      // one than character
      _checkIfStillFormattingWhileTyping();
      //toggle value == true iff cursor is in toggled block or user is
      //formatting while typing
      _isToggled.value =
          _isCursorInFormattedSelection() || _isFormattingWhileTyping;
      //Disable formatting if in code block
      _disableIfInCodeBlock();
    });
  }

  void _checkIfStillFormattingWhileTyping() {
    int? currentPos = _collapsedCursorPos();
    if (currentPos != null && _previousCursorPos != currentPos) {
      if (_previousCursorPos == null) {
        _previousCursorPos = currentPos;
      } else {
        int diff = 0;
        if (currentPos < _previousCursorPos!) {
          diff = _previousCursorPos! - currentPos;
        } else {
          diff = currentPos - _previousCursorPos!;
        }
        //if moved more than one position then not typing
        if (diff > 1) {
          _isFormattingWhileTyping = false;
        } else if (_isFormattingWhileTyping) {
          _previousCursorPos = currentPos;
        }
      }
    }
  }

  void _disableIfInCodeBlock() {
    _isInCodeBlock = widget.controller
        .getSelectionStyle()
        .attributes
        .containsKey(Attribute.codeBlock.key);
    _isEnabled =
        !_isInCodeBlock || widget.attribute.key == Attribute.codeBlock.key;
  }

  int? _collapsedCursorPos() {
    if (!widget.controller.selection.isValid) {
      return null;
    }
    if (!widget.controller.selection.isCollapsed) {
      return null;
    }
    return widget.controller.selection.extentOffset;
  }

  bool _isCursorInFormattedSelection() {
    final attrs = widget.controller.getSelectionStyle().attributes;
    if (widget.attribute.key == Attribute.list.key) {
      Attribute? attribute = attrs[widget.attribute.key];
      if (attribute == null) {
        return false;
      }
      return attribute.value == widget.attribute.value;
    }
    return attrs.containsKey(widget.attribute.key);
  }

  _toggleAttribute(bool value) {
    setState(() {
      _isFormattingWhileTyping = value;
      _isToggled.value = value;
      widget.controller.formatSelection(
          value ? widget.attribute : Attribute.clone(widget.attribute, null));
    });
  }
}

class SizeButton extends StatefulWidget {
  final IconData icon;
  final QuillController controller;
  final bool isIncrease;
  final double? buttonDiameter;

  SizeButton({
    Key? key,
    required this.icon,
    required this.controller,
    required this.isIncrease,
    this.buttonDiameter = _kButtonDiameter,
  }) : super(key: key);

  @override
  _SizeButtonState createState() => _SizeButtonState();
}

class _SizeButtonState extends State<SizeButton> {
  late Attribute _value;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  @override
  void initState() {
    super.initState();
    _value =
        _selectionStyle.attributes[Attribute.header.key] ?? Attribute.header;
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  void didUpdateWidget(covariant SizeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _value =
          _selectionStyle.attributes[Attribute.header.key] ?? Attribute.header;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  void _didChangeEditingValue() {
    setState(() {
      _value =
          _selectionStyle.attributes[Attribute.header.key] ?? Attribute.header;
    });
  }

  Attribute? _incrementTextSize(Attribute attribute) {
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

  Attribute? _decrementTextSize(Attribute attribute) {
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

  VoidCallback? _onPressedHandler() {
    Attribute? newSize = widget.isIncrease
        ? _incrementTextSize(_value)
        : _decrementTextSize(_value);
    if (newSize == null) {
      return null;
    }
    return () {
      widget.controller.formatSelection(newSize);
    };
  }

  @override
  Widget build(BuildContext context) {
    return SectionButton(
      iconData: widget.isIncrease
          ? Mdi.formatFontSizeIncrease
          : Mdi.formatFontSizeDecrease,
      buttonDiameter: widget.buttonDiameter,
      onPressed: _onPressedHandler(),
    );
  }
}

class IndentButton extends StatefulWidget {
  final IconData icon;
  final QuillController controller;
  final bool isIncrease;
  final double? buttonDiameter;

  IndentButton({
    Key? key,
    required this.icon,
    required this.controller,
    required this.isIncrease,
    this.buttonDiameter,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => IndentButtonState();
}

class IndentButtonState extends State<IndentButton> {
  late Attribute? _value;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  @override
  void initState() {
    _value = _selectionStyle.attributes[Attribute.indent.key];
    widget.controller.addListener(_didChangeEditingValue);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant IndentButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _value = _selectionStyle.attributes[Attribute.indent.key];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool disable = _value == null && !widget.isIncrease;
    return SectionButton(
      iconData: widget.icon,
      buttonDiameter: widget.buttonDiameter,
      onPressed: disable
          ? null
          : () {
              if (_value == null) {
                if (widget.isIncrease) {
                  widget.controller.formatSelection(Attribute.indentL1);
                }
                return;
              }
              if (_value!.value == 1 && !widget.isIncrease) {
                widget.controller
                    .formatSelection(Attribute.clone(Attribute.indentL1, null));
                return;
              }
              if (widget.isIncrease) {
                widget.controller.formatSelection(
                    Attribute.getIndentLevel(_value!.value + 1));
                return;
              }
              widget.controller
                  .formatSelection(Attribute.getIndentLevel(_value!.value - 1));
            },
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  void _didChangeEditingValue() {
    setState(() {
      _value = _selectionStyle.attributes[Attribute.indent.key];
    });
  }
}

class KeyboardHideButton extends StatelessWidget {
  final VoidCallback onPressed;
  KeyboardHideButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      elevation: _kElevation,
      color: Theme.of(context).accentColor,
      clipper: ShapeBorderClipper(shape: CircleBorder()),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: _kButtonDiameter,
          width: _kButtonDiameter,
          child: Icon(
            Icons.keyboard_hide,
            color: Theme.of(context).accentIconTheme.color,
          ),
        ),
      ),
    );
  }
}

/// Provides an icon button that with a style consistent with [SectionControl]
/// See also:
/// [LinkButton]
/// [SizeButton]
/// [IndentButton]
class SectionButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;
  final double? buttonDiameter;

  const SectionButton({
    Key? key,
    required this.iconData,
    this.onPressed,
    this.buttonDiameter = _kButtonDiameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color _accentContrastColor = themeData.accentIconTheme.color!;
    Color _disabledColor = _accentContrastColor.withOpacity(_kDisabledOpacity);
    bool isDisabled = onPressed == null;
    return Center(
      child: GestureDetector(
        onTap: isDisabled ? null : () => onPressed!(),
        child: Container(
          height: buttonDiameter,
          width: buttonDiameter,
          margin: EdgeInsets.only(right: 8.0),
          decoration: ShapeDecoration(
            shape: CircleBorder(),
          ),
          child: Center(
            child: Icon(
              iconData,
              color: isDisabled ? _disabledColor : _accentContrastColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Provides an icon button that is toggled either by pressing or by location
/// within a document as determined by the [valueListenable]. Uses a style
/// consistent with [SectionControl]
/// See also:
/// [AttributeToggleButton]
class SectionToggleButton extends StatelessWidget {
  final ValueChanged<bool>? onChanged;
  final ValueListenable<bool> valueListenable;
  final IconData iconData;
  final double? buttonDiameter;

  const SectionToggleButton({
    Key? key,
    required this.onChanged,
    required this.valueListenable,
    required this.iconData,
    this.buttonDiameter = _kButtonDiameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color _accentColor = themeData.accentColor;
    Color _accentContrastColor = themeData.accentIconTheme.color!;
    Color _disabledColor = _accentContrastColor.withOpacity(_kDisabledOpacity);
    bool isDisabled = onChanged == null;
    return ValueListenableBuilder<bool>(
        valueListenable: valueListenable,
        builder: (context, value, child) {
          return Center(
            child: GestureDetector(
              onTap: isDisabled ? null : () => onChanged!(!value),
              child: Container(
                height: buttonDiameter,
                width: buttonDiameter,
                margin: EdgeInsets.only(right: 8.0),
                decoration: ShapeDecoration(
                  color: value ? _accentContrastColor : null,
                  shape: CircleBorder(),
                ),
                child: Center(
                  child: Icon(iconData,
                      color: isDisabled
                          ? _disabledColor
                          : value
                              ? _accentColor
                              : _accentContrastColor),
                ),
              ),
            ),
          );
        });
  }
}
