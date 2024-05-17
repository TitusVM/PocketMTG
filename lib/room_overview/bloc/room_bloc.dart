import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pocket_mtg/room_overview/models/player.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  RoomBloc()
      : super(const RoomState(
            roomOverviewState: RoomOverviewState.initial,
            player: null,
            room: null)) {
    on<CreateClicked>(_onCreateClicked);
    on<JoinClicked>(_onJoinClicked);
    on<JoinSubmitted>(_onJoinSubmitted);
    on<ReturnClicked>(_onReturnClicked);
  }

  void _onCreateClicked(CreateClicked event, Emitter<RoomState> emit) {
    emit(state.copyWith(roomOverviewState: RoomOverviewState.loading));
    emit(state.copyWith(roomOverviewState: RoomOverviewState.create));
  }

  void _onJoinClicked(JoinClicked event, Emitter<RoomState> emit) {
    emit(state.copyWith(roomOverviewState: RoomOverviewState.loading));
    emit(state.copyWith(roomOverviewState: RoomOverviewState.join));
  }

  void _onJoinSubmitted(JoinSubmitted event, Emitter<RoomState> emit) {
    emit(state.copyWith(roomOverviewState: RoomOverviewState.loading));
    emit(state.copyWith(
        roomOverviewState: RoomOverviewState.active,
        room: event.room,
        player: event.player));
  }

  void _onReturnClicked(ReturnClicked event, Emitter<RoomState> emit) {
    emit(state.copyWith(roomOverviewState: RoomOverviewState.loading));
    emit(state.copyWith(roomOverviewState: RoomOverviewState.initial));
  }
}
