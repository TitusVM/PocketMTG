
import 'package:flutter/material.dart';
import 'package:pocket_mtg/multiplayer/pages/active_room_page.dart';
import 'package:pocket_mtg/multiplayer/pages/create_room_page.dart';
import 'package:pocket_mtg/multiplayer/pages/join_room_page.dart';

enum RoomPageState { home, createRoom, joinRoom, activeRoom }

class RoomHomePage extends StatefulWidget {
  const RoomHomePage({Key? key}) : super(key: key);

  @override
  State<RoomHomePage> createState() => _RoomHomePageState();
}

class _RoomHomePageState extends State<RoomHomePage> {
  RoomPageState _currentPage = RoomPageState.home;
  String _activeRoomName = '';
  String _activePlayerName = '';

  void _activateRoom(String roomName, String playerName) {
    setState(() {
      _activeRoomName = roomName;
      _activePlayerName = playerName;
      _currentPage = RoomPageState.activeRoom;
    });
  }

  void _navigateToJoinRoom() {
    setState(() {
      _currentPage = RoomPageState.joinRoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('PocketMTG'),
        leading: _currentPage == RoomPageState.home
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentPage = RoomPageState.home;
                  });
                },
              ),
      ),
      body: _getPageContent(),
    );
  }

  Widget _getPageContent() {
    switch (_currentPage) {
      case RoomPageState.createRoom:
        return CreateRoomPage(
          onRoomCreated: _activateRoom,
        );
      case RoomPageState.joinRoom:
        return JoinRoomPage(
          onRoomJoined: _activateRoom,
        );
      case RoomPageState.activeRoom:
        return ActiveRoomPage(
          roomName: _activeRoomName,
          playerName: _activePlayerName,
        );
      case RoomPageState.home:
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentPage = RoomPageState.createRoom;
              });
            },
            child: const Text('Create Room'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _navigateToJoinRoom,
            child: const Text('Join Room'),
          ),
        ],
      ),
    );
  }
}