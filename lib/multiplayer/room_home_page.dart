
import 'package:flutter/material.dart';

class RoomHomePage extends StatelessWidget {
  const RoomHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketMTG'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-room');
              },
              child: const Text('Create Room'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/join-room');
              },
              child: const Text('Join Room'),
            ),
          ]
        ),
      ),
    );
  }
}
  