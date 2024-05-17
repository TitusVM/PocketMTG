import 'package:pocket_mtg/room_overview/models/player.dart';

class Room {
  final String roomName;
  final List<Player> players;

  Room({
    required this.roomName,
    required this.players,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      roomName: map['roomName'] as String,
      players: (map['players'] as List<dynamic>)
          .map((player) => Player.fromMap(player as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
      'players': players.map((player) => player.toMap()).toList(),
    };
  }
}
