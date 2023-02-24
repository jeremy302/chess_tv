import 'dart:async';

abstract class BroadcastRepository {
  BroadcastRepository();
  Future<List<BroadcastTour>> getBroadcastTours();
  Future<List<BroadcastTour>> getBroadcastRounds(BroadcastTour broadcast);
  Future<List<BroadcastTour>> getBroadcastRoundGames(BroadcastRound round);
  Future<Stream<String>> streamBroadcastRound(BroadcastRound round);
}

enum BroadcastGameResult { ongoing, whiteWon, blackWon, draw }

/// Info about a game in a round. it doesn't contain game moves
class BroadcastRoundGame {
  final String id, name, url;
  final bool ongoing;
  final DateTime date;
  final BroadcastGameResult result;

  BroadcastRoundGame({
    required this.id,
    required this.name,
    required this.result,
    required this.url,
    required this.ongoing,
    required this.date,
  });
}

/// Info about a round
class BroadcastRound {
  final String id, name, url;
  final bool finished;
  final DateTime startsAt;
  List<BroadcastRoundGame> games;
  BroadcastRound({
    required this.id,
    required this.name,
    required this.url,
    required this.finished,
    required this.startsAt,
    required this.games,
  });
}

/// Information about a broadcast.
class BroadcastTour {
  String id, name, slug, url, description;
  List<BroadcastRound> rounds;
  BroadcastTour(
      {required this.id,
      required this.name,
      required this.slug,
      required this.url,
      required this.description,
      required this.rounds});
  BroadcastRound get currentRound {
    //if (rounds.length == 0) return null;
    return rounds.firstWhere((round) => !round.finished);
  }
}
