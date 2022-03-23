import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/floating/floating_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/floating/utilities/types.dart';

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

  @override
  State<StatefulWidget> createState() => PopupFlexState();
}

class PopupFlexState extends State<PopupFlex>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final FloatingToolbarState _toolbar;
  bool _showing = false;

  void _selectionListener() {
    if (_toolbar.selectionNotifier.value == null) {
      if (_showing) {
        _showing = false;
        _controller.reverse(from: 1.0);
      }
    } else {
      if (_toolbar.selectionNotifier.value == widget.itemKey) {
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: kThemeAnimationDuration,
    );
    _toolbar = FloatingToolbar.of(context);
    _toolbar.selectionNotifier.addListener(_selectionListener);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonData>(
      valueListenable: _toolbar.toolbarButtonDataNotifier,
      builder: (context, buttonData, _) {
        return ValueListenableBuilder<ToolbarData>(
          valueListenable: _toolbar.toolbarDataNotifier,
          builder: (context, toolbarData, _) {
            List<Widget> children = [];
            widget.buttons.forEach((option) {
              children.add(
                ScaleTransition(
                  scale: _controller.view,
                  child: option,
                ),
              );
            });
            double? width;
            double? height;
            Axis direction;
            switch (toolbarData.alignment) {
              case ToolbarAlignment.topLeft:
              case ToolbarAlignment.topCenter:
              case ToolbarAlignment.topRight:
              case ToolbarAlignment.bottomLeft:
              case ToolbarAlignment.bottomCenter:
              case ToolbarAlignment.bottomRight:
                width = buttonData.effectiveWidth;
                direction = Axis.vertical;
                break;
              case ToolbarAlignment.leftTop:
              case ToolbarAlignment.leftCenter:
              case ToolbarAlignment.leftBottom:
              case ToolbarAlignment.rightTop:
              case ToolbarAlignment.rightCenter:
              case ToolbarAlignment.rightBottom:
                height = buttonData.effectiveHeight;
                direction = Axis.horizontal;
                break;
            }
            return Container(
              key: ValueKey(widget.itemKey + '_options_container'),
              width: width,
              height: height,
              alignment: Alignment.center,
              child: Flex(
                direction: direction,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _toolbar.selectionNotifier.removeListener(_selectionListener);
    super.dispose();
  }
}