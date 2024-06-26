import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_quill/models/documents/attribute.dart';
import 'package:flutter_quill/models/documents/nodes/embed.dart';
import 'package:flutter_quill/models/documents/style.dart';

import 'controller.dart';

double iconSize = 18.0;
double kToolbarHeight = iconSize * 2;

class InsertEmbedButton extends StatelessWidget {
  final QuillController controller;
  final IconData icon;

  const InsertEmbedButton({
    Key? key,
    required this.controller,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuillIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      icon: Icon(
        icon,
        size: iconSize,
        color: Theme.of(context).iconTheme.color,
      ),
      fillColor: Theme.of(context).canvasColor,
      onPressed: () {
        final index = controller.selection.baseOffset;
        final length = controller.selection.extentOffset - index;
        controller.replaceText(index, length, BlockEmbed.horizontalRule, null);
      },
    );
  }
}

class LinkStyleButton extends StatefulWidget {
  final QuillController controller;
  final IconData? icon;

  const LinkStyleButton({
    Key? key,
    required this.controller,
    this.icon,
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
    final theme = Theme.of(context);
    final isEnabled = !widget.controller.selection.isCollapsed;
    final VoidCallback? pressedHandler =
        isEnabled ? () => _openLinkDialog(context) : null;
    return QuillIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      icon: Icon(
        widget.icon ?? Icons.link,
        size: iconSize,
        color: isEnabled ? theme.iconTheme.color : theme.disabledColor,
      ),
      fillColor: Theme.of(context).canvasColor,
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

typedef ToggleStyleButtonBuilder = Widget Function(
  BuildContext context,
  Attribute attribute,
  IconData icon,
  bool isToggled,
  VoidCallback? onPressed,
);

class ToggleStyleButton extends StatefulWidget {
  final Attribute attribute;

  final IconData icon;

  final QuillController controller;

  final ToggleStyleButtonBuilder childBuilder;

  ToggleStyleButton({
    Key? key,
    required this.attribute,
    required this.icon,
    required this.controller,
    this.childBuilder = defaultToggleStyleButtonBuilder,
  }) : super(key: key);

  @override
  _ToggleStyleButtonState createState() => _ToggleStyleButtonState();
}

class _ToggleStyleButtonState extends State<ToggleStyleButton> {
  bool? _isToggled;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  void _didChangeEditingValue() {
    setState(() {
      _isToggled =
          _getIsToggled(widget.controller.getSelectionStyle().attributes);
    });
  }

  @override
  void initState() {
    super.initState();
    _isToggled = _getIsToggled(_selectionStyle.attributes);
    widget.controller.addListener(_didChangeEditingValue);
  }

  bool _getIsToggled(Map<String, Attribute> attrs) {
    if (widget.attribute.key == Attribute.list.key) {
      Attribute? attribute = attrs[widget.attribute.key];
      if (attribute == null) {
        return false;
      }
      return attribute.value == widget.attribute.value;
    }
    return attrs.containsKey(widget.attribute.key);
  }

  @override
  void didUpdateWidget(covariant ToggleStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _isToggled = _getIsToggled(_selectionStyle.attributes);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInCodeBlock =
        _selectionStyle.attributes.containsKey(Attribute.codeBlock.key);
    final isEnabled =
        !isInCodeBlock || widget.attribute.key == Attribute.codeBlock.key;
    return widget.childBuilder(context, widget.attribute, widget.icon,
        _isToggled!, isEnabled ? _toggleAttribute : null);
  }

  _toggleAttribute() {
    widget.controller.formatSelection(_isToggled!
        ? Attribute.clone(widget.attribute, null)
        : widget.attribute);
  }
}

class ToggleCheckListButton extends StatefulWidget {
  final IconData icon;

  final QuillController controller;

  final ToggleStyleButtonBuilder childBuilder;

  final Attribute attribute;

  ToggleCheckListButton({
    Key? key,
    required this.icon,
    required this.controller,
    this.childBuilder = defaultToggleStyleButtonBuilder,
    required this.attribute,
  }) : super(key: key);

  @override
  _ToggleCheckListButtonState createState() => _ToggleCheckListButtonState();
}

class _ToggleCheckListButtonState extends State<ToggleCheckListButton> {
  bool? _isToggled;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  void _didChangeEditingValue() {
    setState(() {
      _isToggled =
          _getIsToggled(widget.controller.getSelectionStyle().attributes);
    });
  }

  @override
  void initState() {
    super.initState();
    _isToggled = _getIsToggled(_selectionStyle.attributes);
    widget.controller.addListener(_didChangeEditingValue);
  }

  bool _getIsToggled(Map<String, Attribute> attrs) {
    if (widget.attribute.key == Attribute.list.key) {
      Attribute? attribute = attrs[widget.attribute.key];
      if (attribute == null) {
        return false;
      }
      return attribute.value == widget.attribute.value ||
          attribute.value == Attribute.checked.value;
    }
    return attrs.containsKey(widget.attribute.key);
  }

  @override
  void didUpdateWidget(covariant ToggleCheckListButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _isToggled = _getIsToggled(_selectionStyle.attributes);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInCodeBlock =
        _selectionStyle.attributes.containsKey(Attribute.codeBlock.key);
    final isEnabled =
        !isInCodeBlock || Attribute.list.key == Attribute.codeBlock.key;
    return widget.childBuilder(context, Attribute.unchecked, widget.icon,
        _isToggled!, isEnabled ? _toggleAttribute : null);
  }

  _toggleAttribute() {
    widget.controller.formatSelection(_isToggled!
        ? Attribute.clone(Attribute.unchecked, null)
        : Attribute.unchecked);
  }
}

Widget defaultToggleStyleButtonBuilder(
  BuildContext context,
  Attribute attribute,
  IconData icon,
  bool isToggled,
  VoidCallback? onPressed,
) {
  final theme = Theme.of(context);
  final isEnabled = onPressed != null;
  final iconColor = isEnabled
      ? isToggled
          ? theme.primaryIconTheme.color
          : theme.iconTheme.color
      : theme.disabledColor;
  final fillColor = isToggled ? theme.toggleableActiveColor : theme.canvasColor;
  return QuillIconButton(
    highlightElevation: 0,
    hoverElevation: 0,
    size: iconSize * 1.77,
    icon: Icon(icon, size: iconSize, color: iconColor),
    fillColor: fillColor,
    onPressed: onPressed,
  );
}

class SelectHeaderStyleButton extends StatefulWidget {
  final QuillController controller;

  const SelectHeaderStyleButton({Key? key, required this.controller})
      : super(key: key);

  @override
  _SelectHeaderStyleButtonState createState() =>
      _SelectHeaderStyleButtonState();
}

class _SelectHeaderStyleButtonState extends State<SelectHeaderStyleButton> {
  Attribute? _value;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  void _didChangeEditingValue() {
    setState(() {
      _value =
          _selectionStyle.attributes[Attribute.header.key] ?? Attribute.header;
    });
  }

  void _selectAttribute(value) {
    widget.controller.formatSelection(value);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _value =
          _selectionStyle.attributes[Attribute.header.key] ?? Attribute.header;
    });
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  void didUpdateWidget(covariant SelectHeaderStyleButton oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    return _selectHeadingStyleButtonBuilder(context, _value!, _selectAttribute);
  }
}

Widget _selectHeadingStyleButtonBuilder(
  BuildContext context,
  Attribute value,
  ValueChanged<Attribute> onSelected,
) {
  final Map<Attribute, String> _valueToText = {
    Attribute.header: 'Normal',
    Attribute.h1: 'Biggest',
    Attribute.h2: 'Bigger',
    Attribute.h3: 'Big',
  };

  return QuillOptionsButton(
    highlightElevation: 0,
    hoverElevation: 0,
    height: iconSize * 1.77,
    fillColor: Theme.of(context).canvasColor,
    initialOption: QuillToolbarOption(
        title: !kIsWeb
            ? _valueToText[value]!
            : _valueToText[value.key == "header"
                ? Attribute.header
                : (value.key == "h1")
                    ? Attribute.h1
                    : (value.key == "h2")
                        ? Attribute.h2
                        : Attribute.h3]!,
        value: value),
    description: 'Text: ',
    items: [
      QuillToolbarOption(
        title: _valueToText[Attribute.header]!,
        value: Attribute.header,
      ),
      QuillToolbarOption(
        title: _valueToText[Attribute.h3]!,
        value: Attribute.h3,
      ),
      QuillToolbarOption(
        title: _valueToText[Attribute.h2]!,
        value: Attribute.h2,
      ),
      QuillToolbarOption(
        title: _valueToText[Attribute.h1]!,
        value: Attribute.h1,
      ),
    ],
    onSelected: onSelected,
  );
}

// class ImageButton extends StatefulWidget {
//   final IconData icon;
//
//   final QuillController controller;
//
//   final OnImagePickCallback? onImagePickCallback;
//
//   //final ImagePickImpl? imagePickImpl;
//
//   // final ImageSource imageSource;
//
//   ImageButton(
//       {Key? key,
//       required this.icon,
//       required this.controller,
//       //required this.imageSource,
//       this.onImagePickCallback,
//       this.imagePickImpl})
//       : super(key: key);
//
//   @override
//   _ImageButtonState createState() => _ImageButtonState();
// }
//
// class _ImageButtonState extends State<ImageButton> {
//   List<PlatformFile>? _paths;
//   String? _extension;
//   final _picker = ImagePicker();
//   FileType _pickingType = FileType.any;
//
//   Future<String?> _pickImage(ImageSource imageSource) async {
//     final PickedFile? pickedFile = await _picker.getImage(source: imageSource);
//     if (pickedFile == null) return null;
//
//     final File? file = File(pickedFile.path);
//
//     if (file == null || widget.onImagePickCallback == null) return null;
//     // We simply return the absolute path to selected file.
//     try {
//       String? url = await widget.onImagePickCallback!(file);
//       print('Image uploaded and its url is $url');
//       return url;
//     } catch (error) {
//       print('Upload image error $error');
//     }
//     return null;
//   }
//
//   Future<String?> _pickImageWeb() async {
//     try {
//       _paths = (await FilePicker.platform.pickFiles(
//         type: _pickingType,
//         allowMultiple: false,
//         allowedExtensions: (_extension?.isNotEmpty ?? false)
//             ? _extension?.replaceAll(' ', '').split(',')
//             : null,
//       ))
//           ?.files;
//     } on PlatformException catch (e) {
//       print("Unsupported operation" + e.toString());
//     } catch (ex) {
//       print(ex);
//     }
//     var _fileName =
//         _paths != null ? _paths!.map((e) => e.name).toString() : '...';
//
//     if (_paths != null) {
//       File file = File(_fileName);
//       //The condition is never true because File constructor never gives null.
//       //if (file == null || widget.onImagePickCallback == null) return null;
//       // We simply return the absolute path to selected file.
//       try {
//         String? url = await widget.onImagePickCallback!(file);
//         print('Image uploaded and its url is $url');
//         return url;
//       } catch (error) {
//         print('Upload image error $error');
//       }
//       return null;
//     } else {
//       // User canceled the picker
//     }
//     return null;
//   }
//
//   Future<String?> _pickImageDesktop() async {
//     try {
//       var filePath = await FilesystemPicker.open(
//         context: context,
//         rootDirectory: await getApplicationDocumentsDirectory(),
//         fsType: FilesystemType.file,
//         fileTileSelectMode: FileTileSelectMode.wholeTile,
//       );
//       if (filePath == null || filePath.isEmpty) return null;
//
//       final File file = File(filePath);
//       String? url = await widget.onImagePickCallback!(file);
//       print('Image uploaded and its url is $url');
//       return url;
//     } catch (error) {
//       print('Upload image error $error');
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final iconColor = theme.iconTheme.color;
//     final fillColor = theme.canvasColor;
//     return QuillIconButton(
//       highlightElevation: 0,
//       hoverElevation: 0,
//       size: iconSize * 1.77,
//       icon: Icon(widget.icon, size: iconSize, color: iconColor),
//       fillColor: fillColor,
//       onPressed: () {
//         final index = widget.controller.selection.baseOffset;
//         final length = widget.controller.selection.extentOffset - index;
//         Future<String?> image;
//         if (widget.imagePickImpl != null) {
//           image = widget.imagePickImpl!(widget.imageSource);
//         } else {
//           if (kIsWeb) {
//             image = _pickImageWeb();
//           } else if (Platform.isAndroid || Platform.isIOS) {
//             image = _pickImage(widget.imageSource);
//           } else {
//             image = _pickImageDesktop();
//           }
//         }
//         image.then((imageUploadUrl) => {
//               if (imageUploadUrl != null)
//                 {
//                   widget.controller.replaceText(
//                       index, length, BlockEmbed.image(imageUploadUrl), null)
//                 }
//             });
//       },
//     );
//   }
// }

class HideKeyboardButton extends StatefulWidget {
  final FocusNode focusNode;

  HideKeyboardButton({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => HideKeyboardButtonState();
}

class HideKeyboardButtonState extends State<HideKeyboardButton> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_focusListener);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = _isEnabled ? theme.iconTheme.color : theme.disabledColor;
    final fillColor = theme.canvasColor;
    return QuillIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      icon: Icon(Icons.keyboard_hide, size: iconSize, color: iconColor),
      fillColor: fillColor,
      onPressed: _isEnabled ? _onHide : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode.removeListener(_focusListener);
  }

  void _onHide() {
    widget.focusNode.unfocus();
  }

  void _focusListener() {
    if (widget.focusNode.hasFocus) {
      setState(() {
        _isEnabled = true;
      });
    } else {
      setState(() {
        _isEnabled = false;
      });
    }
  }
}

/// Controls color styles.
///
/// When pressed, this button displays overlay toolbar with
/// buttons for each color.
// class ColorButton extends StatefulWidget {
//   final IconData icon;
//   final bool background;
//   final QuillController controller;
//
//   ColorButton(
//       {Key? key,
//       required this.icon,
//       required this.controller,
//       required this.background})
//       : super(key: key);
//
//   @override
//   _ColorButtonState createState() => _ColorButtonState();
// }
//
// class _ColorButtonState extends State<ColorButton> {
//   bool? _isToggledColor;
//   bool? _isToggledBackground;
//   bool? _isWhite;
//   bool? _isWhitebackground;
//
//   Style get _selectionStyle => widget.controller.getSelectionStyle();
//
//   void _didChangeEditingValue() {
//     setState(() {
//       _isToggledColor =
//           _getIsToggledColor(widget.controller.getSelectionStyle().attributes);
//       _isToggledBackground = _getIsToggledBackground(
//           widget.controller.getSelectionStyle().attributes);
//       _isWhite = _isToggledColor! &&
//           _selectionStyle.attributes["color"]!.value == '#ffffff';
//       _isWhitebackground = _isToggledBackground! &&
//           _selectionStyle.attributes["background"]!.value == '#ffffff';
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _isToggledColor = _getIsToggledColor(_selectionStyle.attributes);
//     _isToggledBackground = _getIsToggledBackground(_selectionStyle.attributes);
//     _isWhite = _isToggledColor! &&
//         _selectionStyle.attributes["color"]!.value == '#ffffff';
//     _isWhitebackground = _isToggledBackground! &&
//         _selectionStyle.attributes["background"]!.value == '#ffffff';
//     widget.controller.addListener(_didChangeEditingValue);
//   }
//
//   bool _getIsToggledColor(Map<String, Attribute> attrs) {
//     return attrs.containsKey(Attribute.color.key);
//   }
//
//   bool _getIsToggledBackground(Map<String, Attribute> attrs) {
//     return attrs.containsKey(Attribute.background.key);
//   }
//
//   @override
//   void didUpdateWidget(covariant ColorButton oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.controller != widget.controller) {
//       oldWidget.controller.removeListener(_didChangeEditingValue);
//       widget.controller.addListener(_didChangeEditingValue);
//       _isToggledColor = _getIsToggledColor(_selectionStyle.attributes);
//       _isToggledBackground =
//           _getIsToggledBackground(_selectionStyle.attributes);
//       _isWhite = _isToggledColor! &&
//           _selectionStyle.attributes["color"]!.value == '#ffffff';
//       _isWhitebackground = _isToggledBackground! &&
//           _selectionStyle.attributes["background"]!.value == '#ffffff';
//     }
//   }
//
//   @override
//   void dispose() {
//     widget.controller.removeListener(_didChangeEditingValue);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     Color iconColor = _isToggledColor! && !widget.background && !_isWhite!
//         ? stringToColor(_selectionStyle.attributes["color"]!.value)
//         : theme.iconTheme.color!;
//
//     Color iconColorBackground =
//         _isToggledBackground! && widget.background && !_isWhitebackground!
//             ? stringToColor(_selectionStyle.attributes["background"]!.value)
//             : theme.iconTheme.color!;
//
//     Color fillColor = _isToggledColor! && !widget.background && _isWhite!
//         ? stringToColor('#ffffff')
//         : theme.canvasColor;
//     Color fillColorBackground =
//         _isToggledBackground! && widget.background && _isWhitebackground!
//             ? stringToColor('#ffffff')
//             : theme.canvasColor;
//
//     return QuillIconButton(
//       highlightElevation: 0,
//       hoverElevation: 0,
//       size: iconSize * 1.77,
//       icon: Icon(widget.icon,
//           size: iconSize,
//           color: widget.background ? iconColorBackground : iconColor),
//       fillColor: widget.background ? fillColorBackground : fillColor,
//       onPressed: _showColorPicker,
//     );
//   }
//
//   void _changeColor(Color color) {
//     String hex = color.value.toRadixString(16);
//     if (hex.startsWith('ff')) {
//       hex = hex.substring(2);
//     }
//     hex = '#$hex';
//     widget.controller.formatSelection(
//         widget.background ? BackgroundAttribute(hex) : ColorAttribute(hex));
//     Navigator.of(context).pop();
//   }
//
//   _showColorPicker() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//           title: const Text('Select Color'),
//           backgroundColor: Theme.of(context).canvasColor,
//           content: SingleChildScrollView(
//             child: MaterialPicker(
//               pickerColor: Color(0),
//               onColorChanged: _changeColor,
//             ),
//           )),
//     );
//   }
// }

class HistoryButton extends StatefulWidget {
  final IconData icon;
  final bool undo;
  final QuillController controller;

