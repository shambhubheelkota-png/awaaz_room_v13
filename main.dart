import 'package:flutter/material.dart';
import 'firebase bootstrap.dart';
import 'auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.initialize();

  runApp(const AwaazRoomApp());
}

class AwaazRoomApp extends StatelessWidget {
  const AwaazRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Awaaz Room',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB300),
        ),
      ),
      home: AuthGate(
        signedInBuilder: (_) => const HomeScreen(),
      ),
    );
  }
}

// ------------------------------------------------------------
// ROOM MODEL
// ------------------------------------------------------------

class Room {
  const Room({
    required this.title,
    required this.description,
    required this.host,
    required this.listeners,
    required this.category,
  });

  final String title;
  final String description;
  final String host;
  final int listeners;
  final String category;
}

// ------------------------------------------------------------
// HOME
// ------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;

  final rooms = const [
    Room(
      title: '💗 MUSIC 🎶 DIL KI SUN 🎧',
      description: 'WELCOME ALL FRIENDS 😍',
      host: 'Music Lover',
      listeners: 47,
      category: 'PK',
    ),
    Room(
      title: '❤️ PYAR DOSTI CLUB',
      description: 'Friends • Music • Masti',
      host: 'Riddhi',
      listeners: 15,
      category: 'PK',
    ),
    Room(
      title: '❤️ NABI PAK ﷺ',
      description: 'Peaceful voice room',
      host: 'Jawerya',
      listeners: 11,
      category: 'PK',
    ),
    Room(
      title: '🌹 TABHI GF ❤️',
      description: 'Come and talk with friends',
      host: 'Tabhi',
      listeners: 7,
      category: 'PK',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: selectedTab,
          children: [
            _homePage(),
            _momentPage(),
            _messagePage(),
            _mePage(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  // ----------------------------------------------------------
  // HOME PAGE
  // ----------------------------------------------------------

  Widget _homePage() {
    return Column(
      children: [
        _topHeader(),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              _topTabs(),

              _eventBanner(),

              const SizedBox(height: 12),

              _categoryButtons(),

              const SizedBox(height: 16),

              _sectionTitle(
                '🔥 पार्टी हो रही हैं',
                'वधु',
              ),

              _partyCards(),

              const SizedBox(height: 20),

              _sectionTitle(
                '🎙️ लाइव रूम',
                'सभी',
              ),

              for (final room in rooms) _roomCard(room),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFF3D1),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFC107),
                  Color(0xFFFF7043),
                ],
              ),
            ),
            child: const Icon(
              Icons.graphic_eq,
              color: Colors.white,
              size: 25,
            ),
          ),

          const Spacer(),

          IconButton(
            onPressed: () {
              _showSearch();
            },
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
          ),

          IconButton(
            onPressed: () {
              _showNotifications();
            },
            icon: const Icon(
              Icons.notifications_none,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topTabs() {
    return Container(
      height: 55,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _topTab('माइन', false),
          _topTab('पॉप्युलर', true),
          _topTab('अन्वेषण', false),
        ],
      ),
    );
  }

  Widget _topTab(String text, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 19,
            fontWeight:
                active ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        if (active)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 22,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
      ],
    );
  }

  // ----------------------------------------------------------
  // EVENT BANNER
  // ----------------------------------------------------------

  Widget _eventBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      height: 155,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFC107),
            Color(0xFFFF7043),
            Color(0xFF9C27B0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 5),
            color: Colors.black12,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 15,
            top: 10,
            child: Icon(
              Icons.card_giftcard,
              size: 75,
              color: Colors.white.withOpacity(.35),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Text(
                  '🎁 LUCKY GIFTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Share the Jackpot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'अभी शामिल हों',
                    style: TextStyle(
                      color: Color(0xFFFF6F00),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CATEGORY BUTTONS
  // ----------------------------------------------------------

  Widget _categoryButtons() {
    final categories = [
      ('🎙️', 'PK'),
      ('🎬', 'वीडियो'),
      ('🎮', 'खेल'),
      ('🎵', 'संगीत'),
    ];

    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding:
            const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final item = categories[index];

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
            ),
            decoration: BoxDecoration(
              color: index == 0
                  ? const Color(0xFFFFD54F)
                  : const Color(0xFFE9E9E9),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                Text(
                  item.$1,
                  style:
                      const TextStyle(fontSize: 21),
                ),
                const SizedBox(width: 6),
                Text(
                  item.$2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // PARTY
  // ----------------------------------------------------------

  Widget _partyCards() {
    return SizedBox(
      height: 215,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _partyCard(
            '🎂',
            'HAPPY BIRTHDAY',
            'आज 19:00 PM',
          ),
          _partyCard(
            '🎵',
            'MUSIC PARTY',
            'आज 21:00 PM',
          ),
          _partyCard(
            '🎁',
            'LUCKY PARTY',
            'कल 20:00 PM',
          ),
        ],
      ),
    );
  }

  Widget _partyCard(
    String emoji,
    String title,
    String time,
  ) {
    return Container(
      width: 275,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF81D4FA),
                  Color(0xFFFFCC80),
                ],
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style:
                    const TextStyle(fontSize: 70),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFFB300),
                  ),
                  onPressed: () {},
                  child: const Text('जाएँ'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ROOM CARD
  // ----------------------------------------------------------

  Widget _roomCard(Room room) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoomScreen(room: room),
          ),
        );
      },
      child: Container(
        margin:
            const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(.06),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFC107),
                    Color(0xFFE91E63),
                  ],
                ),
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '🇮🇳 ${room.host}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      _smallAvatar(),
                      _smallAvatar(),
                      _smallAvatar(),
                      const SizedBox(width: 7),
                      const Icon(
                        Icons.graphic_eq,
                        size: 18,
                        color: Color(0xFFFFB300),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${room.listeners}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallAvatar() {
    return Container(
      width: 25,
      height: 25,
      margin: const EdgeInsets.only(right: 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFB300),
            Color(0xFFE91E63),
          ],
        ),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.person,
        size: 15,
        color: Colors.white,
      ),
    );
  }

  // ----------------------------------------------------------
  // MOMENT
  // ----------------------------------------------------------

  Widget _momentPage() {
    return Container(
      color: const Color(0xFFF7F7F7),
      child: Column(
        children: [
          _pageTitle('लाइने (मोमेंट)'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _momentCard(
                  '🎵',
                  'आज का Music Moment',
                  'दोस्तों के साथ अपनी आवाज़ शेयर करें',
                ),
                _momentCard(
                  '❤️',
                  'Friendship Moment',
                  'अपने दोस्तों को follow करें',
                ),
                _momentCard(
                  '🎁',
                  'Lucky Moment',
                  'आज के special rewards देखें',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _momentCard(
    String emoji,
    String title,
    String subtitle,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 42),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // MESSAGES
  // ----------------------------------------------------------

  Widget _messagePage() {
    return Column(
      children: [
        _pageTitle('अधिसूचना'),

        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [
              _messageType(
                Icons.chat_bubble_outline,
                'टिप्पणियाँ',
              ),
              _messageType(
                Icons.thumb_up_alt_outlined,
                'लाइक्स',
              ),
              _messageType(
                Icons.people_outline,
                'फॉलोअर्स',
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            children: [
              _notificationTile(
                Icons.notifications,
                'सिस्टम',
                'Awaaz Room का नया संदेश',
                'आज',
              ),
              _notificationTile(
                Icons.flag,
                'गतिविधि',
                'आपके room में activity हुई',
                'आज',
              ),
              _notificationTile(
                Icons.card_giftcard,
                'पुरस्कार सहायक',
                'आपको एक reward मिला',
                'कल',
              ),
              _notificationTile(
                Icons.handshake,
                'मित्रता',
                'नए दोस्त ने आपको follow किया',
                'कल',
              ),
              _notificationTile(
                Icons.support_agent,
                'Awaaz Team',
                'हम आपकी सहायता के लिए तैयार हैं',
                '',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _messageType(
    IconData icon,
    String title,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 27,
          backgroundColor:
              const Color(0xFFFFB300),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 7),
        Text(title),
      ],
    );
  }

  Widget _notificationTile(
    IconData icon,
    String title,
    String subtitle,
    String date,
  ) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      leading: CircleAvatar(
        radius: 27,
        backgroundColor:
            const Color(0xFFFFB300),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        date,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ME / PROFILE
  // ----------------------------------------------------------

  Widget _mePage() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          Container(
            padding:
                const EdgeInsets.fromLTRB(
              20,
              25,
              20,
              25,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFE9B0),
                  Color(0xFFFFF8E7),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFB300),
                        Color(0xFFE91E63),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Awaaz User',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'ID: 10000001',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share_outlined,
                  ),
                ),
              ],
            ),
          ),

          _walletCard(),

          _profileOption(
            Icons.workspace_premium_outlined,
            'बैज',
          ),
          _profileOption(
            Icons.emoji_events_outlined,
            'अभिजात वर्ग',
          ),
          _profileOption(
            Icons.diamond_outlined,
            'SVIP',
            trailing:
                'VIP+ पाने के लिए 100000 रिचार्ज करें',
          ),
          _profileOption(
            Icons.favorite_border,
            'CP',
          ),
          _profileOption(
            Icons.storefront_outlined,
            'शॉप',
          ),
          _profileOption(
            Icons.verified_outlined,
            'लेवल',
          ),
          _profileOption(
            Icons.calendar_month_outlined,
            'दैनिक टास्क',
            trailing: 'फ्री एक्सचेंज रिवॉर्ड',
          ),
          _profileOption(
            Icons.help_outline,
            'मदद और प्रतिक्रिया',
          ),
          _profileOption(
            Icons.settings_outlined,
            'सेटिंग्स',
          ),
        ],
      ),
    );
  }

  Widget _walletCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: Color(0xFFFFA000),
            size: 34,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'वॉलेट',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            '🟡 909   💎 104',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _profileOption(
    IconData icon,
    String title, {
    String? trailing,
  }) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E5E5),
          ),
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 3,
        ),
        leading: Icon(
          icon,
          color: const Color(0xFFFFA000),
          size: 29,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(
                  color: Color(0xFFFFA000),
                  fontSize: 13,
                ),
              ),
            const SizedBox(width: 5),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // BOTTOM BAR
  // ----------------------------------------------------------

  Widget _bottomBar() {
    return NavigationBar(
      selectedIndex: selectedTab,
      onDestinationSelected: (index) {
        setState(() {
          selectedTab = index;
        });
      },
      backgroundColor: Colors.white,
      indicatorColor:
          const Color(0xFFFFE9A6),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'होम',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'लाइने',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble),
          label: 'संदेश',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'मैं',
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // HELPERS
  // ----------------------------------------------------------

  Widget _sectionTitle(
    String title,
    String action,
  ) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(18, 5, 18, 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            action,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _pageTitle(String title) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFF0C7),
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: _RoomSearchDelegate(rooms),
    );
  }

  void _showNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationScreen(),
      ),
    );
  }
}

