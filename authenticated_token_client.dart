import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthenticatedTokenClient {
  AuthenticatedTokenClient({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseAuth _auth;

  Future<String> fetchLiveKitToken({
    required String apiBaseUrl,
    required String roomName,
    required String displayName,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('User must sign in first');
    final idToken = await user.getIdToken();
    final response = await http.post(
      Uri.parse('$apiBaseUrl/livekit/token'),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $idToken',
      },
      body: jsonEncode({'roomName': roomName, 'displayName': displayName}),
    );
    if (response.statusCode != 200) {
      throw StateError('Token request failed: ${response.statusCode}');
    }
    return jsonDecode(response.body)['token'] as String;
  }
}
