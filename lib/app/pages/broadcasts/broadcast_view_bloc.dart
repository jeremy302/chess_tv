import "package:bloc/bloc.dart";
import "../../../domain/repositories/broadcast_repository.dart";

// base of broadcast view event
abstract class BroadcastViewEvent {}

// when the data/games of a round is requested
class BroadcastRoundRequested extends BroadcastViewEvent {
  BroadcastRound round;
  BroadcastRoundRequested(this.round);
}

// when the next page of games is requested
class BroadcastRoundNextPage extends BroadcastViewEvent {}

// when the previous page of games is requested
class BroadcastRoundPreviousPage extends BroadcastViewEvent {}

// when the first page of games is requested
class BroadcastRoundFirstPage extends BroadcastViewEvent {}

// when the last page of games is requested
class BroadcastRoundLastPage extends BroadcastViewEvent {}


// state of [BroadcastViewBloc]
class BroadcastViewState {
  // final bool fetching;
  // final BroadcastTour tour;
  final BroadcastRound round;
  final List<BroadcastRoundGame> games;
  BroadcastRoundGame? game;
  int page = 1;
  final int roundsPerPage = 9;

  BroadcastViewState({
    // required this.tour,
    required this.round,
    required this.games,
    this.game,
    this.page = 1,
  });
  int get maxPage {
    return games.isEmpty ? 1 : (games.length / roundsPerPage).ceil();
  }

  List<BroadcastRoundGame> get pageGames {
    return games.skip((page - 1) * roundsPerPage).take(roundsPerPage).toList();
  }
}

class BroadcastViewBloc extends Bloc<BroadcastViewEvent, BroadcastViewState> {
  BroadcastRepository repository;
  // current broadcast that is opened
  BroadcastTour tour;
  // unique index of fames
  Map<String, BroadcastRoundGame> games = {};
  //List<BroadcastRoundGame> _games = [];
  BroadcastViewBloc({required this.repository, required this.tour})
      : super(BroadcastViewState(
            // tour: tour,
            round: tour.currentRound,
            games: [])) {
    on<BroadcastRoundRequested>((event, emit) async {
      //_games.clear();
      if (event.round == state.round) return;
      games.clear();
      emit(BroadcastViewState(
          // tour: tour,
          round: event.round,
          games: []));

      var stream = await repository.streamBroadcastRound(event.round);
      await for (var game in stream) {
        addGame(game);
        emit(BroadcastViewState(
            // tour: tour,
            round: state.round,
            games: games.values.toList()));
      }
      // stream.listen((game) {
      //   print("got game: ${game}");
      //   addGame(game);
      //   emit(BroadcastViewState(
      //       // tour: tour,
      //       round: state.round,
      //       games: games.values.toList()));
      // });
    });
    on<BroadcastRoundNextPage>((event, emit) {
      if (state.page < state.maxPage) {
        emit(BroadcastViewState(
            round: state.round,
            games: state.games,
            game: state.game,
            page: state.page + 1));
      }
    });
    on<BroadcastRoundPreviousPage>((event, emit) {
      if (state.page > 1) {
        emit(BroadcastViewState(
            round: state.round,
            games: state.games,
            game: state.game,
            page: state.page - 1));
      }
    });
    on<BroadcastRoundFirstPage>((event, emit) {
      if (state.page != 1) {
        emit(BroadcastViewState(
            round: state.round, games: state.games, game: state.game, page: 1));
      }
    });
    on<BroadcastRoundLastPage>((event, emit) {
      if (state.page != state.maxPage) {
        emit(BroadcastViewState(
            round: state.round,
            games: state.games,
            game: state.game,
            page: state.maxPage));
      }
    });
  }
  addGame(BroadcastRoundGame game) {
    games[game.id] = game;
  }
}