  HistoryButton(
      {Key? key,
      required this.icon,
      required this.controller,
      required this.undo})
      : super(key: key);

  @override
  _HistoryButtonState createState() => _HistoryButtonState();
}

class _HistoryButtonState extends State<HistoryButton> {
  Color? _iconColor;
  ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    _setIconColor();

    final fillColor = theme!.canvasColor;
    widget.controller.changes.listen((event) async {
      _setIconColor();
    });
    return QuillIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      icon: Icon(widget.icon, size: iconSize, color: _iconColor),
      fillColor: fillColor,
      onPressed: _changeHistory,
    );
  }

  void _setIconColor() {
    if (!mounted) return;

    if (widget.undo) {
      setState(() {
        _iconColor = widget.controller.hasUndo
            ? theme!.iconTheme.color!
            : theme!.disabledColor;
      });
    } else {
      setState(() {
        _iconColor = widget.controller.hasRedo
            ? theme!.iconTheme.color!
            : theme!.disabledColor;
      });
    }
  }

  void _changeHistory() {
    if (widget.undo) {
      if (widget.controller.hasUndo) {
        widget.controller.undo();
      }
    } else {
      if (widget.controller.hasRedo) {
        widget.controller.redo();
      }
    }

    _setIconColor();
  }
}

class IndentButton extends StatefulWidget {
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
  _IndentButtonState createState() => _IndentButtonState();
}

