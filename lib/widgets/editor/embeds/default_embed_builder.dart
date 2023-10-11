// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:tuple/tuple.dart';
//
// import 'package:flutter_quill/models/documents/attribute.dart';
// import 'package:flutter_quill/models/documents/nodes/embeddable.dart';
// import 'package:flutter_quill/models/documents/nodes/leaf.dart' as leaf;
// import 'package:flutter_quill/utils/platform.dart';
// import 'package:flutter_quill/utils/string.dart';
// import 'package:flutter_quill/controllers/controller.dart';
// import 'package:flutter_quill/widgets/editor/embeds/image.dart';
//
// Widget defaultEmbedBuilder(BuildContext context, QuillController controller,
//     leaf.Embed node, bool readOnly) {
//   assert(!kIsWeb, 'Please provide EmbedBuilder for Web');
//
//   Tuple2<double?, double?>? _widthHeight;
//   switch (node.value.type) {
//     case BlockEmbed.imageType:
//       final imageUrl = standardizeImageUrl(node.value.data);
//       var image;
//       final style = node.style.attributes['style'];
//       if (isMobile() && style != null) {
//         final _attrs = parseKeyValuePairs(style.value.toString(), {
//           Attribute.mobileWidth,
//           Attribute.mobileHeight,
//           Attribute.mobileMargin,
//           Attribute.mobileAlignment
//         });
//         if (_attrs.isNotEmpty) {
//           assert(
//               _attrs[Attribute.mobileWidth] != null &&
//                   _attrs[Attribute.mobileHeight] != null,
//               'mobileWidth and mobileHeight must be specified');
//           final w = double.parse(_attrs[Attribute.mobileWidth]!);
//           final h = double.parse(_attrs[Attribute.mobileHeight]!);
//           _widthHeight = Tuple2(w, h);
//           final m = _attrs[Attribute.mobileMargin] == null
//               ? 0.0
//               : double.parse(_attrs[Attribute.mobileMargin]!);
//           final a = getAlignment(_attrs[Attribute.mobileAlignment]);
//           image = Padding(
//               padding: EdgeInsets.all(m),
//               child: imageByUrl(imageUrl, width: w, height: h, alignment: a));
//         }
//       }
//
//       if (_widthHeight == null) {
//         image = imageByUrl(imageUrl);
//         if (image != null) {
//           _widthHeight = Tuple2((image as Image).width, image.height);
//         }
//       }
//       return image ?? Text('Image not found');
//     case BlockEmbed.videoType:
//     default:
//       throw UnimplementedError(
//         'Embeddable type "${node.value.type}" is not supported by default '
//         'embed builder of QuillEditor. You must pass your own builder function '
//         'to embedBuilder property of QuillEditor or QuillField widgets.',
//       );
//   }
// }
