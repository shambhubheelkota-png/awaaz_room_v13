import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class InviteService {
  InviteService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseAuth _auth;

  Future<void> invite({
    required String apiBaseUrl,
    required String roomId,
    required String roomTitle,
    required String recipientId,
    required String inviterName,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Sign in required');
    final idToken = await user.getIdToken();
    final response = await http.post(
      Uri.parse('$apiBaseUrl/rooms/$roomId/invite'),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'recipientId': recipientId,
        'roomTitle': roomTitle,
        'inviterName': inviterName,
      }),
    );
    if (response.statusCode != 200) {
      throw StateError('Invite failed: ${response.statusCode}');
    }
  }
}