// ------------------------------------------------------------
// SEARCH
// ------------------------------------------------------------

class _RoomSearchDelegate
    extends SearchDelegate<String> {
  final List<Room> rooms;

  _RoomSearchDelegate(this.rooms);

  @override
  List<Widget>? buildActions(
    BuildContext context,
  ) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(
    BuildContext context,
  ) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(
    BuildContext context,
  ) {
    final results = rooms.where(
      (room) =>
          room.title
              .toLowerCase()
              .contains(query.toLowerCase()),
    );

    return ListView(
      children: [
        for (final room in results)
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.mic),
            ),
            title: Text(room.title),
            subtitle:
                Text('${room.listeners} लोग लाइव'),
          ),
      ],
    );
  }

  @override
  Widget buildSuggestions(
    BuildContext context,
  ) {
    return buildResults(context);
  }
}

// ------------------------------------------------------------
// NOTIFICATION SCREEN
// ------------------------------------------------------------

class NotificationScreen
    extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('अधिसूचना'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.notifications),
            ),
            title: Text('सिस्टम'),
            subtitle:
                Text('Awaaz Room का नया अपडेट'),
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.favorite),
            ),
            title: Text('लाइक्स'),
            subtitle:
                Text('किसी ने आपके profile को पसंद किया'),
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.people),
            ),
            title: Text('फॉलोअर्स'),
            subtitle:
                Text('नया follower मिला'),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// ROOM SCREEN
