import "package:bloc/bloc.dart";
import "../../../domain/repositories/broadcast_repository.dart";

abstract class BroadcastEvent {}

class BroadcastListRequested extends BroadcastEvent {}

class BroadcastSelected extends BroadcastEvent {
  final BroadcastTour tour;
  BroadcastSelected(this.tour);
}

class BroadcastRoundSelected extends BroadcastEvent {
  final BroadcastRound round;
  BroadcastRoundSelected(this.round);
}

class BroadcastsState {
  final bool fetching;
  final List<BroadcastTour> tours;
  BroadcastTour? tour;
  BroadcastRound? round;
  BroadcastsState({
    required this.fetching,
    required this.tours,
    this.tour,
    this.round,
  });
  //final BroadcastTour tours;
}

class BroadcastsBloc extends Bloc<BroadcastEvent, BroadcastsState> {
  BroadcastRepository repository;
  BroadcastsBloc({required this.repository})
      : super(BroadcastsState(fetching: true, tours: [])) {
    on<BroadcastListRequested>((event, emit) async {
      emit(BroadcastsState(fetching: true, tours: state.tours));
      var result = await repository.getBroadcastTours();
      emit(BroadcastsState(fetching: false, tours: result));
  });
  }
}
