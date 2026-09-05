import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ModerationService {
  ModerationService({FirebaseFirestore? db, FirebaseAuth? auth})
      : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  Future<void> reportRoom({required String roomId, required String reason}) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Sign in required');
    await _db.collection('reports').add({
      'roomId': roomId,
      'reporterId': user.uid,
      'reason': reason.trim(),
      'status': 'open',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setHandRaised({required String roomId, required bool raised}) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Sign in required');
    await _db.collection('rooms').doc(roomId).collection('participants').doc(user.uid).set({
      'handRaised': raised,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
