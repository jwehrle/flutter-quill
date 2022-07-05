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
              child: QuillEditor.basic(
                controller: _controller!,
                readOnly: false,
              ),
            ),
            RichTextToolbar(
              controller: _controller!,
              alignment: ToolbarAlignment.bottomCenterHorizontal,
              backgroundColor: theme.primaryColor,
              popupSpacing: 6.0,
              popupStyle: selectableStyleFrom(
                shape: CircleBorder(),
                elevation: 4.0,
                padding: EdgeInsets.all(8.0),
                primary: theme.primaryColor,
                onPrimary: theme.colorScheme.onPrimary,
                onSurface: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
