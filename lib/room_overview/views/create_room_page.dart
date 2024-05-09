import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_mtg/room_overview/models/player.dart';
import 'package:pocket_mtg/room_overview/models/room.dart';
import 'package:pocket_mtg/room_overview/services/firestore_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocket_mtg/room_overview/bloc/room_bloc.dart';
import 'package:pocket_mtg/themes/theme_notifier.dart';
import 'package:provider/provider.dart';

class CreateRoomPage extends StatefulWidget {

  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _playerNameController = TextEditingController();

  late FirestoreService _firestoreService;

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService(FirebaseFirestore.instance);
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _playerNameController.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    final roomName = _roomNameController.text.trim();
    final playerName = _playerNameController.text.trim();
    final i10n = AppLocalizations.of(context)!;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    if (roomName.isEmpty || playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(i10n.room_error_empty_field),
        ),
      );
      return;
    }
    final player = Player(name: playerName, life: 40, poison: 0, cmdtDamage: 0, favColor: themeNotifier.primaryColor, favIcon: themeNotifier.defaultIcon);
    final room = Room(
      roomName: roomName,
      players: [player],
    );

    try {
      await _firestoreService.createRoom(room);
      context.read<RoomBloc>().add(JoinSubmitted(room: room.roomName, player: player));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(i10n.room_error_room_exists),
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
              controller: _roomNameController,
              decoration: InputDecoration(labelText: i10n.room_name),
            ),
            TextField(
              controller: _playerNameController,
              decoration: InputDecoration(labelText: i10n.player_name),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createRoom,
              child: Text(i10n.create_room),
            ),
          ],
        ),
      );
  }
}
