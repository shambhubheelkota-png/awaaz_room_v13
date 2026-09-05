import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUserSummary {
  const AppUserSummary({required this.id, required this.displayName});
  final String id;
  final String displayName;
}

class SocialService {
  SocialService({FirebaseFirestore? db, FirebaseAuth? auth})
      : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  Future<List<AppUserSummary>> searchByNamePrefix(String input) async {
    final query = input.trim().toLowerCase();
    if (query.length < 2) return const [];
    final snapshot = await _db.collection('users')
        .orderBy('displayNameLower')
        .startAt([query]).endAt(['$query\uf8ff']).limit(20).get();
    return snapshot.docs.map((doc) => AppUserSummary(
      id: doc.id,
      displayName: doc.data()['displayName'] as String? ?? 'User',
    )).toList();
  }

  Future<void> blockUser(String targetUserId) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Sign in required');
    if (user.uid == targetUserId) throw ArgumentError('Cannot block yourself');
    await _db.collection('users').doc(user.uid).collection('blocks').doc(targetUserId).set({
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unblockUser(String targetUserId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('Sign in required');
    await _db.collection('users').doc(uid).collection('blocks').doc(targetUserId).delete();
  }
}
