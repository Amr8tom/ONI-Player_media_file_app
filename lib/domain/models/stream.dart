import 'dart:convert';

class StreamModel {
  final String name;
  final String url;
  Map<String, String> headers;

  StreamModel({
    required this.name,
    required this.url,
    required this.headers,
  });

  // TO MAP
  Map<String, dynamic> toMap() => {
        'name': name,
        'url': url,
        'headers': jsonEncode(headers),
      };

  // FROM MAP
  factory StreamModel.fromMap(Map<String, dynamic> map) {
    return StreamModel(
      name: map['name'],
      url: map['url'],
      headers: jsonDecode(map['headers']).cast<String, String>(),
    );
  }
}
