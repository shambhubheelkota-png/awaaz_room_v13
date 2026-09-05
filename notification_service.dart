import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  NotificationService({FirebaseMessaging? messaging, FirebaseFirestore? db, FirebaseAuth? auth})
      : _messaging = messaging ?? FirebaseMessaging.instance,
        _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  Future<void> initialize() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    final token = await _messaging.getToken();
    if (token != null) await _saveToken(token);
    _messaging.onTokenRefresh.listen(_saveToken);
  }

  Future<void> _saveToken(String token) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('devices').doc(token).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<RemoteMessage> get foregroundMessages => FirebaseMessaging.onMessage;
  Stream<RemoteMessage> get notificationOpened => FirebaseMessaging.onMessageOpenedApp;
}
