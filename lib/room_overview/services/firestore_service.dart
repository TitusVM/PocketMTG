import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_mtg/room_overview/models/room.dart';
import 'package:pocket_mtg/room_overview/models/player.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  Stream<DocumentSnapshot> getRoomStream(String roomName) {
    return _firestore.collection('rooms').doc(roomName).snapshots();
  }

  Future<void> createRoom(Room room) async {
    final roomRef = _firestore.collection('rooms').doc(room.roomName);
    await _firestore.runTransaction((transaction) async {
      final roomSnapshot = await transaction.get(roomRef);
      if (roomSnapshot.exists) {
        throw Exception('Room ID already exists');
      }
      transaction.set(roomRef, room.toMap());
    });
  }

  Future<void> joinRoom(String roomName, Player player) async {
    final roomRef = _firestore.collection('rooms').doc(roomName);
    await _firestore.runTransaction((transaction) async {
      final roomSnapshot = await transaction.get(roomRef);
      if (!roomSnapshot.exists) {
        throw Exception('Room does not exist');
      }
      final room = Room.fromMap(roomSnapshot.data() as Map<String, dynamic>);
      final players = room.players;
      if(players.length >= 4){
        throw Exception('Room is full');
      }
      if (players.any((p) => p.name == player.name)) {
        throw Exception('Player ID already exists');
      }
      players.add(player);
      transaction
          .update(roomRef, {'players': players.map((p) => p.toMap()).toList()});
    });
  }

  Future<void> leaveRoom(String roomName, String playerName) async {
    final roomRef = _firestore.collection('rooms').doc(roomName);
    await _firestore.runTransaction((transaction) async {
      final roomSnapshot = await transaction.get(roomRef);
      if (!roomSnapshot.exists) {
        throw Exception('Room does not exist');
      }

      final room = Room.fromMap(roomSnapshot.data() as Map<String, dynamic>);
      final players = room.players;

      final playerIndex = players.indexWhere((p) => p.name == playerName);
      if (playerIndex == -1) {
        throw Exception('Player not found in the room');
      }

      players.removeAt(playerIndex);

      if (players.isEmpty) {
        // Delete the room if there are no players left
        transaction.delete(roomRef);
      } else {
        transaction.update(roomRef, {'players': players});
      }
    });
  }

  Future<bool> roomExists(String roomId) async {
    final roomRef = _firestore.collection('rooms').doc(roomId);
    final snapshot = await roomRef.get();
    return snapshot.exists;
  }

  Future<void> updateLife(String roomName, String playerName, int step) async {
    final roomRef = _firestore.collection('rooms').doc(roomName);
    await _firestore.runTransaction((transaction) async {
      final roomSnapshot = await transaction.get(roomRef);
      if (!roomSnapshot.exists) {
        throw Exception('Room does not exist');
      }

      final room = Room.fromMap(roomSnapshot.data() as Map<String, dynamic>);
      final players = room.players;

      final playerIndex = players.indexWhere((p) => p.name == playerName);
      if (playerIndex == -1) {
        throw Exception('Player not found in the room');
      }

      final player = players[playerIndex];
      player.life += step;

      transaction
          .update(roomRef, {'players': players.map((p) => p.toMap()).toList()});
    });
  }
  Future<void> updatePoison(String roomName, String playerName, int step) async {
    final roomRef = _firestore.collection('rooms').doc(roomName);
    await _firestore.runTransaction((transaction) async {
      final roomSnapshot = await transaction.get(roomRef);
      if (!roomSnapshot.exists) {
        throw Exception('Room does not exist');
      }

      final room = Room.fromMap(roomSnapshot.data() as Map<String, dynamic>);
      final players = room.players;

      final playerIndex = players.indexWhere((p) => p.name == playerName);
      if (playerIndex == -1) {
        throw Exception('Player not found in the room');
      }

      final player = players[playerIndex];
      player.poison += step;

      transaction
          .update(roomRef, {'players': players.map((p) => p.toMap()).toList()});
    });
  }
  Future<void> updateCmdtDamage(String roomName, String playerName, int step) async {
    final roomRef = _firestore.collection('rooms').doc(roomName);
    await _firestore.runTransaction((transaction) async {
      final roomSnapshot = await transaction.get(roomRef);
      if (!roomSnapshot.exists) {
        throw Exception('Room does not exist');
      }

      final room = Room.fromMap(roomSnapshot.data() as Map<String, dynamic>);
      final players = room.players;

      final playerIndex = players.indexWhere((p) => p.name == playerName);
      if (playerIndex == -1) {
        throw Exception('Player not found in the room');
      }

      final player = players[playerIndex];
      player.cmdtDamage += step;

      transaction
          .update(roomRef, {'players': players.map((p) => p.toMap()).toList()});
    });
  }
}
