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

  // 👇 NEW: emoji jo "आप" avatar ke upar dikhega
  String? selfEmoji;

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

  // 👇 NEW: emoji button dabane par 3 second ke liye emoji dikhाओ
  void showEmoji(String emoji) {
    setState(() => selfEmoji = emoji);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => selfEmoji = null);
    });
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.record.title),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Room से नहीं जुड़ पाए।\n$error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.graphic_eq, color: Colors.greenAccent),
                          const SizedBox(width: 8),
                          Text(
                            '${participants.length + 1} लोग जुड़े हैं',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    // 👇 Maza-style mic seats + emoji
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: .78,
                        ),
                        itemCount: participants.length + 1,
                        itemBuilder: (_, index) {
                          if (index == 0) {
                            return _MazaSeat(
                              name: 'आप',
                              speaking: !muted,
                              host: true,
                              emoji: selfEmoji,
                            );
                          }
                          final p = participants[index - 1];
                          return _MazaSeat(
                            name: p.name.isEmpty ? p.identity : p.name,
                            speaking: p.isSpeaking,
                            host: false,
                            emoji: null,
                          );
                        },
                      ),
                    ),

                    // 👇 Neeche controls + emoji buttons
                    SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Emoji row
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _emojiChip('😊'),
                                _emojiChip('😂'),
                                _emojiChip('😍'),
                                _emojiChip('🔥'),
                                _emojiChip('👏'),
                              ].map((w) {
                                final txt = (w as _EmojiChip).emoji;
                                return GestureDetector(
                                  onTap: () => showEmoji(txt),
                                  child: w,
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Mute + Leave buttons
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FilledButton.tonalIcon(
                                  onPressed: toggleMute,
                                  icon: Icon(
                                    muted ? Icons.mic_off : Icons.mic,
                                  ),
                                  label: Text(muted ? 'Unmute' : 'Mute'),
                                ),
                                FilledButton.tonalIcon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.call_end),
                                  label: const Text('बाहर जाएँ'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  // 👇 Emoji chip widget
  _EmojiChip(String emoji) => _EmojiChip(emoji: emoji);
}

class _EmojiChip extends StatelessWidget {
  final String emoji;
  const _EmojiChip({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.25)),
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class _MazaSeat extends StatelessWidget {
  final String name;
  final bool speaking;
  final bool host;
  final String? emoji;

  const _MazaSeat({
    required this.name,
    required this.speaking,
    required this.host,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: speaking
                      ? [Colors.greenAccent, Colors.green]
                      : [
                          Colors.white.withOpacity(.20),
                          Colors.white.withOpacity(.10)
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: host ? Colors.amber : Colors.white.withOpacity(.25),
                  width: host ? 2.5 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  name.isEmpty
                      ? '?'
                      : name.characters.first.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 👇 Emoji overlay (2–3 second ke liye)
            if (emoji != null)
              Positioned(
                top: -18,
                right: 0,
                left: 0,
                child: Text(
                  emoji!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
