import 'package:flutter/material.dart';
import '../app_config.dart';
import '../services/invite_service.dart';
import '../services/social_service.dart';

class InvitePeopleSheet extends StatefulWidget {
  const InvitePeopleSheet({super.key, required this.roomId, required this.roomTitle, required this.inviterName});
  final String roomId;
  final String roomTitle;
  final String inviterName;
  @override
  State<InvitePeopleSheet> createState() => _InvitePeopleSheetState();
}

class _InvitePeopleSheetState extends State<InvitePeopleSheet> {
  final search = TextEditingController();
  final social = SocialService();
  final invites = InviteService();
  List<AppUserSummary> results = const [];
  bool busy = false;

  Future<void> runSearch() async {
    setState(() => busy = true);
    results = await social.searchByNamePrefix(search.text);
    if (mounted) setState(() => busy = false);
  }

  Future<void> invite(AppUserSummary user) async {
    await invites.invite(
      apiBaseUrl: AppConfig.apiBaseUrl,
      roomId: widget.roomId,
      roomTitle: widget.roomTitle,
      recipientId: user.id,
      inviterName: widget.inviterName,
    );
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user.displayName} को invitation भेजा गया')));
  }

  @override
  void dispose() { search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => SafeArea(child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(children: [
      Text('लोगों को बुलाएँ', style: Theme.of(context).textTheme.titleLarge),
      Row(children: [
        Expanded(child: TextField(controller: search, decoration: const InputDecoration(hintText: 'नाम से खोजें'))),
        IconButton(onPressed: busy ? null : runSearch, icon: const Icon(Icons.search)),
      ]),
      if (busy) const LinearProgressIndicator(),
      Expanded(child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (_, i) => ListTile(
          leading: CircleAvatar(child: Text(results[i].displayName.characters.first)),
          title: Text(results[i].displayName),
          trailing: FilledButton(onPressed: () => invite(results[i]), child: const Text('Invite')),
        ),
      )),
    ]),
  ));
}
