import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_mtg/room_overview/services/firestore_service.dart';
import 'package:pocket_mtg/room_overview/bloc/room_bloc.dart';
import 'package:pocket_mtg/room_overview/views/active_room_page.dart';
import 'package:pocket_mtg/room_overview/views/create_room_page.dart';
import 'package:pocket_mtg/room_overview/views/join_room_page.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();

}

class _RoomPageState extends State<RoomPage> with AutomaticKeepAliveClientMixin{

  late FirestoreService firestoreService;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(FirebaseFirestore.instance);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView(
      children: [
        BlocProvider(
          create: (context) => RoomBloc(),
          child: const RoomView(),
        ),
      ],
    );
  }
}

class RoomView extends StatelessWidget {
  const RoomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('PocketMTG'),
      ),
      body: BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        if (state.roomOverviewState == RoomOverviewState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.roomOverviewState == RoomOverviewState.create) {
          return const CreateRoomPage();
        }
        if (state.roomOverviewState == RoomOverviewState.join) {
          return const JoinRoomPage();
        }
        if (state.roomOverviewState == RoomOverviewState.active) {
          return ActiveRoomPage(
            roomName: state.room!,
            playerName: state.player!.name,
          );
        }
        return const RoomHomePage();
      },),
    );
  }
}

class RoomHomePage extends StatelessWidget {
  const RoomHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<RoomBloc>().add(const CreateClicked());
              },
              child: const Text('Create Room'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<RoomBloc>().add(const JoinClicked());
              },
              child: const Text('Join Room'),
            ),
          ],
        )
    );
  }
}