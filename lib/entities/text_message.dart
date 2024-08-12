import 'message_data.dart';

class TextMessage extends MessageData {
  final String text;

  TextMessage({
    required super.uid,
    required this.text,
    required super.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'text': text,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory TextMessage.fromMap(Map<String, dynamic> map) {
    return TextMessage(
      uid: map['uid'] as String,
      text: map['text'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }
}