// ------------------------------------------------------------

class RoomScreen extends StatefulWidget {
  const RoomScreen({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  State<RoomScreen> createState() =>
      _RoomScreenState();
}

class _RoomScreenState
    extends State<RoomScreen> {
  bool muted = true;

  final List<String> people = [
    'आप',
    'Rajan',
    'Pihu',
    'Sonu',
    'Rishu',
    'Malik',
    'Aman',
    'Sona',
    'King',
    'Anu',
    'Lucky',
    'Music',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF062B36),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF061C2A),
                    Color(0xFF07515A),
                    Color(0xFF031B2B),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _roomHeader(),

                const SizedBox(height: 5),

                _roomBadge(),

                Expanded(
                  child: GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 15,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: .72,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: people.length,
                    itemBuilder: (_, index) {
                      return _seat(
                        people[index],
                        index == 0,
                      );
                    },
                  ),
                ),

                _roomControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roomHeader() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFB300),
                  Color(0xFFE91E63),
                ],
              ),
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  widget.room.title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'ID: 57906622  •  👤 47',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.ios_share,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _roomBadge() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          left: 18,
          top: 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF6536B8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          '💗 ग्रुप 54',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _seat(
    String name,
    bool currentUser,
  ) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(.13),
            border: Border.all(
              color: currentUser
                  ? const Color(0xFFFFB300)
                  : Colors.white24,
              width: 2,
            ),
          ),
          child: Icon(
            currentUser
                ? Icons.person
                : Icons.mic_none,
            color: Colors.white70,
            size: 32,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _roomControls() {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(12, 10, 12, 15),
      color: Colors.black.withOpacity(.28),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          _roomButton(
            muted ? Icons.volume_up : Icons.volume_off,
            'आवाज़',
            () {},
          ),
          _roomButton(
            muted ? Icons.mic_off : Icons.mic,
            muted ? 'माइक' : 'माइक चालू',
            () {
              setState(() {
                muted = !muted;
              });
            },
          ),
          _roomButton(
            Icons.chat_bubble,
            'चैट',
            () {},
          ),
          _roomButton(
            Icons.emoji_emotions,
            'इमोजी',
            () {},
          ),
          _roomButton(
            Icons.card_giftcard,
            'गिफ्ट',
            () {},
          ),
          _roomButton(
            Icons.gamepad,
            'गेम',
            () {},
          ),
          _roomButton(
            Icons.menu,
            'मेनू',
            () {},
          ),
        ],
      ),
    );
  }

  Widget _roomButton(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
