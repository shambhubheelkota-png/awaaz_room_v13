import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import '../app_config.dart';
import '../services/authenticated_token_client.dart';
import '../services/live_audio_room_service.dart';
import '../services/room_repository.dart';

class LiveRoomScreen extends StatefulWidget {
  const LiveRoomScreen({super.key, required this.record});
  final VoiceRoomRecord record;

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  final audio = LiveAudioRoomService();
  final tokens = AuthenticatedTokenClient();
  bool loading = true;
  bool muted = false;
  String? error;

  @override
  void initState() {
    super.initState();
    join();
  }

  Future<void> join() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final token = await tokens.fetchLiveKitToken(
        apiBaseUrl: AppConfig.apiBaseUrl,
        roomName: widget.record.id,
        displayName: user.displayName ?? 'User',
      );
      await audio.connect(
        liveKitUrl: AppConfig.liveKitUrl,
        token: token,
        onEvent: (_) {
          if (mounted) setState(() {});
        },
      );
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> toggleMute() async {
    final next = !muted;
    await audio.setMuted(next);
    if (mounted) setState(() => muted = next);
  }

  @override
  void dispose() {
    audio.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final participants = audio.participants;
    return Scaffold(
      appBar: AppBar(title: Text(widget.record.title)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Room से नहीं जुड़ पाए।\n$error', textAlign: TextAlign.center),
                ))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(children: [
                        const Icon(Icons.graphic_eq),
                        const SizedBox(width: 8),
                        Text('${participants.length + 1} लोग जुड़े हैं'),
                      ]),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        padding: const EdgeInsets.all(16),
                        children: [
                          const _PersonTile(name: 'आप', isSpeaking: false),
                          ...participants.map((p) => _PersonTile(
                                name: p.name.isEmpty ? p.identity : p.name,
                                isSpeaking: p.isSpeaking,
                              )),
                        ],
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: toggleMute,
                              icon: Icon(muted ? Icons.mic_off : Icons.mic),
                              label: Text(muted ? 'Unmute' : 'Mute'),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.call_end),
                              label: const Text('बाहर जाएँ'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _PersonTile extends StatelessWidget {
  const _PersonTile({required this.name, required this.isSpeaking});
  final String name;
  final bool isSpeaking;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        radius: 30,
        backgroundColor: isSpeaking ? Colors.green : null,
        child: Text(name.isEmpty ? '?' : name.characters.first),
      ),
      const SizedBox(height: 6),
      Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
    ]);
  }
}
