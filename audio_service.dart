import 'package:flutter_webrtc/flutter_webrtc.dart';

class AudioService {
  MediaStream? _localStream;

  bool get hasStream => _localStream != null;
  MediaStream? get stream => _localStream;
  bool get muted => !(_localStream?.getAudioTracks().firstOrNull?.enabled ?? false);

  Future<void> initializeMicrophone() async {
    _localStream ??= await navigator.mediaDevices.getUserMedia({
      'audio': {
        'echoCancellation': true,
        'noiseSuppression': true,
        'autoGainControl': true,
      },
      'video': false,
    });
  }

  void setMuted(bool value) {
    for (final track in _localStream?.getAudioTracks() ?? <MediaStreamTrack>[]) {
      track.enabled = !value;
    }
  }

  Future<void> dispose() async {
    for (final track in _localStream?.getTracks() ?? <MediaStreamTrack>[]) {
      await track.stop();
    }
    await _localStream?.dispose();
    _localStream = null;
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
