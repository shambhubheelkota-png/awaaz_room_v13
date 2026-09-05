import 'package:flutter_webrtc/flutter_webrtc.dart';

class PeerConnectionService {
  PeerConnectionService({required this.onIceCandidate});

  final void Function(Map<String, dynamic> candidate) onIceCandidate;
  RTCPeerConnection? _peer;
  MediaStream? _stream;

  Future<void> initialize(MediaStream stream) async {
    _stream = stream;
    _peer = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
      'sdpSemantics': 'unified-plan',
    });
    for (final track in stream.getAudioTracks()) {
      await _peer!.addTrack(track, stream);
    }
    _peer!.onIceCandidate = (candidate) {
      if (candidate.candidate == null) return;
      onIceCandidate({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };
  }

  Future<Map<String, dynamic>> createOffer() async {
    final offer = await _peer!.createOffer({'offerToReceiveAudio': true});
    await _peer!.setLocalDescription(offer);
    return {'type': offer.type, 'sdp': offer.sdp};
  }

  Future<Map<String, dynamic>> acceptOffer(Map<String, dynamic> data) async {
    await _peer!.setRemoteDescription(RTCSessionDescription(data['sdp'], data['type']));
    final answer = await _peer!.createAnswer({'offerToReceiveAudio': true});
    await _peer!.setLocalDescription(answer);
    return {'type': answer.type, 'sdp': answer.sdp};
  }

  Future<void> acceptAnswer(Map<String, dynamic> data) async {
    await _peer!.setRemoteDescription(RTCSessionDescription(data['sdp'], data['type']));
  }

  Future<void> addCandidate(Map<String, dynamic> data) async {
    await _peer?.addCandidate(RTCIceCandidate(
      data['candidate'],
      data['sdpMid'],
      data['sdpMLineIndex'],
    ));
  }

  Future<void> dispose() async {
    await _peer?.close();
    _peer = null;
    _stream = null;
  }
}
