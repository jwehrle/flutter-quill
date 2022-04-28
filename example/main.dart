import 'package:floating_toolbar/toolbar.dart';
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
    return Scaffold(
        body: Column(
      children: [
        RichTextToolbar(
          // toolbarType: RichTextToolbarType.expanded,
          isExpanded: true,
          controller: _controller,
          toolbarData: ToolbarData(
            alignment: ToolbarAlignment.bottomCenterHorizontal,
            backgroundColor: Colors.blue,
            buttonSize: Size(45.0, 40.0),
          ),
          toolbarButtonStyling: ButtonStyling(
            accentColor: Colors.deepPurpleAccent,
            backgroundColor: Colors.blue,
            disabledColor: Colors.grey,
          ),
          popupButtonStyling: ButtonStyling(
            accentColor: Colors.deepPurpleAccent,
            backgroundColor: Colors.blue,
            disabledColor: Colors.grey,
            buttonShape: ButtonShape.circle,
            radius: 20.0,
            isMaterialized: true,
            elevation: 2.0,
          ),
          // toolbarButtonData: ButtonData(
          //   accentColor: Colors.deepPurpleAccent,
          //   backgroundColor: Colors.blue,
          //   disabledColor: Colors.grey,
          //   buttonShape: ButtonShape.roundedRectangle,
          //   width: 45.0,
          //   height: 40.0,
          // ),
          // popupButtonData: ButtonData(
          //   accentColor: Colors.deepPurpleAccent,
          //   backgroundColor: Colors.blue,
          //   disabledColor: Colors.grey,
          //   buttonShape: ButtonShape.circle,
          //   radius: 40.0,
          //   isMaterialized: true,
          // ),
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