class _IndentButtonState extends State<IndentButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.iconTheme.color;
    final fillColor = theme.canvasColor;
    return QuillIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      icon: Icon(widget.icon, size: iconSize, color: iconColor),
      fillColor: fillColor,
      onPressed: () {
        final indent = widget.controller
            .getSelectionStyle()
            .attributes[Attribute.indent.key];
        if (indent == null) {
          if (widget.isIncrease) {
            widget.controller.formatSelection(Attribute.indentL1);
          }
          return;
        }
        if (indent.value == 1 && !widget.isIncrease) {
          widget.controller
              .formatSelection(Attribute.clone(Attribute.indentL1, null));
          return;
        }
        if (widget.isIncrease) {
          widget.controller
              .formatSelection(Attribute.getIndentLevel(indent.value + 1));
          return;
        }
        widget.controller
            .formatSelection(Attribute.getIndentLevel(indent.value - 1));
      },
    );
  }
}

class ClearFormatButton extends StatefulWidget {
  final IconData icon;

  final QuillController controller;

  ClearFormatButton({Key? key, required this.icon, required this.controller})
      : super(key: key);

  @override
  _ClearFormatButtonState createState() => _ClearFormatButtonState();
}

class _ClearFormatButtonState extends State<ClearFormatButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.iconTheme.color;
    final fillColor = theme.canvasColor;
    return QuillIconButton(
        highlightElevation: 0,
        hoverElevation: 0,
        size: iconSize * 1.77,
        icon: Icon(widget.icon, size: iconSize, color: iconColor),
        fillColor: fillColor,
        onPressed: () {
          for (Attribute k
              in widget.controller.getSelectionStyle().attributes.values) {
            widget.controller.formatSelection(Attribute.clone(k, null));
          }
        });
  }
}

