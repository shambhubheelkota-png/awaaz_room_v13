import 'package:livekit_client/livekit_client.dart';

class LiveAudioRoomService {
  Room? _room;
  EventsListener<RoomEvent>? _listener;

  Room? get room => _room;
  bool get connected => _room?.connectionState == ConnectionState.connected;
  List<RemoteParticipant> get participants =>
      _room?.remoteParticipants.values.toList(growable: false) ?? const [];

  Future<void> connect({
    required String liveKitUrl,
    required String token,
    void Function(RoomEvent event)? onEvent,
  }) async {
    final room = Room();
    _listener = room.createListener();
    if (onEvent != null) _listener!.on<RoomEvent>(onEvent);
    await room.connect(liveKitUrl, token);
    await room.localParticipant?.setMicrophoneEnabled(true);
    _room = room;
  }

  Future<void> setMuted(bool muted) async {
    await _room?.localParticipant?.setMicrophoneEnabled(!muted);
  }

  Future<void> disconnect() async {
    await _room?.disconnect();
    await _listener?.dispose();
    await _room?.dispose();
    _listener = null;
    _room = null;
  }
}
