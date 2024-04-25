import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pocket_mtg/multiplayer/models/player.dart';
import 'package:pocket_mtg/multiplayer/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActiveRoomPage extends StatefulWidget {
  final String roomName;
  final String playerName;

  const ActiveRoomPage(
      {Key? key, required this.roomName, required this.playerName})
      : super(key: key);

  @override
  _ActiveRoomPageState createState() => _ActiveRoomPageState();
}

class _ActiveRoomPageState extends State<ActiveRoomPage> {
  late FirestoreService _firestoreService;
  late Stream<DocumentSnapshot> _roomStream;

  @override
  void initState() {
    super.initState();
    _firestoreService = Provider.of<FirestoreService>(context, listen: false);
    _roomStream = _firestoreService.getRoomStream(widget.roomName);
  }

  Future<void> _updateLife(String playerName, int step) async {
    await _firestoreService.updateLife(widget.roomName, playerName, step);
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

        return ListView.builder(
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = Player.fromMap(players[index]);

            return ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: player.favColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              title: Row(children: [
                Text('${i10n.player}: ${player.name}'),
                Text('${i10n.life}: ${player.life}')
              ]),
              subtitle: player.name == widget.playerName
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _updateLife(player.name, -5),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _updateLife(player.name, -1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _updateLife(player.name, 1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _updateLife(player.name, 5),
                        ),
                      ],
                    )
                  : null,
                  trailing: SvgPicture.asset(player.favIcon, width: 24, height: 24)
,
            );
          },
        );
      },
    );
  }
}