class QuillToolbar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget> children;

  const QuillToolbar({Key? key, required this.children}) : super(key: key);

  factory QuillToolbar.basic(
      {Key? key,
      required QuillController controller,
      required FocusNode focusNode,
      double toolbarIconSize = 18.0,
      bool showBoldButton = true,
      bool showItalicButton = true,
      bool showUnderLineButton = true,
      bool showStrikeThrough = true,
      bool showColorButton = true,
      bool showBackgroundColorButton = true,
      bool showClearFormat = true,
      bool showHeaderStyle = true,
      bool showListNumbers = true,
      bool showListBullets = true,
      bool showListCheck = true,
      bool showCodeBlock = true,
      bool showQuote = true,
      bool showIndent = true,
      bool showLink = true,
      bool showHistory = true,
      bool showHorizontalRule = false}) {
    iconSize = toolbarIconSize;
    return QuillToolbar(key: key, children: [
      HideKeyboardButton(
        focusNode: focusNode,
      ),
      Visibility(
        visible: showHistory,
        child: HistoryButton(
          icon: Icons.undo_outlined,
          controller: controller,
          undo: true,
        ),
      ),
      Visibility(
        visible: showHistory,
        child: HistoryButton(
          icon: Icons.redo_outlined,
          controller: controller,
          undo: false,
        ),
      ),
      SizedBox(width: 0.6),
      Visibility(
        visible: showBoldButton,
        child: ToggleStyleButton(
          attribute: Attribute.bold,
          icon: Icons.format_bold,
          controller: controller,
        ),
      ),
      SizedBox(width: 0.6),
      Visibility(
        visible: showItalicButton,
        child: ToggleStyleButton(
          attribute: Attribute.italic,
          icon: Icons.format_italic,
          controller: controller,
        ),
      ),
      SizedBox(width: 0.6),
      Visibility(
        visible: showUnderLineButton,
        child: ToggleStyleButton(
          attribute: Attribute.underline,
          icon: Icons.format_underline,
          controller: controller,
        ),
      ),
      SizedBox(width: 0.6),
      Visibility(
        visible: showStrikeThrough,
        child: ToggleStyleButton(
          attribute: Attribute.strikeThrough,
          icon: Icons.format_strikethrough,
          controller: controller,
        ),
      ),
      SizedBox(width: 0.6),
      Visibility(
        visible: showClearFormat,
        child: ClearFormatButton(
          icon: Icons.format_clear,
          controller: controller,
        ),
      ),
      Visibility(
          visible: showHeaderStyle,
          child: VerticalDivider(
              indent: 16, endIndent: 16, color: Colors.grey.shade400)),
      Visibility(
          visible: showHeaderStyle,
          child: SelectHeaderStyleButton(controller: controller)),
      VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
      Visibility(
        visible: showListNumbers,
        child: ToggleStyleButton(
          attribute: Attribute.ol,
          controller: controller,
          icon: Icons.format_list_numbered,
        ),
      ),
      Visibility(
        visible: showListBullets,
        child: ToggleStyleButton(
          attribute: Attribute.ul,
          controller: controller,
          icon: Icons.format_list_bulleted,
        ),
      ),
      Visibility(
        visible: showListCheck,
        child: ToggleCheckListButton(
          attribute: Attribute.unchecked,
          controller: controller,
          icon: Icons.check_box,
        ),
      ),
      Visibility(
        visible: showCodeBlock,
        child: ToggleStyleButton(
          attribute: Attribute.codeBlock,
          controller: controller,
          icon: Icons.code,
        ),
      ),
      Visibility(
          visible: !showListNumbers &&
              !showListBullets &&
              !showListCheck &&
              !showCodeBlock,
          child: VerticalDivider(
              indent: 16, endIndent: 16, color: Colors.grey.shade400)),
      Visibility(
        visible: showQuote,
        child: ToggleStyleButton(
          attribute: Attribute.blockQuote,
          controller: controller,
          icon: Icons.format_quote,
        ),
      ),
      Visibility(
        visible: showIndent,
        child: IndentButton(
          icon: Icons.format_indent_increase,
          controller: controller,
          isIncrease: true,
        ),
      ),
      Visibility(
        visible: showIndent,
        child: IndentButton(
          icon: Icons.format_indent_decrease,
          controller: controller,
          isIncrease: false,
        ),
      ),
      Visibility(
          visible: showQuote,
          child: VerticalDivider(
              indent: 16, endIndent: 16, color: Colors.grey.shade400)),
      Visibility(
          visible: showLink, child: LinkStyleButton(controller: controller)),
      Visibility(
        visible: showHorizontalRule,
        child: InsertEmbedButton(
          controller: controller,
          icon: Icons.horizontal_rule,
        ),
      ),
    ]);
  }

  @override
  _QuillToolbarState createState() => _QuillToolbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _QuillToolbarState extends State<QuillToolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      constraints: BoxConstraints.tightFor(height: widget.preferredSize.height),
      color: Theme.of(context).canvasColor,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }
}

class QuillIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  final double size;
  final Color? fillColor;
  final double hoverElevation;
  final double highlightElevation;

  const QuillIconButton({
    Key? key,
    required this.onPressed,
    this.icon,
    this.size = 40,
    this.fillColor,
    this.hoverElevation = 1,
    this.highlightElevation = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: size, height: size),
      child: RawMaterialButton(
        child: icon,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        padding: EdgeInsets.zero,
        fillColor: fillColor,
        elevation: 0,
        hoverElevation: hoverElevation,
        highlightElevation: hoverElevation,
        onPressed: onPressed,
      ),
    );
  }
}

class QuillOptionsButton extends StatefulWidget {
  final double height;
  final Color? fillColor;
  final double hoverElevation;
  final double highlightElevation;
  final QuillToolbarOption initialOption;
  final String description;
  final List<QuillToolbarOption> items;
  final ValueChanged<Attribute>? onSelected;

  const QuillOptionsButton({
    Key? key,
    this.height = 40,
    this.fillColor,
    this.hoverElevation = 1,
    this.highlightElevation = 1,
    required this.initialOption,
    required this.description,
    required this.items,
    required this.onSelected,
  }) : super(key: key);

  @override
  _QuillOptionsButtonState createState() => _QuillOptionsButtonState();
}

