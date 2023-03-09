import "../providers/broadcast_provider.dart";
import "../../domain/repositories/broadcast_repository.dart";
import "package:dartchess/dartchess.dart";

class BroadcastRepositoryImpl implements BroadcastRepository {
  @override
  Future<List<BroadcastTour>> getBroadcastTours() {
    return LichessBroadcastAPI.getOfficialBroadcasts().then((tours) {
      return tours.map((tour) {
        var rounds = tour['rounds']
            .map<BroadcastRound>((round) => BroadcastRound(
                  id: round['id'],
                  name: round['name'],
                  url: round['url'],
                  finished: round['finished'] ?? false,
                  startsAt: DateTime.fromMillisecondsSinceEpoch(
                      round['startsAt'] ?? 0),
                  games: [],
                ))
            .toList();
        rounds.sort((BroadcastRound a, BroadcastRound b) =>
            a.startsAt.compareTo(b.startsAt));
        return BroadcastTour(
          id: tour['tour']['id'],
          name: tour['tour']['name'],
          slug: tour['tour']['slug'],
          url: tour['tour']['url'],
          description: tour['tour']['description'],
          markup: tour['tour']['markup'] ?? '',
          rounds: rounds,
        );
      }).toList();
    });
  }

  @override
  Future<List<BroadcastTour>> getBroadcastRounds(BroadcastTour broadcast) {
    return Future(() => []);
  }

  @override
  Future<List<BroadcastTour>> getBroadcastRoundGames(BroadcastRound round) {
    return Future(() => []);
  }

  @override
  Future<Stream<BroadcastRoundGame>> streamBroadcastRound(
      BroadcastRound round) {
    return LichessBroadcastAPI.streamRoundGames(round.id).then((stream) {
      // Chess chess = Chess();
      // chess.load_pgn(stream);
      // BroadcastRoundStream(fen:chess.generate_fen(),)

      return stream.map((pgnRaw) {
        var pgn = PgnGame.parsePgn(pgnRaw);
        return BroadcastRoundGame(pgn);
      });
    });
  }
}
