import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_mtg/multiplayer/services/firestore_service.dart';
import 'package:pocket_mtg/multiplayer/models/room.dart';
import 'package:pocket_mtg/multiplayer/models/player.dart';
import 'active_room_page.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
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

    if (roomName.isEmpty || playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter both Room name and Player Name."),
      ));
      return;
    }

    final room = Room(
      roomName: roomName,
      players: [Player(name: playerName, life: 40)],
    );

    try {
      await _firestoreService.createRoom(room);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActiveRoomPage(roomName: roomName, playerName: playerName),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Room name already exists. Choose a different one."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Room')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(labelText: 'Room name'),
            ),
            TextField(
              controller: _playerNameController,
              decoration: const InputDecoration(labelText: 'Player Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createRoom,
              child: const Text('Create Room'),
            ),
          ],
        ),
      ),
    );
  }
}
