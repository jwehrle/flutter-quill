class InsertData {
  const InsertData({
    required this.isBlockQuote,
    required this.isCodeBlock,
    required this.isLink,
    required this.isImage,
  });

  final bool isBlockQuote;
  final bool isCodeBlock;
  final bool isLink;
  final bool isImage;


  bool get isBlock => isBlockQuote || isCodeBlock;

  @override
  String toString() {
    return 'InsertData(isBlockQuote: $isBlockQuote, isCodeBlock: $isCodeBlock, isLink: $isLink, isImage: $isImage)';
  }

  @override
  bool operator ==(covariant InsertData other) {
    if (identical(this, other)) return true;
    return 
      other.isBlockQuote == isBlockQuote &&
      other.isCodeBlock == isCodeBlock &&
      other.isLink == isLink &&
      other.isImage == isImage;
  }

  @override
  int get hashCode {
    return isBlockQuote.hashCode ^
      isCodeBlock.hashCode ^
      isLink.hashCode ^
      isImage.hashCode;
  }
}
