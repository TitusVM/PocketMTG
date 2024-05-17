import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_mtg/room_overview/services/firestore_service.dart';
import 'package:pocket_mtg/room_overview/bloc/room_bloc.dart';
import 'package:pocket_mtg/room_overview/views/active_room_page.dart';
import 'package:pocket_mtg/room_overview/views/create_room_page.dart';
import 'package:pocket_mtg/room_overview/views/join_room_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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

class RoomView extends StatefulWidget {
  const RoomView({Key? key}) : super(key: key);

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  late FirestoreService firestoreService;
  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(FirebaseFirestore.instance);
  }

  Future<void> _showLeaveConfirmationDialog(BuildContext context, RoomBloc bloc,
      String room, String playerName) async {
    final i10n = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(i10n.confirmation),
          content: Text(i10n.leave_confirmation),
          actions: <Widget>[
            TextButton(
              child: Text(i10n.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(i10n.confirm),
              onPressed: () {
                firestoreService.leaveRoom(room, playerName);
                bloc.add(const ReturnClicked());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) {
        final state = context.read<RoomBloc>().state;
        if (state.roomOverviewState == RoomOverviewState.active) {
          _showLeaveConfirmationDialog(
        context,
        context.read<RoomBloc>(),
        state.room!,
        state.player!.name,
          );
        } else {
          context.read<RoomBloc>().add(const ReturnClicked());
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(i10n.title),
        leading: BlocBuilder<RoomBloc, RoomState>(
          builder: (context, state) {
            if (state.roomOverviewState == RoomOverviewState.active) {
              return IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  _showLeaveConfirmationDialog(
                      context,
                      context.read<RoomBloc>(),
                      state.room!,
                      state.player!.name);
                },
              );
            }
            else if (state.roomOverviewState == RoomOverviewState.initial) {
              return Container();
            }
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<RoomBloc>().add(const ReturnClicked());
              },
            );
          },
        ),
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
        },
      ),
    ),);
  }
}

class RoomHomePage extends StatelessWidget {
  const RoomHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<RoomBloc>().add(const CreateClicked());
          },
          child: Text(i10n.create_room),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<RoomBloc>().add(const JoinClicked());
          },
          child: Text(i10n.join_room),
        ),
      ],
    ));
  }
}
