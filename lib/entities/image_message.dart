import 'message_data.dart';

class ImageMessage extends MessageData {
  final String imageUrl;

  ImageMessage({
    required super.uid,
    required this.imageUrl,
    required super.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'image_url': imageUrl,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ImageMessage.fromMap(Map<String, dynamic> map) {
    return ImageMessage(
      uid: map['uid'] as String,
      imageUrl: map['image_url'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }
}
