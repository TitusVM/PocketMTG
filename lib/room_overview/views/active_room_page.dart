import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pocket_mtg/room_overview/models/player.dart';
import 'package:pocket_mtg/room_overview/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActiveRoomPage extends StatefulWidget {
  final String roomName;
  final String playerName;

  const ActiveRoomPage(
      {Key? key, required this.roomName, required this.playerName})
      : super(key: key);

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
    _roomStream = _firestoreService.getRoomStream(widget.roomName);
  }

  Future<void> _updateLife(String playerName, int step) async {
    await _firestoreService.updateLife(widget.roomName, playerName, step);
  }

  Future<void> _updatePoison(String playerName, int step) async {
    await _firestoreService.updatePoison(widget.roomName, playerName, step);
  }

    Future<void> _updateCmdtDamage(String playerName, int step) async {
    await _firestoreService.updateCmdtDamage(widget.roomName, playerName, step);
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
              subtitle:Column(mainAxisAlignment: MainAxisAlignment.start, children: [Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _updateLife(player.name, -5),
                        )
                      : const SizedBox(
                          width: 64,
                          height: 64,
                        ),
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _updateLife(player.name, -1),
                        )
                      : const SizedBox(
                          width: 64,
                          height: 64,
                        ),
                    RichText(
                      text: TextSpan(
                      children: [
                        const WidgetSpan(
                        child: Icon(Icons.favorite, size: 16),
                        ),
                        TextSpan(
                        text: " ${player.life}",
                        style: const TextStyle(color: Colors.black),
                        ),
                      ],
                      ),
                    ),
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _updateLife(player.name, 1),
                        )
                      : const SizedBox(
                          width: 64,
                          height: 64,
                        ),
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _updateLife(player.name, 5),
                        )
                      : const SizedBox(
                          width: 64,
                          height: 64,
                        ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _updatePoison(player.name, -5),
                        )
                      : const SizedBox(
                          width: 48,
                          height: 48,
                        ),
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _updatePoison(player.name, -1),
                        )
                      : const SizedBox(
                          width: 48,
                          height: 48,
                        ),
                                      RichText(
                      text: TextSpan(
                      children: [
                        const WidgetSpan(
                        child: Icon(IconData(59394, fontFamily: 'MTGIcons')),
                        ),
                        TextSpan(
                        text: " ${player.poison}",
                        style: const TextStyle(color: Colors.black),
                        ),
                      ],
                      ),
                    ),
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _updatePoison(player.name, 1),
                        )
                      : const SizedBox(
                          width: 48,
                          height: 48,
                        ),
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _updatePoison(player.name, 5),
                        )
                      : const SizedBox(
                          width: 48,
                          height: 48,
                        ),
                ],
                
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _updateCmdtDamage(player.name, -5),
                        )
                      : const SizedBox(
                          width: 48,
                          height: 48,
                        ),
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _updateCmdtDamage(player.name, -1),
                        )
                      : const SizedBox(
                          width: 48,
                          height: 48,
                        ),
                                      RichText(
                      text: TextSpan(
                      children: [
                        const WidgetSpan(
                        child: Icon(IconData(59393, fontFamily: 'MTGIcons')),
                        ),
                        TextSpan(
                        text: " ${player.cmdtDamage}",
                        style: const TextStyle(color: Colors.black),
                        ),
                        ],
                      ),
                    ),
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _updateCmdtDamage(player.name, 1),
                        )
                      : const SizedBox(
                          width: 48,
                          height: 48,
                        ),
                  player.name == widget.playerName
                      ? IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _updateCmdtDamage(player.name, 5),
                        )
                      : const SizedBox(
                          width: 48,
                          height: 48,
                        ),
                ]) ],),
              trailing: SvgPicture.asset(player.favIcon, width: 40, height: 40),
            );
          }, separatorBuilder: (BuildContext context, int index) {
            return const Padding(padding: EdgeInsets.all(8));
           },
        );
      },
    );
  }
}
