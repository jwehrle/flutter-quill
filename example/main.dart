import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QuillController _controller = QuillController.basic();
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        body: Column(
      children: [
        RichTextToolbar(
          controller: _controller,
          alignment: ToolbarAlignment.bottomCenterHorizontal,
          backgroundColor: theme.primaryColor,
          popupStyle: selectableStyleFrom(
            shape: CircleBorder(),
            elevation: 4.0,
            primary: theme.primaryColor,
            onPrimary: theme.colorScheme.onPrimary,
            onSurface: theme.colorScheme.onSurface,
          ),
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
