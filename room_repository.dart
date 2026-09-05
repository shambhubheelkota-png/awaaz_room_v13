import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VoiceRoomRecord {
  const VoiceRoomRecord({required this.id, required this.title, required this.hostId});
  final String id;
  final String title;
  final String hostId;

  factory VoiceRoomRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return VoiceRoomRecord(
      id: doc.id,
      title: data['title'] as String? ?? 'Voice Room',
      hostId: data['hostId'] as String? ?? '',
    );
  }
}

class RoomRepository {
  RoomRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Stream<List<VoiceRoomRecord>> watchRooms() {
    return _firestore
        .collection('rooms')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(VoiceRoomRecord.fromDoc).toList());
  }

  Future<VoiceRoomRecord> createRoom(String title) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Sign in required');
    final cleanTitle = title.trim();
    if (cleanTitle.length < 3 || cleanTitle.length > 80) {
      throw ArgumentError('Room title must be 3 to 80 characters');
    }
    final doc = await _firestore.collection('rooms').add({
      'title': cleanTitle,
      'hostId': user.uid,
      'status': 'live',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return VoiceRoomRecord(id: doc.id, title: cleanTitle, hostId: user.uid);
  }
}
