import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../models/player.dart';
import 'active_room_page.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter both Room ID and Player Name."),
      ));
      return;
    }

    try {
      final exists = await _firestoreService.roomExists(roomId); 
      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Room does not exist."),
        ));
        return;
      }

      final player = Player(name: playerName, life: 40); 
      await _firestoreService.joinRoom(roomId, player);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActiveRoomPage(roomName: roomId, playerName: playerName),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error joining room. Player name might already exist."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Room')),
      body: Padding(
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
      ),
    );
  }
}
