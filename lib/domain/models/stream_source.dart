import 'dart:convert';

class StreamSource {
  final Map<String, String> headers;
  final String url;
  String poster;
  String name;
  StreamSource({
    required this.headers,
    required this.url,
    this.poster = "",
    this.name = "Stream",
  });

  // jsonifiy
  Map<String, dynamic> toJson() {
    return {
      "headers": headers,
      "url": url,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory StreamSource.fromJsonString(String jsonStr) {
    var json = jsonDecode(jsonStr);
    return StreamSource(
      headers: json['headers'].cast<String, String>(),
      url: json['url'] as String,
    );
    //   }
  }

  factory StreamSource.fromJson(Map<String, dynamic> json) {
    return StreamSource(
      headers: json["headers"],
      url: json["url"],
    );
  }

  // empty
  static StreamSource empty() {
    return StreamSource(
      headers: {},
      url: "",
    );
  }

  // override toString
  @override
  String toString() {
    return 'StreamSource(headers: $headers, url: $url)';
  }
}
