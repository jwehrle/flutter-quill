import 'package:quiver/core.dart';

enum AttributeScope {
  INLINE, // refer to https://quilljs.com/docs/formats/#inline
  BLOCK, // refer to https://quilljs.com/docs/formats/#block
  EMBEDS, // refer to https://quilljs.com/docs/formats/#embeds
  IGNORE, // attributes that can be ignored
}

class Attribute<T> {
  final String? key;
  final AttributeScope? scope;
  final T? value;

  Attribute({this.key, this.scope, this.value});

  static final Map<String, Attribute> _registry = {
    Attribute.bold.key!: Attribute.bold,
    Attribute.italic.key!: Attribute.italic,
    Attribute.underline.key!: Attribute.underline,
    Attribute.strikeThrough.key!: Attribute.strikeThrough,
    Attribute.font.key!: Attribute.font,
    Attribute.size.key!: Attribute.size,
    Attribute.link.key!: Attribute.link,
    Attribute.color.key!: Attribute.color,
    Attribute.background.key!: Attribute.background,
    Attribute.placeholder.key!: Attribute.placeholder,
    Attribute.header.key!: Attribute.header,
    Attribute.indent.key!: Attribute.indent,
    Attribute.align.key!: Attribute.align,
    Attribute.list.key!: Attribute.list,
    Attribute.codeBlock.key!: Attribute.codeBlock,
    Attribute.blockQuote.key!: Attribute.blockQuote,
    Attribute.width.key!: Attribute.width,
    Attribute.height.key!: Attribute.height,
    Attribute.style.key!: Attribute.style,
    Attribute.token.key!: Attribute.token,
  };

  static final BoldAttribute bold = BoldAttribute();

  static final ItalicAttribute italic = ItalicAttribute();

  static final UnderlineAttribute underline = UnderlineAttribute();

  static final StrikeThroughAttribute strikeThrough = StrikeThroughAttribute();

  static final FontAttribute font = FontAttribute(null);

  static final SizeAttribute size = SizeAttribute(null);

  static final LinkAttribute link = LinkAttribute(null);

  static final ColorAttribute color = ColorAttribute(null);

  static final BackgroundAttribute background = BackgroundAttribute(null);

  static final PlaceholderAttribute placeholder = PlaceholderAttribute();

  static final HeaderAttribute header = HeaderAttribute();

  static final IndentAttribute indent = IndentAttribute();

  static final AlignAttribute align = AlignAttribute(null);

  static final ListAttribute list = ListAttribute(null);

  static final CodeBlockAttribute codeBlock = CodeBlockAttribute();

  static final BlockQuoteAttribute blockQuote = BlockQuoteAttribute();

  static final WidthAttribute width = WidthAttribute(null);

  static final HeightAttribute height = HeightAttribute(null);

  static final StyleAttribute style = StyleAttribute(null);

  static final TokenAttribute token = TokenAttribute(null);

  static final Set<String> inlineKeys = {
    Attribute.bold.key!,
    Attribute.italic.key!,
    Attribute.underline.key!,
    Attribute.strikeThrough.key!,
    Attribute.link.key!,
    Attribute.color.key!,
    Attribute.background.key!,
    Attribute.placeholder.key!,
  };

  static final Set<String> blockKeys = {
    Attribute.header.key!,
    Attribute.indent.key!,
    Attribute.align.key!,
    Attribute.list.key!,
    Attribute.codeBlock.key!,
    Attribute.blockQuote.key!,
  };

  static final Set<String> blockKeysExceptHeader = {
    Attribute.list.key!,
    Attribute.indent.key!,
    Attribute.align.key!,
    Attribute.codeBlock.key!,
    Attribute.blockQuote.key!,
  };

  static Attribute<int> get h1 => HeaderAttribute(level: 1);

  static Attribute<int> get h2 => HeaderAttribute(level: 2);

  static Attribute<int> get h3 => HeaderAttribute(level: 3);

  // "attributes":{"align":"left"}
  static Attribute<String> get leftAlignment => AlignAttribute('left');

  // "attributes":{"align":"center"}
  static Attribute<String> get centerAlignment => AlignAttribute('center');

  // "attributes":{"align":"right"}
  static Attribute<String> get rightAlignment => AlignAttribute('right');

  // "attributes":{"align":"justify"}
  static Attribute<String> get justifyAlignment => AlignAttribute('justify');

  // "attributes":{"list":"bullet"}
  static Attribute<String> get ul => ListAttribute('bullet');

  // "attributes":{"list":"ordered"}
  static Attribute<String> get ol => ListAttribute('ordered');

  // "attributes":{"list":"checked"}
  static Attribute<String> get checked => ListAttribute('checked');

  // "attributes":{"list":"unchecked"}
  static Attribute<String> get unchecked => ListAttribute('unchecked');

  // "attributes":{"indent":1"}
  static Attribute<int> get indentL1 => IndentAttribute(level: 1);

