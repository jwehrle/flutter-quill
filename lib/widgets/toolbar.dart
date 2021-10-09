import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/style.dart';
import 'package:mdi/mdi.dart';

import 'controller.dart';

const int _kMilliDuration = 500;

class LinkStyleButton extends StatefulWidget {
  final QuillController controller;
  final IconData icon;

  const LinkStyleButton({
    Key? key,
    required this.controller,
    required this.icon,
  }) : super(key: key);

  @override
  _LinkStyleButtonState createState() => _LinkStyleButtonState();
}

class _LinkStyleButtonState extends State<LinkStyleButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeSelection);
  }

  @override
  void didUpdateWidget(covariant LinkStyleButton oldWidget) {
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

class ToggleStyleButton extends StatefulWidget {
  final Attribute attribute;
  final IconData icon;
  final QuillController controller;

  ToggleStyleButton({
    Key? key,
    required this.attribute,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  @override
  _ToggleStyleButtonState createState() => _ToggleStyleButtonState();
}

class _ToggleStyleButtonState extends State<ToggleStyleButton> {
  late final ValueNotifier<bool> _isToggled = ValueNotifier(false);
  bool _isFormattingWhileTyping = false;
  int? _previousCursorPos;
  late bool _isInCodeBlock;
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
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
      onChanged: _isEnabled ? _toggleAttribute : null,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    _isToggled.dispose();
    super.dispose();
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

  SizeButton(
      {Key? key,
      required this.icon,
      required this.controller,
      required this.isIncrease})
      : super(key: key);

  @override
  SizeButtonState createState() => SizeButtonState();
}

class SizeButtonState extends State<SizeButton> {
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
      onPressed: _onPressedHandler(),
    );
  }
}

class IndentButton extends StatelessWidget {
  final IconData icon;
  final QuillController controller;
  final bool isIncrease;

  IndentButton(
      {Key? key,
      required this.icon,
      required this.controller,
      required this.isIncrease})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionButton(
      iconData: icon,
      onPressed: () {
        final indent =
            controller.getSelectionStyle().attributes[Attribute.indent.key];
        if (indent == null) {
          if (isIncrease) {
            controller.formatSelection(Attribute.indentL1);
          }
          return;
        }
        if (indent.value == 1 && !isIncrease) {
          controller.formatSelection(Attribute.clone(Attribute.indentL1, null));
          return;
        }
        if (isIncrease) {
          controller
              .formatSelection(Attribute.getIndentLevel(indent.value + 1));
          return;
        }
        controller.formatSelection(Attribute.getIndentLevel(indent.value - 1));
      },
    );
  }
}

class QuillToolbar extends StatefulWidget {
  final QuillController controller;
  final List<SectionControlBuilder> builderList;

  const QuillToolbar({
    Key? key,
    required this.controller,
    required this.builderList,
  }) : super(key: key);

  @override
  _QuillToolbarState createState() => _QuillToolbarState();
}

class _QuillToolbarState extends State<QuillToolbar> {
  double _opacity = 0.0;

  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    _opacity = keyboardVisibilityController.isVisible ? 1.0 : 0.0;
    keyboardVisibilityController.onChange.listen((bool visible) {
      _opacity = visible ? 1.0 : 0.0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: _kMilliDuration),
      opacity: _opacity,
      child: SectionControlledToolbar(
        builderList: widget.builderList,
      ),
    );
  }
}

typedef SectionControlBuilder = SectionControl Function(
    BuildContext, ValueNotifier<bool>);

class SectionControlledToolbar extends StatefulWidget {
  final List<SectionControlBuilder> builderList;

