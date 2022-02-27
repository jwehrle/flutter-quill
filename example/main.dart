import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar/sliding/sliding_toolbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QuillController _controller = QuillController.basic();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SlidingToolbar(
          // controller: _controller,
          notifierBuilderList: [
            (context, notifier) {
              return StyleSectionControl(
                notifier: notifier,
                controller: _controller,
              );
            },
            (context, notifier) {
              return BlockSectionControl(
                notifier: notifier,
                controller: _controller,
              );
            }
          ],
        ),
        Expanded(
          child: Container(
            child: QuillEditor.basic(
              controller: _controller,
              readOnly: false, // change to true to be view only mode
            ),
          ),
        )
      ],
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
