import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  ProfileService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  Future<void> saveProfile({
    required String uid,
    required String displayName,
    String? phoneNumber,
  }) {
    return _firestore.collection('users').doc(uid).set({
      'displayName': displayName.trim(),
      'displayNameLower': displayName.trim().toLowerCase(),
      'phoneNumber': phoneNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchProfile(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }
}
