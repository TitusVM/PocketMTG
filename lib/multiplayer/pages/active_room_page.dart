import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_mtg/multiplayer/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ActiveRoomPage extends StatefulWidget {
  final String roomName;
  final String playerName; 

  const ActiveRoomPage({Key? key, required this.roomName, required this.playerName}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Room: ${widget.roomName}'),
        actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () async {
            await _firestoreService.leaveRoom(widget.roomName, widget.playerName);
            Navigator.pop(context); 
          },
        ),
      ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _roomStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data();

          if (data == null) {
            return const Text('No room data available.');
          }

          final roomData = data as Map<String, dynamic>;

          final players = roomData['players'] as List<dynamic>;

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index] as Map<String, dynamic>;
              final playerName = player['name'];
              final counter = player['life'];

              return ListTile(
                title: Text('Player: $playerName'),
                subtitle: Text('Life: $counter'),
                trailing: playerName == widget.playerName
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _updateLife(playerName, -1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _updateLife(playerName, -5),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _updateLife(playerName, 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _updateLife(playerName, 5),
                          ),
                        ],
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
