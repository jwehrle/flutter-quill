import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/toolbar/rich_text_toolbar.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/operations.dart';
import 'package:flutter_quill/widgets/toolbar/utilities/types.dart';

class PositionedFollower extends StatefulWidget {
  final int index;
  final Widget child;

  const PositionedFollower({
    Key? key,
    required this.index,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PositionedFollowerState();
}

class PositionedFollowerState extends State<PositionedFollower> {
  late RichTextToolbarState _toolbar;
  late ToolbarAlignment _alignment;
  late ToolbarType _type;

  void _alignmentListener() =>
      setState(() => _alignment = _toolbar.alignmentNotifier.value);
  void _typeListener() =>
      setState(() => _type = _toolbar.toolbarTypeNotifier.value);

  @override
  void initState() {
    _toolbar = RichTextToolbar.of(context);
    _alignment = _toolbar.alignmentNotifier.value;
    _toolbar.alignmentNotifier.addListener(_alignmentListener);
    _type = _toolbar.toolbarTypeNotifier.value;
    _toolbar.toolbarTypeNotifier.addListener(_typeListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _toolbar.toolbarOffsetNotifier,
      builder: (context, value, _) {
        final PositionParameters pos = itemPosition(
          index: widget.index,
          toolbarOffset: value,
          alignment: _alignment,
          type: _type,
        );
        return Positioned(
          top: pos.top,
          left: pos.left,
          right: pos.right,
          bottom: pos.bottom,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _toolbar.alignmentNotifier.removeListener(_alignmentListener);
    _toolbar.toolbarTypeNotifier.removeListener(_typeListener);
    super.dispose();
  }
}
