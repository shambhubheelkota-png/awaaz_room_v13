import 'package:firebase_messaging/firebase_messaging.dart';

typedef OpenRoom = void Function(String roomId);

class NotificationRouter {
  NotificationRouter({required this.openRoom});
  final OpenRoom openRoom;

  Future<void> initialize() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handle);
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) _handle(initial);
  }

  void _handle(RemoteMessage message) {
    if (message.data['type'] == 'room_invite') {
      final roomId = message.data['roomId'];
      if (roomId is String && roomId.isNotEmpty) openRoom(roomId);
    }
  }
}
