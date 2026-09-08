import 'package:flutter/material.dart';

void main() {
  runApp(const AwaazRoomApp());
}

// ============================================================
// APP
// ============================================================

class AwaazRoomApp extends StatelessWidget {
  const AwaazRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Awaaz Room',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

// ============================================================
// MODELS
// ============================================================

class Room {
  Room({
    required this.title,
    required this.topic,
    required this.listeners,
    this.isPrivate = false,
    this.musicEnabled = true,
    this.hostName = 'आरव',
  });

  final String title;
  final String topic;
  int listeners;
  final bool isPrivate;
  final bool musicEnabled;
  final String hostName;
}

class Person {
  Person({
    required this.name,
    required this.role,
    this.isMuted = false,
    this.handRaised = false,
    this.following = false,
    this.blocked = false,
  });

  final String name;
  String role;
  bool isMuted;
  bool handRaised;
  bool following;
  bool blocked;
}

// ============================================================
// MAIN NAVIGATION
// ============================================================

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    SearchScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Room> rooms = [
    Room(
      title: 'आज की खुली बातचीत',
      topic: 'समुदाय',
      listeners: 24,
      hostName: 'आरव',
    ),
    Room(
      title: 'Startup और Technology',
      topic: 'बिज़नेस',
      listeners: 41,
      hostName: 'राहुल',
    ),
    Room(
      title: 'संगीत प्रेमी',
      topic: 'मनोरंजन',
      listeners: 17,
      hostName: 'मीरा',
    ),
    Room(
      title: 'रात की महफ़िल',
      topic: 'दोस्ती',
      listeners: 32,
      hostName: 'सानवी',
    ),
  ];

  Future<void> createRoom() async {
    final titleController = TextEditingController();
    String category = 'समुदाय';
    bool privateRoom = false;
    bool music = true;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('नया Voice Room'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Room का नाम',
                        prefixIcon: Icon(Icons.mic),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'समुदाय',
                          child: Text('समुदाय'),
                        ),
                        DropdownMenuItem(
                          value: 'बिज़नेस',
                          child: Text('बिज़नेस'),
                        ),
                        DropdownMenuItem(
                          value: 'मनोरंजन',
                          child: Text('मनोरंजन'),
                        ),
                        DropdownMenuItem(
                          value: 'दोस्ती',
                          child: Text('दोस्ती'),
                        ),
                        DropdownMenuItem(
                          value: 'संगीत',
                          child: Text('संगीत'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            category = value;
                          });
                        }
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Private Room'),
                      value: privateRoom,
                      onChanged: (value) {
                        setDialogState(() {
                          privateRoom = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Music की अनुमति'),
                      value: music,
                      onChanged: (value) {
                        setDialogState(() {
                          music = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('रद्द करें'),
                ),
                FilledButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) return;

                    Navigator.pop(
                      context,
                      {
                        'title': titleController.text.trim(),
                        'category': category,
                        'private': privateRoom,
                        'music': music,
                      },
                    );
                  },
                  child: const Text('Room बनाएँ'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null || !mounted) return;

    final room = Room(
      title: result['title'],
      topic: result['category'],
      listeners: 1,
      isPrivate: result['private'],
      musicEnabled: result['music'],
      hostName: 'आप',
    );

    setState(() {
      rooms.insert(0, room);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoomScreen(
          room: room,
          isHost: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Awaaz Room',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'लाइव Voice Rooms',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'किसी room में शामिल हों या अपना room शुरू करें।',
          ),
          const SizedBox(height: 18),

          // Search
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 12),
                  Text('Room या user खोजें'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const SectionTitle(
            icon: Icons.local_fire_department,
            title: 'Trending Rooms',
          ),

          const SizedBox(height: 10),

          for (final room in rooms)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RoomCard(
                room: room,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RoomScreen(room: room),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createRoom,
        icon: const Icon(Icons.add),
        label: const Text('Room बनाएँ'),
      ),
    );
  }
}

// ============================================================
// ROOM CARD
// ============================================================

class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.room,
    required this.onTap,
  });

