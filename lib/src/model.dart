class Meme {
  String url;
  DateTime timestamp;

  Meme(this.url, this.timestamp);

  Meme.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        timestamp = new DateTime.fromMillisecondsSinceEpoch(json['timestamp']);

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'timestamp': timestamp.toUtc().millisecondsSinceEpoch,
    };
  }
}
