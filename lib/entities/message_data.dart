import 'dart:convert';

import 'image_message.dart';
import 'text_message.dart';

abstract class MessageData extends Comparable<MessageData> {
  final String uid;
  final DateTime timestamp;

  MessageData({
    required this.uid,
    required this.timestamp,
  });

  @override
  int compareTo(MessageData other) {
    return other.timestamp.compareTo(timestamp);
  }

  factory MessageData.fromJson(String source) {
    final data = jsonDecode(source) as Map<String, dynamic>;
    if (data.containsKey('text')) return TextMessage.fromMap(data);
    if (data.containsKey('image_url')) return ImageMessage.fromMap(data);
    throw UnimplementedError();
  }
}