  final Room room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                child: Icon(
                  room.musicEnabled
                      ? Icons.music_note
                      : Icons.graphic_eq,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${room.topic} · ${room.listeners} श्रोता',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Host: ${room.hostName}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (room.isPrivate)
                const Icon(Icons.lock_outline),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ROOM SCREEN
// ============================================================

class RoomScreen extends StatefulWidget {
  const RoomScreen({
    super.key,
    required this.room,
    this.isHost = false,
  });

  final Room room;
  final bool isHost;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  bool muted = true;
  bool handRaised = false;
  bool musicPlaying = false;

  final List<Person> participants = [
    Person(
      name: 'आप',
      role: 'Listener',
    ),
    Person(
      name: 'आरव',
      role: 'Host',
    ),
    Person(
      name: 'मीरा',
      role: 'Speaker',
    ),
    Person(
      name: 'कबीर',
      role: 'Listener',
    ),
    Person(
      name: 'सानवी',
      role: 'Listener',
    ),
  ];

  void showMusic() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.album,
                    size: 70,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'आज की महफ़िल',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Awaaz Music'),
                  const SizedBox(height: 20),
                  const LinearProgressIndicator(value: .35),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('01:12'),
                      Text('03:42'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_previous),
                      ),
                      IconButton.filled(
                        onPressed: () {
                          setSheetState(() {
                            musicPlaying = !musicPlaying;
                          });
                          setState(() {});
                        },
                        icon: Icon(
                          musicPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_next),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const ListTile(
                    leading: Icon(Icons.queue_music),
                    title: Text('Music Queue'),
                    subtitle: Text('3 songs'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showInvite() {
    final users = [
      'राहुल',
      'नेहा',
      'मोहन',
      'पूजा',
      'अमन',
    ];

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'लोगों को Invite करें',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            for (final user in users)
              ListTile(
                leading: CircleAvatar(
                  child: Text(user[0]),
                ),
                title: Text(user),
                trailing: FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$user को invite भेजा गया'),
                      ),
                    );
                  },
                  child: const Text('Invite'),
                ),
              ),
          ],
        );
      },
    );
  }

  void showReport() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Report'),
        content: const Text(
          'आप किस समस्या की report करना चाहते हैं?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('रद्द करें'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report submit हो गई'),
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void showHostControls(Person person) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.volume_off),
                title: const Text('Mute User'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    person.isMuted = !person.isMuted;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic),
                title: const Text('Speaker बनाएँ'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    person.role = 'Speaker';
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Listener बनाएँ'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    person.role = 'Listener';
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle_outline),
                title: const Text('Room से हटाएँ'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    participants.remove(person);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.title),
        actions: [
          IconButton(
            onPressed: showInvite,
            icon: const Icon(Icons.person_add_alt_1),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                showReport();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'report',
                child: Text('Report Room'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Chip(
                  avatar: const Icon(
                    Icons.circle,
                    size: 10,
                  ),
                  label: Text(
                    widget.isHost
                        ? 'आप Host हैं'
                        : 'LIVE',
                  ),
                ),
                const Spacer(),
                Text(
                  '${participants.length} लोग',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ),
          ),

          // MUSIC
          if (widget.room.musicEnabled)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.music_note),
                  ),
                  title: const Text(
                    '🎵 Music Room',
                  ),
                  subtitle: Text(
                    musicPlaying
                        ? 'Music चल रहा है'
                        : 'Music बंद है',
                  ),
                  trailing: IconButton(
                    onPressed: showMusic,
                    icon: Icon(
                      musicPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                    ),
                  ),
                ),
              ),
            ),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'लोग',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: .78,
              ),
              itemCount: participants.length,
              itemBuilder: (_, index) {
                final person = participants[index];

                return GestureDetector(
                  onTap: widget.isHost
                      ? () => showHostControls(person)
                      : null,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            child: Text(
                              person.name.isNotEmpty
                                  ? person.name[0]
                                  : '',
                              style: const TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ),
                          if (person.role == 'Host')
                            const Positioned(
                              right: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                radius: 11,
                                child: Icon(
                                  Icons.star,
                                  size: 13,
                                ),
                              ),
                            ),
                          if (person.handRaised)
                            const Positioned(
                              left: 0,
                              top: 0,
                              child: Text(
                                '✋',
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        person.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        person.role,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // BOTTOM CONTROLS
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                12,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                    icon: muted
                        ? Icons.mic_off
                        : Icons.mic,
                    label: muted
                        ? 'माइक बंद'
                        : 'माइक चालू',
                    onPressed: () {
                      setState(() {
                        muted = !muted;
                      });
                    },
                  ),

                  ActionButton(
                    icon: handRaised
                        ? Icons.back_hand
                        : Icons.pan_tool_outlined,
                    label: handRaised
                        ? 'हाथ उठा'
                        : 'हाथ उठाएँ',
                    onPressed: () {
                      setState(() {
                        handRaised = !handRaised;

                        participants[0].handRaised =
                            handRaised;
                      });
                    },
                  ),

                  ActionButton(
                    icon: Icons.music_note,
                    label: 'Music',
                    onPressed: showMusic,
                  ),

                  ActionButton(
                    icon: Icons.person_add,
                    label: 'Invite',
                    onPressed: showInvite,
                  ),

                  ActionButton(
                    icon: Icons.logout,
                    label: 'बाहर',
                    onPressed: () {
                      Navigator.pop(context);
                    },
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

// ============================================================
// SEARCH
// ============================================================

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();

  final users = [
    'आरव',
    'मीरा',
    'राहुल',
    'सानवी',
    'कबीर',
    'नेहा',
    'मोहन',
  ];

  final rooms = [
    'आज की खुली बातचीत',
    'Startup और Technology',
    'संगीत प्रेमी',
    'रात की महफ़िल',
  ];

  @override
  Widget build(BuildContext context) {
    final query = controller.text.toLowerCase();

    final filteredUsers = users
        .where(
          (user) => user.toLowerCase().contains(query),
        )
        .toList();

    final filteredRooms = rooms
        .where(
          (room) => room.toLowerCase().contains(query),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'User या Room खोजें',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const SectionTitle(
            title: 'Users',
            icon: Icons.people,
          ),

          for (final user in filteredUsers)
            ListTile(
              leading: CircleAvatar(
                child: Text(user[0]),
              ),
              title: Text(user),
              trailing: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$user को Follow किया'),
                    ),
                  );
                },
                child: const Text('Follow'),
              ),
            ),

          const SizedBox(height: 20),

          const SectionTitle(
            title: 'Rooms',
            icon: Icons.mic,
          ),

          for (final room in filteredRooms)
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.graphic_eq),
              ),
              title: Text(room),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {},
            ),
        ],
      ),
    );
  }
}

