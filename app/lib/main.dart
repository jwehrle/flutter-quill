import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/controllers/controller.dart';
import 'package:flutter_quill/widgets/editor/editor.dart';
import 'package:flutter_quill/widgets/toolbar/toolbar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quill Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QuillController? _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadFromAssets();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadFromAssets() async {
    try {
      final result = await rootBundle.loadString('assets/sample_data.json');
      setState(() {
        _controller = QuillController.json(result);
      });
    } catch (error) {
      final doc = Document()..insert(0, 'Empty asset');
      setState(() {
        _controller = QuillController(
            document: doc, selection: TextSelection.collapsed(offset: 0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Scaffold(body: Center(child: Text('Loading...')));
    }
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Quill',
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Theme(
                data: ThemeData(
                    textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.deepOrangeAccent,
                  selectionColor: Colors.deepOrangeAccent.withOpacity(0.5),
                  selectionHandleColor: Colors.deepOrangeAccent,
                )),
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.deepOrange),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        QuillEditor.basic(
                          controller: _controller!,
                          readOnly: false,
                        ),
                        // toolbar spacing
                        Container(height: 72.0)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            RichTextToolbar(
              controller: _controller!,
              backgroundColor: theme.primaryColor,
              popupSpacing: 6.0,
              contentPadding: EdgeInsets.all(4.0),
              buttonSpacing: 4.0,
              toolbarPrimary: theme.primaryColor,
              toolbarOnPrimary: theme.colorScheme.onPrimary,
              toolbarOnSurface: theme.colorScheme.onSurface,
              buttonPadding: EdgeInsets.all(4.0),
            ),
          ],
        ),
      ),
    );
  }
}
