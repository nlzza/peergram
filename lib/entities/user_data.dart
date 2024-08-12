import 'package:firebase_auth/firebase_auth.dart' show User;

class UserData {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final String ipAddress;

  const UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.ipAddress,
  });

  UserData copyWith({
    String? uid,
    String? name,
    String? email,
    String? imageUrl,
    String? ipAddress,
  }) {
    return UserData(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'image_url': imageUrl,
      'ip_address': ipAddress,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      imageUrl: map['image_url'] as String,
      ipAddress: map['ip_address'] as String,
    );
  }

  factory UserData.fromFirebaseUser(User user) {
    return UserData(
      uid: user.uid,
      name: user.displayName!,
      email: user.email!,
      imageUrl: user.photoURL!,
      ipAddress: '',
    );
  }

  @override
  bool operator ==(covariant UserData other) {
    if (identical(this, other)) return true;
    return other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