// ============================================================
// NOTIFICATIONS
// ============================================================

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.mail),
            ),
            title: const Text(
              'आरव ने आपको room में invite किया',
            ),
            subtitle: const Text(
              'आज की खुली बातचीत',
            ),
            trailing: FilledButton(
              onPressed: () {},
              child: const Text('Join'),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person_add),
            ),
            title: const Text(
              'मीरा ने आपको follow किया',
            ),
            subtitle: const Text('कुछ मिनट पहले'),
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.mic),
            ),
            title: const Text(
              'Startup और Technology LIVE है',
            ),
            subtitle: const Text(
              'आपके follow किए हुए host का room',
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  bool following = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.person,
              size: 50,
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'आप',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: Text('@awaaz_user'),
          ),
          const SizedBox(height: 18),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: const [
              ProfileStat(
                number: '120',
                title: 'Followers',
              ),
              ProfileStat(
                number: '48',
                title: 'Following',
              ),
              ProfileStat(
                number: '16',
                title: 'Rooms',
              ),
            ],
          ),

          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: () {
              setState(() {
                following = !following;
              });
            },
            icon: Icon(
              following
                  ? Icons.check
                  : Icons.person_add,
            ),
            label: Text(
              following ? 'Following' : 'Follow',
            ),
          ),

          const SizedBox(height: 12),

          const ListTile(
            leading: Icon(Icons.history),
            title: Text('मेरे Rooms'),
            trailing: Icon(Icons.chevron_right),
          ),

          const ListTile(
            leading: Icon(Icons.block),
            title: Text('Blocked Users'),
            trailing: Icon(Icons.chevron_right),
          ),

          const ListTile(
            leading: Icon(Icons.security),
            title: Text('Privacy & Security'),
            trailing: Icon(Icons.chevron_right),
          ),

          const ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help & Support'),
            trailing: Icon(Icons.chevron_right),
          ),

          const SizedBox(height: 16),

          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SMALL WIDGETS
// ============================================================

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall,
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ProfileStat extends StatelessWidget {
  const ProfileStat({
    super.key,
    required this.number,
    required this.title,
  });

  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title),
      ],
    );
  }
}