class _QuillOptionsButtonState extends State<QuillOptionsButton> {
  bool _showingMenu = false;
  Attribute? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialOption.value;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: widget.height),
      child: RawMaterialButton(
        child: _buildContent(context),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        padding: EdgeInsets.zero,
        fillColor: widget.fillColor,
        elevation: 0,
        hoverElevation: widget.hoverElevation,
        highlightElevation: widget.highlightElevation,
        onPressed: _showMenu,
      ),
    );
  }

  void _showMenu() {
    setState(() {
      _showingMenu = true;
    });
  }

  Widget _buildContent(BuildContext context) {
    return _showingMenu ? _options() : _selection();
  }

  Widget _selection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(widget.description),
          Text(widget.initialOption.title),
        ],
      ),
    );
  }

  Widget _options() {
    List<Widget> children = [Text(widget.description)];
    widget.items.forEach((QuillToolbarOption e) {
      children.add(GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: e.value == _selected!
              ? Text(
                  e.title,
                  style: TextStyle(fontStyle: FontStyle.italic),
                )
              : Text(e.title),
        ),
        onTap: () {
          if (widget.onSelected != null &&
              e.value != widget.initialOption.value) {
            widget.onSelected!(e.value);
          }
          setState(() {
            _showingMenu = false;
            _selected = e.value;
          });
        },
      ));
    });
    return Container(
      height: kToolbarHeight,
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class QuillToolbarOption {
  final String title;
  final Attribute value;

  QuillToolbarOption({required this.title, required this.value});
}