  // "attributes":{"indent":2"}
  static Attribute<int> get indentL2 => IndentAttribute(level: 2);

  // "attributes":{"indent":3"}
  static Attribute<int> get indentL3 => IndentAttribute(level: 3);

  static Attribute<int> getIndentLevel(int level) {
    if (level == 1) {
      return indentL1;
    }
    if (level == 2) {
      return indentL2;
    }
    return indentL3;
  }

  bool get isInline => scope == AttributeScope.INLINE;

  bool get isBlockExceptHeader => blockKeysExceptHeader.contains(key);

  Map<String, dynamic> toJson() => <String, dynamic>{key!: value};

  static Attribute fromKeyValue(String key, dynamic value) {
    if (!_registry.containsKey(key)) {
      throw ArgumentError.value(key, 'key "$key" not found.');
    }
    Attribute origin = _registry[key]!;
    Attribute attribute = clone(origin, value);
    return attribute;
  }

  static Attribute clone(Attribute origin, dynamic value) {
    return Attribute(key: origin.key, scope: origin.scope, value: value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Attribute<T>) return false;
    Attribute<T> typedOther = other;
    return key == typedOther.key &&
        scope == typedOther.scope &&
        value == typedOther.value;
  }

  @override
  int get hashCode => hash3(key, scope, value);

  @override
  String toString() {
    return 'Attribute{key: $key, scope: $scope, value: $value}';
  }
}

class BoldAttribute extends Attribute<bool> {
  BoldAttribute()
      : super(key: 'bold', scope: AttributeScope.INLINE, value: true);
}

class ItalicAttribute extends Attribute<bool> {
  ItalicAttribute()
      : super(key: 'italic', scope: AttributeScope.INLINE, value: true);
}

class UnderlineAttribute extends Attribute<bool> {
  UnderlineAttribute()
      : super(key: 'underline', scope: AttributeScope.INLINE, value: true);
}

class StrikeThroughAttribute extends Attribute<bool> {
  StrikeThroughAttribute()
      : super(key: 'strike', scope: AttributeScope.INLINE, value: true);
}

class FontAttribute extends Attribute<String> {
  FontAttribute(String? val)
      : super(key: 'font', scope: AttributeScope.INLINE, value: val);
}

class SizeAttribute extends Attribute<String> {
  SizeAttribute(String? val)
      : super(key: 'size', scope: AttributeScope.INLINE, value: val);
}

class LinkAttribute extends Attribute<String> {
  LinkAttribute(String? val)
      : super(key: 'link', scope: AttributeScope.INLINE, value: val);
}

class ColorAttribute extends Attribute<String> {
  ColorAttribute(String? val)
      : super(key: 'color', scope: AttributeScope.INLINE, value: val);
}

class BackgroundAttribute extends Attribute<String> {
  BackgroundAttribute(String? val)
      : super(key: 'background', scope: AttributeScope.INLINE, value: val);
}

/// This is custom attribute for hint
class PlaceholderAttribute extends Attribute<bool> {
  PlaceholderAttribute()
      : super(key: 'placeholder', scope: AttributeScope.INLINE, value: true);
}

class HeaderAttribute extends Attribute<int> {
  HeaderAttribute({int? level})
      : super(key: 'header', scope: AttributeScope.BLOCK, value: level);
}

class IndentAttribute extends Attribute<int> {
  IndentAttribute({int? level})
      : super(key: 'indent', scope: AttributeScope.BLOCK, value: level);
}

class AlignAttribute extends Attribute<String> {
  AlignAttribute(String? val)
      : super(key: 'align', scope: AttributeScope.BLOCK, value: val);
}

class ListAttribute extends Attribute<String> {
  ListAttribute(String? val)
      : super(key: 'list', scope: AttributeScope.BLOCK, value: val);
}

class CodeBlockAttribute extends Attribute<bool> {
  CodeBlockAttribute()
      : super(key: 'code-block', scope: AttributeScope.BLOCK, value: true);
}

class BlockQuoteAttribute extends Attribute<bool> {
  BlockQuoteAttribute()
      : super(key: 'blockquote', scope: AttributeScope.BLOCK, value: true);
}

class WidthAttribute extends Attribute<String> {
  WidthAttribute(String? val)
      : super(key: 'width', scope: AttributeScope.IGNORE, value: val);
}

class HeightAttribute extends Attribute<String> {
  HeightAttribute(String? val)
      : super(key: 'height', scope: AttributeScope.IGNORE, value: val);
}

class StyleAttribute extends Attribute<String> {
  StyleAttribute(String? val)
      : super(key: 'style', scope: AttributeScope.IGNORE, value: val);
}

class TokenAttribute extends Attribute<String> {
  TokenAttribute(String? val)
      : super(key: 'token', scope: AttributeScope.IGNORE, value: val);
}
