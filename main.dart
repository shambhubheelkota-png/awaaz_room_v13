import 'package:flutter/material.dart';

void main() => runApp(const AwaazRoomApp());

class AwaazRoomApp extends StatelessWidget {
  const AwaazRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Awaaz Room',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class Room {
  const Room(this.title, this.topic, this.listeners, this.isPrivate);
  final String title;
  final String topic;
  final int listeners;
  final bool isPrivate;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final rooms = <Room>[
    const Room('आज की खुली बातचीत', 'समुदाय', 24, false),
    const Room('Startup और Technology', 'बिज़नेस', 41, false),
    const Room('संगीत प्रेमी', 'मनोरंजन', 17, false),
  ];

  Future<void> _createRoom() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('नया Voice Room'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Room का नाम'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('रद्द करें')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('बनाएँ'),
          ),
        ],
      ),
    );
    if (title != null && title.isNotEmpty && mounted) {
      final room = Room(title, 'नया Room', 1, false);
      setState(() => rooms.insert(0, room));
      Navigator.push(context, MaterialPageRoute(builder: (_) => RoomScreen(room: room, isHost: true)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awaaz Room'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('लाइव Voice Rooms', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          const Text('किसी room में शामिल हों या अपना room शुरू करें।'),
          const SizedBox(height: 16),
          for (final room in rooms)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(child: Icon(room.isPrivate ? Icons.lock : Icons.graphic_eq)),
                title: Text(room.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${room.topic} · ${room.listeners} श्रोता'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RoomScreen(room: room)),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createRoom,
        icon: const Icon(Icons.add),
        label: const Text('Room बनाएँ'),
      ),
    );
  }
}

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key, required this.room, this.isHost = false});
  final Room room;
  final bool isHost;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  bool muted = true;
  bool handRaised = false;
  final participants = const [
    ('आप', 'Listener'),
    ('आरव', 'Host'),
    ('मीरा', 'Speaker'),
    ('कबीर', 'Listener'),
    ('सानवी', 'Listener'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.room.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(widget.isHost ? 'आप Host हैं' : 'Live Room')),
            const SizedBox(height: 12),
            Text('लोग', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: .82,
                ),
                itemCount: participants.length,
                itemBuilder: (_, index) {
                  final person = participants[index];
                  return Column(
                    children: [
                      CircleAvatar(radius: 30, child: Text(person.$1.characters.first)),
                      const SizedBox(height: 6),
                      Text(person.$1, overflow: TextOverflow.ellipsis),
                      Text(person.$2, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: muted ? Icons.mic_off : Icons.mic,
                  label: muted ? 'माइक बंद' : 'माइक चालू',
                  onPressed: () => setState(() => muted = !muted),
                ),
                _ActionButton(
                  icon: handRaised ? Icons.back_hand : Icons.pan_tool_outlined,
                  label: handRaised ? 'हाथ उठाया' : 'हाथ उठाएँ',
                  onPressed: () => setState(() => handRaised = !handRaised),
                ),
                _ActionButton(
                  icon: Icons.logout,
                  label: 'बाहर जाएँ',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filledTonal(onPressed: onPressed, icon: Icon(icon)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
