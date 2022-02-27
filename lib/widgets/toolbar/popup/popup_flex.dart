import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar/popup/option_button.dart';
import 'package:flutter_quill/widgets/toolbar/popup/popup_button.dart';
import 'package:flutter_quill/widgets/toolbar/popup/popup_toggle.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/toggle_button.dart';
import 'package:flutter_quill/widgets/toolbar/buttons/toolbar_tile.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar_utilities.dart';

class PopupFlex extends StatefulWidget {
  final String itemKey;
  final List<Widget> options;

  const PopupFlex({
    Key? key,
    required this.itemKey,
    required this.options,
  }) : super(key: key);

  PopupFlex.empty({
    Key? key,
    required this.itemKey,
  })  : this.options = [],
        super(key: key);

  PopupFlex.size({
    required QuillController controller,
  })  : this.itemKey = kSizeItemKey,
        this.options = [
          OptionButton(
            type: OptionType.sizePlus,
            controller: controller,
          ),
          OptionButton(
            type: OptionType.sizeMinus,
            controller: controller,
          )
        ],
        super(key: ValueKey(kSizeItemKey + '_popup'));

  PopupFlex.indent({
    required QuillController controller,
  })  : this.itemKey = kIndentItemKey,
        this.options = [
          OptionButton(
            type: OptionType.indentPlus,
            controller: controller,
          ),
          OptionButton(
            type: OptionType.indentMinus,
            controller: controller,
          )
        ],
        super(key: ValueKey(kIndentItemKey + '_popup'));

  PopupFlex.style({
    required QuillController controller,
  })  : this.itemKey = kStyleItemKey,
        this.options = [
          PopupToggle(
            type: PopupToggleType.bold,
            controller: controller,
          ),
          PopupToggle(
            type: PopupToggleType.italic,
            controller: controller,
          ),
          PopupToggle(
            type: PopupToggleType.under,
            controller: controller,
          ),
          PopupToggle(
            type: PopupToggleType.strike,
            controller: controller,
          ),
        ],
        super(key: ValueKey(kStyleItemKey + '_popup'));

  PopupFlex.block({
    required QuillController controller,
  })  : this.itemKey = kBlockItemKey,
        this.options = [
          PopupToggle(
            type: PopupToggleType.quote,
            controller: controller,
          ),
          PopupToggle(
            type: PopupToggleType.code,
            controller: controller,
          ),
        ],
        super(key: ValueKey(kBlockItemKey + '_popup'));

  PopupFlex.list({
    required QuillController controller,
  })  : this.itemKey = kListItemKey,
        this.options = [
          PopupToggle(
            type: PopupToggleType.number,
            controller: controller,
          ),
          PopupToggle(
            type: PopupToggleType.bullet,
            controller: controller,
          ),
        ],
        super(key: ValueKey(kListItemKey + '_popup'));

  PopupFlex.bold()
      : this.itemKey = kBoldItemKey,
        this.options = [],
        super(key: ValueKey(kBoldItemKey + '_popup'));

  PopupFlex.italic()
      : this.itemKey = kItalicItemKey,
        this.options = [],
        super(key: ValueKey(kItalicItemKey + '_popup'));

  PopupFlex.under()
      : this.itemKey = kUnderItemKey,
        this.options = [],
        super(key: ValueKey(kUnderItemKey + '_popup'));

  PopupFlex.strike()
      : this.itemKey = kStrikeItemKey,
        this.options = [],
        super(key: ValueKey(kStrikeItemKey + '_popup'));

  PopupFlex.quote()
      : this.itemKey = kQuoteItemKey,
        this.options = [],
        super(key: ValueKey(kQuoteItemKey + '_popup'));

  PopupFlex.code()
      : this.itemKey = kCodeItemKey,
        this.options = [],
        super(key: ValueKey(kCodeItemKey + '_popup'));

  PopupFlex.number()
      : this.itemKey = kNumberItemKey,
        this.options = [],
        super(key: ValueKey(kNumberItemKey + '_popup'));

  PopupFlex.bullet()
      : this.itemKey = kBulletItemKey,
        this.options = [],
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
    final toolbar = Toolbar.of(context);
    _selectionNotifier = toolbar.selectionNotifier;
    _selectionNotifier.addListener(_selectionListener);
    _alignmentNotifier = toolbar.alignmentNotifier;
    _assignLayout(_alignmentNotifier.value);
    _alignmentNotifier.addListener(_alignmentListener);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    widget.options.forEach((option) {
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
