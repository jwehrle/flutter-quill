import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/popup_buttons/popup_action_button.dart';
import 'package:flutter_quill/widgets/toolbar/popup_buttons/popup_toggle_button.dart';
import 'package:flutter_quill/widgets/toolbar/rich_text_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/constants.dart';

class PopupFlex extends StatefulWidget {
  final String itemKey;
  final List<Widget> buttons;

  const PopupFlex({
    Key? key,
    required this.itemKey,
    required this.buttons,
  }) : super(key: key);

  PopupFlex.empty({
    Key? key,
    required this.itemKey,
  })  : this.buttons = [],
        super(key: key);

  PopupFlex.size({
    required QuillController controller,
  })  : this.itemKey = kSizeItemKey,
        this.buttons = [
          PopupActionButton(
            type: PopupActionType.sizePlus,
            controller: controller,
          ),
          PopupActionButton(
            type: PopupActionType.sizeMinus,
            controller: controller,
          )
        ],
        super(key: ValueKey(kSizeItemKey + '_popup'));

  PopupFlex.indent({
    required QuillController controller,
  })  : this.itemKey = kIndentItemKey,
        this.buttons = [
          PopupActionButton(
            type: PopupActionType.indentPlus,
            controller: controller,
          ),
          PopupActionButton(
            type: PopupActionType.indentMinus,
            controller: controller,
          )
        ],
        super(key: ValueKey(kIndentItemKey + '_popup'));

  PopupFlex.style({
    required QuillController controller,
  })  : this.itemKey = kStyleItemKey,
        this.buttons = [
          PopupToggleButton(
            type: ToggleType.bold,
            controller: controller,
          ),
          PopupToggleButton(
            type: ToggleType.italic,
            controller: controller,
          ),
          PopupToggleButton(
            type: ToggleType.under,
            controller: controller,
          ),
          PopupToggleButton(
            type: ToggleType.strike,
            controller: controller,
          ),
        ],
        super(key: ValueKey(kStyleItemKey + '_popup'));

  PopupFlex.block({
    required QuillController controller,
  })  : this.itemKey = kBlockItemKey,
        this.buttons = [
          PopupToggleButton(
            type: ToggleType.quote,
            controller: controller,
          ),
          PopupToggleButton(
            type: ToggleType.code,
            controller: controller,
          ),
        ],
        super(key: ValueKey(kBlockItemKey + '_popup'));

  PopupFlex.list({
    required QuillController controller,
  })  : this.itemKey = kListItemKey,
        this.buttons = [
          PopupToggleButton(
            type: ToggleType.number,
            controller: controller,
          ),
          PopupToggleButton(
            type: ToggleType.bullet,
            controller: controller,
          ),
        ],
        super(key: ValueKey(kListItemKey + '_popup'));

  PopupFlex.bold()
      : this.itemKey = kBoldItemKey,
        this.buttons = [],
        super(key: ValueKey(kBoldItemKey + '_popup'));

  PopupFlex.italic()
      : this.itemKey = kItalicItemKey,
        this.buttons = [],
        super(key: ValueKey(kItalicItemKey + '_popup'));

  PopupFlex.under()
      : this.itemKey = kUnderItemKey,
        this.buttons = [],
        super(key: ValueKey(kUnderItemKey + '_popup'));

  PopupFlex.strike()
      : this.itemKey = kStrikeItemKey,
        this.buttons = [],
        super(key: ValueKey(kStrikeItemKey + '_popup'));

  PopupFlex.quote()
      : this.itemKey = kQuoteItemKey,
        this.buttons = [],
        super(key: ValueKey(kQuoteItemKey + '_popup'));

  PopupFlex.code()
      : this.itemKey = kCodeItemKey,
        this.buttons = [],
        super(key: ValueKey(kCodeItemKey + '_popup'));

  PopupFlex.number()
      : this.itemKey = kNumberItemKey,
        this.buttons = [],
        super(key: ValueKey(kNumberItemKey + '_popup'));

  PopupFlex.bullet()
      : this.itemKey = kBulletItemKey,
        this.buttons = [],
        super(key: ValueKey(kBulletItemKey + '_popup'));

  @override
  State<StatefulWidget> createState() => PopupFlexState();
}

