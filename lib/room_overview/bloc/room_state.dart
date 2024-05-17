part of 'room_bloc.dart';

enum RoomOverviewState { initial, create, join, loading, active }

class RoomState extends Equatable {
  final RoomOverviewState roomOverviewState;
  final String? room;
  final Player? player;

  const RoomState({
    this.roomOverviewState = RoomOverviewState.initial,
    this.room,
    this.player,
  });

  RoomState copyWith({
    RoomOverviewState? roomOverviewState,
    String? room,
    Player? player,
  }) {
    return RoomState(
      roomOverviewState: roomOverviewState ?? this.roomOverviewState,
      room: room ?? this.room,
      player: player ?? this.player,
    );
  }

  @override
  List<Object?> get props => [roomOverviewState, room, player];
}
