import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/user_data.dart';

class UserRepo {
  static final instance = UserRepo._();
  UserRepo._();

  final usersDb = FirebaseFirestore.instance
      .collection('users') //
      .withConverter(
        fromFirestore: (doc, _) => UserData.fromMap(doc.data()!),
        toFirestore: (user, _) => user.toMap(),
      );

  final friendsDb = FirebaseFirestore.instance //
      .collection('friends');

  Future<UserData> addUserIfNew(UserData user) async {
    final doc = usersDb.doc(user.uid);
    final docData = await doc.get();
    if (docData.exists == false) {
      await doc.set(user);
      await friendsDb.doc(user.uid).set({});
      return user;
    } else {
      return docData.data()!;
    }
  }

  Future<UserData> getUser(String userId) async {
    final doc = await usersDb.doc(userId).get();
    return doc.data()!;
  }

  Future<void> updateIdAddress(String userId, String ipAddress) {
    return usersDb.doc(userId).update({'ip_address': ipAddress});
  }

  Future<List<UserData>> fetchByEmail(String email) async {
    final snap = await usersDb //
        .where('email', isGreaterThanOrEqualTo: email)
        .where('email', isLessThanOrEqualTo: '$email~')
        .get();
    return snap.docs
        .map((doc) => doc.data()) //
        .toList();
  }

  Future<void> addFriend(String uid1, String uid2) async {
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    await friendsDb.doc(uid1).update({uid2: createdAt});
    await friendsDb.doc(uid2).update({uid1: createdAt});
  }

  Stream<List<UserData>> friendsStream(String uid) {
    return friendsDb.doc(uid).snapshots().asyncMap(
      (doc) async {
        var friendUids = doc.data()!.keys.toList();
        friendUids.add('');
        final snap = await usersDb.where('uid', whereIn: friendUids).get();
        return snap.docs.map((doc) => doc.data()).toList();
      },
    );
  }
}
