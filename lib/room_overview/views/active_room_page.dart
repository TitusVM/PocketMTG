import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pocket_mtg/room_overview/models/player.dart';
import 'package:pocket_mtg/room_overview/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DamageControl extends StatelessWidget {
  final String playerName;
  final IconData icon;
  final String label;
  final Function(String playerName, int step) updateCallback;

  const DamageControl({
    Key? key,
    required this.playerName,
    required this.icon,
    required this.label,
    required this.updateCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () => updateCallback(playerName, -5),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => updateCallback(playerName, -1),
        ),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(icon, size: 16),
              ),
              TextSpan(
                text: " $label",
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => updateCallback(playerName, 1),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => updateCallback(playerName, 5),
        ),
      ],
    );
  }
}

class ActiveRoomPage extends StatefulWidget {
  final String roomName;
  final String playerName;

  const ActiveRoomPage({
    Key? key,
    required this.roomName,
    required this.playerName,
  }) : super(key: key);

  @override
  State<ActiveRoomPage> createState() => _ActiveRoomPageState();
}

class _ActiveRoomPageState extends State<ActiveRoomPage> {
  late FirestoreService _firestoreService;
  late Stream<DocumentSnapshot> _roomStream;

  @override
  void initState() {
    super.initState();
    _firestoreService = Provider.of<FirestoreService>(context, listen: false);
    _roomStream = _firestoreService.getRoomStream(widget.roomName) as Stream<DocumentSnapshot<Object?>>;
  }

  Future<void> _updateLife(String playerName, int step) async {
    await _firestoreService.updateLife(widget.roomName, playerName, step);
  }

  Future<void> _updatePoison(String playerName, int step) async {
    await _firestoreService.updatePoison(widget.roomName, playerName, step);
  }

  Future<void> _updateCmdtDamage(String playerName, int step) async {
    await _firestoreService.updateCmdtDamage(
        widget.roomName, playerName, step);
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return StreamBuilder<DocumentSnapshot>(
      stream: _roomStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.data();

        if (data == null) {
          return Text(i10n.room_error_no_data);
        }

        final roomData = data as Map<String, dynamic>;

        final players = roomData['players'] as List<dynamic>;

        return ListView.separated(
          itemCount: players.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final player = Player.fromMap(players[index]);

            return ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: player.favColor, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              title: Text(
                '${i10n.player}: ${player.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DamageControl(
                    playerName: player.name,
                    icon: Icons.favorite,
                    label: '${player.life}',
                    updateCallback: _updateLife,
                  ),
                  DamageControl(
                    playerName: player.name,
                    icon: const IconData(59394, fontFamily: 'MTGIcons'),
                    label: '${player.poison}',
                    updateCallback: _updatePoison,
                  ),
                  DamageControl(
                    playerName: player.name,
                    icon: const IconData(59393, fontFamily: 'MTGIcons'),
                    label: '${player.cmdtDamage}',
                    updateCallback: _updateCmdtDamage,
                  ),
                ],
              ),
              trailing: SvgPicture.asset(player.favIcon, width: 40, height: 40),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Padding(padding: EdgeInsets.all(8));
          },
        );
      },
    );
  }
}
