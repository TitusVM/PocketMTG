part of 'room_bloc.dart';

abstract class RoomEvent extends Equatable{
    const RoomEvent();

    @override
    List<Object> get props => [];
}

class CreateClicked extends RoomEvent {
  const CreateClicked();
}

class JoinClicked extends RoomEvent {
  const JoinClicked();
}

class JoinSubmitted extends RoomEvent {
  final String room;
  final Player player;

  const JoinSubmitted({required this.room, required this.player});

  @override
  List<Object> get props => [room, player];
}

class ReturnClicked extends RoomEvent {
  const ReturnClicked();
}