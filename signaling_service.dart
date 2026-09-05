import 'package:socket_io_client/socket_io_client.dart' as io;

class SignalingService {
  SignalingService({required this.serverUrl});

  final String serverUrl;
  io.Socket? _socket;
  bool get connected => _socket?.connected ?? false;

  void connect({required String roomId, required Map<String, dynamic> user}) {
    _socket = io.io(
      serverUrl,
      io.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
    _socket!
      ..onConnect((_) => _socket!.emit('join-room', {'roomId': roomId, 'user': user}))
      ..connect();
  }

  void raiseHand({required String roomId, required String userId, required bool raised}) {
    _socket?.emit('raise-hand', {'roomId': roomId, 'userId': userId, 'raised': raised});
  }

  void sendSignal({required String roomId, required String target, required dynamic payload}) {
    _socket?.emit('signal', {'roomId': roomId, 'target': target, 'payload': payload});
  }

  void onSignal(void Function(dynamic data) handler) => _socket?.on('signal', handler);

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }
}
