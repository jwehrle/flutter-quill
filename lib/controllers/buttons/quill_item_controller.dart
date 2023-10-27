import 'package:flutter/foundation.dart';
import 'package:flutter_quill/controllers/controller.dart';

/// Abstract class that facilitates listening to QuillController, filtering
/// for relevant quality, and propagating those changes to onChanged
/// Used by [QuillItem] to set [ButtonState].
abstract class QuillItemController<T> {

  /// Creates an Item Controller that listens to [QuillController]
  QuillItemController(this.controller) {
    controller.addListener(controllerListener);
  }

  /// Local reference to [QuillController]
  final QuillController controller;

  /// The current [T] of the current selection 
  T get data;

  /// Called when [data] changes
  void onChanged(T data);

  /// [QuillController] listener callback
  void controllerListener() => onChanged(data);

  /// Removes listener from [controller]
  @mustCallSuper
  void dispose() {
    controller.removeListener(controllerListener);
  }
}