class PopupFlexState extends State<PopupFlex>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final ValueNotifier<String?> _selectionNotifier;
  late final ValueNotifier<ToolbarAlignment> _alignmentNotifier;
  bool _showing = false;
  late EdgeInsets _edgeInsets;
  double? _width;
  double? _height;
  late Axis _direction;

  void _selectionListener() {
    if (_selectionNotifier.value == null) {
      if (_showing) {
        _showing = false;
        _controller.reverse(from: 1.0);
      }
    } else {
      if (_selectionNotifier.value == widget.itemKey) {
        if (!_showing) {
          _showing = true;
          _controller.forward(from: 0.0);
        }
      } else {
        if (_showing) {
          _showing = false;
          _controller.reverse(from: 1.0);
        }
      }
    }
  }

  void _alignmentListener() =>
      setState(() => _assignLayout(_alignmentNotifier.value));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: kThemeAnimationDuration,
    );
    final toolbar = RichTextToolbar.of(context);
    _selectionNotifier = toolbar.selectionNotifier;
    _selectionNotifier.addListener(_selectionListener);
    _alignmentNotifier = toolbar.alignmentNotifier;
    _assignLayout(_alignmentNotifier.value);
    _alignmentNotifier.addListener(_alignmentListener);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    widget.buttons.forEach((option) {
      children.add(
        ScaleTransition(
          scale: _controller.view,
          child: option,
        ),
      );
    });
    return Padding(
      padding: _edgeInsets,
      child: Container(
        key: ValueKey(widget.itemKey + '_options_container'),
        width: _width,
        height: _height,
        alignment: Alignment.center,
        child: Flex(
          direction: _direction,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _selectionNotifier.removeListener(_selectionListener);
    _alignmentNotifier.removeListener(_alignmentListener);
    super.dispose();
  }

  void _assignLayout(ToolbarAlignment alignment) {
    switch (alignment) {
      case ToolbarAlignment.topLeft:
        _edgeInsets = EdgeInsets.only(top: 4.0);
        _width = kToolbarTileWidth;
        _direction = Axis.vertical;
        break;
      case ToolbarAlignment.topCenter:
        _edgeInsets = EdgeInsets.only(top: 4.0);
        _width = kToolbarTileWidth;
        _direction = Axis.vertical;
        break;
      case ToolbarAlignment.topRight:
        _edgeInsets = EdgeInsets.only(top: 4.0);
        _width = kToolbarTileWidth;
        _direction = Axis.vertical;
        break;
      case ToolbarAlignment.bottomLeft:
        _edgeInsets = EdgeInsets.only(bottom: 4.0);
        _width = kToolbarTileWidth;
        _direction = Axis.vertical;
        break;
      case ToolbarAlignment.bottomCenter:
        _edgeInsets = EdgeInsets.only(bottom: 4.0);
        _width = kToolbarTileWidth;
        _direction = Axis.vertical;
        break;
      case ToolbarAlignment.bottomRight:
        _edgeInsets = EdgeInsets.only(bottom: 4.0);
        _width = kToolbarTileWidth;
        _direction = Axis.vertical;
        break;
      case ToolbarAlignment.leftTop:
        _edgeInsets = EdgeInsets.only(left: 4.0);
        _height = kToolbarTileHeight;
        _direction = Axis.horizontal;
        break;
      case ToolbarAlignment.leftCenter:
        _edgeInsets = EdgeInsets.only(left: 4.0);
        _height = kToolbarTileHeight;
        _direction = Axis.horizontal;
        break;
      case ToolbarAlignment.leftBottom:
        _edgeInsets = EdgeInsets.only(left: 4.0);
        _height = kToolbarTileHeight;
        _direction = Axis.horizontal;
        break;
      case ToolbarAlignment.rightTop:
        _edgeInsets = EdgeInsets.only(right: 4.0);
        _height = kToolbarTileHeight;
        _direction = Axis.horizontal;
        break;
      case ToolbarAlignment.rightCenter:
        _edgeInsets = EdgeInsets.only(right: 4.0);
        _height = kToolbarTileHeight;
        _direction = Axis.horizontal;
        break;
      case ToolbarAlignment.rightBottom:
        _edgeInsets = EdgeInsets.only(right: 4.0);
        _height = kToolbarTileHeight;
        _direction = Axis.horizontal;
        break;
    }
  }
}
