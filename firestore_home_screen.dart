import 'package:flutter/material.dart';
import '../services/room_repository.dart';
import 'live_room_screen.dart';

class FirestoreHomeScreen extends StatefulWidget {
  const FirestoreHomeScreen({super.key});
  @override
  State<FirestoreHomeScreen> createState() => _FirestoreHomeScreenState();
}

class _FirestoreHomeScreenState extends State<FirestoreHomeScreen> {
  final rooms = RoomRepository();

  Future<void> createRoom() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('नया Voice Room'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('रद्द करें')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('बनाएँ')),
        ],
      ),
    );
    controller.dispose();
    if (title == null || !mounted) return;
    try {
      final room = await rooms.createRoom(title);
      if (mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => LiveRoomScreen(record: room)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Awaaz Room')),
      body: StreamBuilder<List<VoiceRoomRecord>>(
        stream: rooms.watchRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Rooms लोड नहीं हुए: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final items = snapshot.data!;
          if (items.isEmpty) return const Center(child: Text('अभी कोई live room नहीं है।'));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (_, index) {
              final room = items[index];
              return Card(child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.graphic_eq)),
                title: Text(room.title),
                subtitle: const Text('Live Voice Room'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveRoomScreen(record: room))),
              ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createRoom,
        icon: const Icon(Icons.add),
        label: const Text('Room बनाएँ'),
      ),
    );
  }
}
