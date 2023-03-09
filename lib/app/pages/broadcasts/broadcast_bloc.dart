import "package:bloc/bloc.dart";
import "../../../domain/repositories/broadcast_repository.dart";

// base of broadcast events
abstract class BroadcastEvent {}

// when the list of broadcasts is requested
class BroadcastListRequested extends BroadcastEvent {}

// when a broadcast tour is selected to open
class BroadcastSelected extends BroadcastEvent {
  final BroadcastTour tour;
  BroadcastSelected(this.tour);
}

// // when a round is selected
// class BroadcastRoundSelected extends BroadcastEvent {
//   final BroadcastRound round;
//   BroadcastRoundSelected(this.round);
// }


// state of [BroadcastsBloc]
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
}

class BroadcastsBloc extends Bloc<BroadcastEvent, BroadcastsState> {
  BroadcastRepository repository;
  BroadcastsBloc({required this.repository})
  : super(BroadcastsState(fetching: true, tours: [])) {
    // fetech data when the broadcast list is requested
    on<BroadcastListRequested>((event, emit) async {
      emit(BroadcastsState(fetching: true, tours: state.tours));
      var result = await repository.getBroadcastTours();
      emit(BroadcastsState(fetching: false, tours: result));
  });
  }
}
