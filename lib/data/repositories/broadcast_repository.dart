import "../providers/broadcast_provider.dart";
import "../../domain/repositories/broadcast_repository.dart";

class BroadcastRepositoryImpl implements BroadcastRepository {
  @override
  Future<List<BroadcastTour>> getBroadcastTours() {
    return LichessBroadcastAPI.getOfficialBroadcasts().then((tours) {
      return tours
          .map((tour) => BroadcastTour(
                id: tour['tour']['id'],
                name: tour['tour']['name'],
                slug: tour['tour']['slug'],
                url: tour['tour']['url'],
                description: tour['tour']['description'],
                rounds: (tour['rounds'])
                    .map<BroadcastRound>((round) => BroadcastRound(
                          id: round['id'],
                          name: round['name'],
                          url: round['url'],
                          finished: round['finished'] ?? false,
                          startsAt: DateTime.fromMillisecondsSinceEpoch(
                              round['startsAt'] ?? 0),
                          games: [],
                        ))
                    .toList(),
              ))
          .toList();
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
  Future<Stream<String>> streamBroadcastRound(BroadcastRound round) {
    return Future(() => const Stream.empty());
  }
}
