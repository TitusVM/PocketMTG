import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_mtg/multiplayer/models/player.dart';
import 'package:pocket_mtg/multiplayer/services/firestore_service.dart';

class JoinRoomPage extends StatefulWidget {
  final void Function(String roomName, String playerName) onRoomJoined; 

  const JoinRoomPage({
    required this.onRoomJoined,
    Key? key,
  }) : super(key: key);

  @override
  _JoinRoomPageState createState() => _JoinRoomPageState();
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

    if (roomId.isEmpty || playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both Room ID and Player Name."),
        ),
      );
      return;
    }

    try {
      final exists = await _firestoreService.roomExists(roomId);
      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Room does not exist."),
          ),
        );
        return;
      }

      final player = Player(name: playerName, life: 40);
      await _firestoreService.joinRoom(roomId, player);

      widget.onRoomJoined(roomId, playerName); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error joining room. Player name might already exist."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _roomIdController,
              decoration: const InputDecoration(labelText: 'Room ID'),
            ),
            TextField(
              controller: _playerNameController,
              decoration: const InputDecoration(labelText: 'Player Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinRoom,
              child: const Text('Join Room'),
            ),
          ],
        ),
      );
  }
}
