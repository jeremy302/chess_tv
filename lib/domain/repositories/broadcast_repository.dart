import 'dart:async';
import 'package:dartchess/dartchess.dart';

// repository containing Broadcasts functionality
abstract class BroadcastRepository {
  BroadcastRepository();
  Future<List<BroadcastTour>> getBroadcastTours();
  Future<List<BroadcastTour>> getBroadcastRounds(BroadcastTour broadcast);
  Future<List<BroadcastTour>> getBroadcastRoundGames(BroadcastRound round);
  Future<Stream<BroadcastRoundGame>> streamBroadcastRound(BroadcastRound round);
}

enum BroadcastGameResult { pending, whiteWon, blackWon, draw }

// class BroadcastGameSnapshot{
//   String fen;
//   Duration time;
// }
class BroadcastRoundStreamData {
  final String fen, white, black;
  final double? eval;
  final Duration whiteTime, blackTime;
  final BroadcastGameResult result;
  BroadcastRoundStreamData({
    required this.fen,
    required this.white,
    required this.black,
    required this.eval,
    required this.whiteTime,
    required this.blackTime,
    required this.result,
  });
}

/// Info about a game in a round.
class BroadcastRoundGame {
  final PgnGame pgn;
  late final String id, whiteName, blackName;
  late final double whiteElo, blackElo;
  late final BroadcastGameResult result;

  BroadcastRoundGame(this.pgn) {
    whiteName = pgn.headers['White'] ?? '';
    blackName = pgn.headers['Black'] ?? '';
    id = whiteName + blackName;
    whiteElo = double.parse(pgn.headers['WhiteElo'] ?? '0');
    blackElo = double.parse(pgn.headers['BlackElo'] ?? '0');

    var resMap = {
      '1-0': BroadcastGameResult.whiteWon,
      '0-1': BroadcastGameResult.blackWon,
      '1/2-1/2': BroadcastGameResult.draw
    };
    result =
        resMap[pgn.headers['Result'] ?? '*'] ?? BroadcastGameResult.pending;
  }
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
  String id, name, slug, url, description, markup;
  List<BroadcastRound> rounds;
  BroadcastTour(
      {required this.id,
      required this.name,
      required this.slug,
      required this.url,
      required this.description,
      required this.rounds,
  required this.markup,});
  BroadcastRound get currentRound {
    //if (rounds.length == 0) return null;
    return rounds.firstWhere((round) => !round.finished);
  }
}
