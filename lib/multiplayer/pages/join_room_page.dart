import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_mtg/multiplayer/models/player.dart';
import 'package:pocket_mtg/multiplayer/services/firestore_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocket_mtg/themes/theme_notifier.dart';
import 'package:provider/provider.dart';

class JoinRoomPage extends StatefulWidget {
  final void Function(String roomName, String playerName) onRoomJoined; 

  const JoinRoomPage({
    required this.onRoomJoined,
    Key? key,
  }) : super(key: key);

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final TextEditingController _roomIdController = TextEditingController();
  final TextEditingController _playerNameController = TextEditingController();

  late FirestoreService _firestoreService;

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService(FirebaseFirestore.instance);
  }

  @override
  void dispose() {
    _roomIdController.dispose();
    _playerNameController.dispose();
    super.dispose();
  }

  Future<void> _joinRoom() async {
    final roomId = _roomIdController.text.trim();
    final playerName = _playerNameController.text.trim();
    final i10n = AppLocalizations.of(context)!;

    if (roomId.isEmpty || playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(i10n.room_error_empty_field),
        ),
      );
      return;
    }

    try {
      final exists = await _firestoreService.roomExists(roomId);
      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(i10n.room_error_no_room),
          ),
        );
        return;
      }
      final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
      final player = Player(name: playerName, life: 40, poison: 0, cmdtDamage: 0, favColor: themeNotifier.primaryColor, favIcon: themeNotifier.defaultIcon);
      await _firestoreService.joinRoom(roomId, player);

      widget.onRoomJoined(roomId, playerName); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(i10n.room_error_on_join),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _roomIdController,
              decoration: InputDecoration(labelText: i10n.room_name),
            ),
            TextField(
              controller: _playerNameController,
              decoration: InputDecoration(labelText: i10n.player_name),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinRoom,
              child: Text(i10n.join_room),
            ),
          ],
        ),
      );
  }
}