  const SectionControlledToolbar({
    Key? key,
    required this.builderList,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SectionControlledToolbarState();
}

class SectionControlledToolbarState extends State<SectionControlledToolbar> {
  int? _isExpanded;
  late final List<ValueNotifier<bool>> _notifierList = [];
  late final List<Widget> _children = [];

  @override
  void initState() {
    for (int i = 0; i < widget.builderList.length; i++) {
      ValueNotifier<bool> notifier = ValueNotifier<bool>(true);
      notifier.addListener(() {
        if (!notifier.value) {
          _notifierListener(i);
        }
      });
      _notifierList.add(notifier);
      _children.add(widget.builderList[i](context, notifier));
      if (i != widget.builderList.length - 1) {
        _children.add(Padding(padding: EdgeInsets.only(right: 4.0)));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
  final ValueNotifier<bool> notifier;
  final QuillController controller;

  StyleSectionControl({
    Key? key,
    required this.notifier,
    required this.controller,
  }) : super(
          iconData: Mdi.informationVariant,
          isCollapsedNotifier: notifier,
          children: [
            ToggleStyleButton(
              attribute: Attribute.bold,
              icon: Icons.format_bold,
              controller: controller,
            ),
            ToggleStyleButton(
              attribute: Attribute.italic,
              icon: Icons.format_italic,
              controller: controller,
            ),
            ToggleStyleButton(
              attribute: Attribute.underline,
              icon: Icons.format_underline,
              controller: controller,
            ),
            ToggleStyleButton(
              attribute: Attribute.strikeThrough,
              icon: Icons.format_strikethrough,
              controller: controller,
            ),
          ],
        );
}

class SizeSectionControl extends SectionControl {
  final ValueNotifier<bool> notifier;
  final QuillController controller;

  SizeSectionControl({
    Key? key,
    required this.notifier,
    required this.controller,
  }) : super(
          iconData: Icons.format_size_outlined,
          isCollapsedNotifier: notifier,
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
  final ValueNotifier<bool> notifier;
  final QuillController controller;

  IndentSectionControl({
    Key? key,
    required this.notifier,
    required this.controller,
  }) : super(
          iconData: Icons.format_indent_increase,
          isCollapsedNotifier: notifier,
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
  final ValueNotifier<bool> notifier;
  final QuillController controller;

  ListSectionControl({
    Key? key,
    required this.notifier,
    required this.controller,
  }) : super(
          iconData: Mdi.viewList,
          isCollapsedNotifier: notifier,
          children: [
            ToggleStyleButton(
              attribute: Attribute.ol,
              controller: controller,
              icon: Icons.format_list_numbered,
            ),
            ToggleStyleButton(
              attribute: Attribute.ul,
              controller: controller,
              icon: Icons.format_list_bulleted,
            ),
          ],
        );
}

class BlockSectionControl extends SectionControl {
  final ValueNotifier<bool> notifier;
  final QuillController controller;

  BlockSectionControl({
    Key? key,
    required this.notifier,
    required this.controller,
  }) : super(
          iconData: Mdi.formatSection,
          isCollapsedNotifier: notifier,
          children: [
            LinkStyleButton(
              controller: controller,
              icon: Icons.link,
            ),
            ToggleStyleButton(
              attribute: Attribute.blockQuote,
              controller: controller,
              icon: Icons.format_quote,
            ),
            ToggleStyleButton(
              attribute: Attribute.codeBlock,
              controller: controller,
              icon: Icons.code,
            ),
          ],
        );
}

class SectionControl extends StatefulWidget {
  final IconData iconData;
  final ValueNotifier<bool> isCollapsedNotifier;
  final List<Widget> children;

  const SectionControl({
    Key? key,
    required this.iconData,
    required this.isCollapsedNotifier,
    required this.children,
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
      duration: Duration(milliseconds: _kMilliDuration),
    );
    widget.isCollapsedNotifier.addListener(_collapseListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color accentContrast = themeData.accentIconTheme.color!;
    return PhysicalShape(
      elevation: 4.0,
      color: Theme.of(context).accentColor,
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
                height: 56.0,
                width: 56.0,
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
                                side: BorderSide(color: accentContrast),
                              ),
                      ),
                      child: Icon(widget.iconData, color: accentContrast),
                    );
                  },
                ),
              ),
              onTap: () {
                if (_expandController.isCompleted) {
                  widget.isCollapsedNotifier.value = true;
                } else {
                  widget.isCollapsedNotifier.value = false;
                }
              },
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

class SectionButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback? onPressed;

  const SectionButton({
    Key? key,
    required this.iconData,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color _accentContrastColor = themeData.accentIconTheme.color!;
    Color _disabledColor = _accentContrastColor.withOpacity(0.67);
    bool isDisabled = onPressed == null;
    return Center(
      child: GestureDetector(
        onTap: isDisabled ? null : () => onPressed!(),
        child: Container(
          height: 48.0,
          width: 48.0,
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

class SectionToggleButton extends StatelessWidget {
  final ValueChanged<bool>? onChanged;
  final ValueListenable<bool> valueListenable;
  final IconData iconData;

  const SectionToggleButton({
    Key? key,
    required this.onChanged,
    required this.valueListenable,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Color _accentColor = themeData.accentColor;
    Color _accentContrastColor = themeData.accentIconTheme.color!;
    Color _disabledColor = _accentContrastColor.withOpacity(0.67);
    bool isDisabled = onChanged == null;
    return ValueListenableBuilder<bool>(
        valueListenable: valueListenable,
        builder: (context, value, child) {
          return Center(
            child: GestureDetector(
              onTap: isDisabled ? null : () => onChanged!(!value),
              child: Container(
                height: 48.0,
                width: 48.0,
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
