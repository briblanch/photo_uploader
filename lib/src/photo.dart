import 'package:intl/intl.dart';

class Photo {
  final DateFormat dateFormatter = new DateFormat('MMMM dd HH:mm');

  final String url;
  final String title;
  final String description;
  final DateTime timestamp;

  Photo(this.url, this.title, this.description, this.timestamp);

  Photo.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        title = json['title'],
        description = json['description'],
        timestamp = new DateTime.fromMillisecondsSinceEpoch(json['timestamp']);

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'description': description,
      'timestamp': timestamp.toUtc().millisecondsSinceEpoch,
    };
  }

  String get displayDateString => dateFormatter.format(timestamp.toLocal());
}
