class Embeddable {
  final String type;
  final dynamic data;

  Embeddable({required this.type, required this.data});

  Map<String, dynamic> toJson() {
    Map<String, String> m = {type: data.toString()};
    return m;
  }

  static Embeddable fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> m = Map<String, dynamic>.from(json);
    assert(m.length == 1, 'Embeddable map has one key');

    return BlockEmbed(type: m.keys.first, data: m.values.first);
  }
}

class BlockEmbed extends Embeddable {
  BlockEmbed({required String type, required String data})
      : super(type: type, data: data);

  static final BlockEmbed horizontalRule =
      BlockEmbed(type: 'divider', data: 'hr');

  static BlockEmbed image(String imageUrl) =>
      BlockEmbed(type: 'image', data: imageUrl);
}
