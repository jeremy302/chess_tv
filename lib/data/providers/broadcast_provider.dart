import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// extension for [http.Response] to add [json] and [ndjson] getters
extension JsonResponse on http.Response {
  /// returns [body] as json
  dynamic get json {
    return jsonDecode(body);
  }

  /// returns [body] as newline-delimited json
  List<dynamic> get ndjson {
    return body
        .split('\n')
        .where((line) => line.isNotEmpty)
        .map(jsonDecode)
        .toList();
  }
}

/// Interracts with lichess's broadcast API
class LichessBroadcastAPI {
  /// lichess url
  static const baseUrl = 'https://lichess.org';

  /// get a list of official broadcasts
  static Future<List<dynamic>> getOfficialBroadcasts() {
    return http
        .get(Uri.parse("$baseUrl/api/broadcast"))
        .then((response) => response.ndjson);
  }

  /// gets a stream that emits pgns after a move is played
  static Future<Stream<String>> streamRoundGames(String roundId) {
    return http.Request("GET",
            Uri.parse("$baseUrl/api/stream/broadcast/round/$roundId.pgn"))
        .send()
        .then((response) => response.stream.transform(utf8.decoder));
  }
}

/// Interracts with lichess's broadcast API
class LocalBroadcastAPI {
  /// lichess url
  static const baseUrl = 'https://lichess.org';

  /// get a list of official broadcasts
  static Future<List<dynamic>> getOfficialBroadcasts() {
    return Future.delayed(Duration(seconds: 1)).then((r) => [
          {
            "tour": {
              "description": "Match for 1st 2nd and 3rd place.",
              "id": "QYiOYnl1",
              "name": "New in Chess Classic | Finals",
              "slug": "new-in-chess-classic--finals",
              "url":
                  "https://lichess.org/broadcast/new-in-chess-classic--finals/phgcXuBl"
            },
            "rounds": [
              {
                "id": "BueO56UJ",
                "name": "Finals Day 1",
                "slug": "finals-day-1",
                "url":
                    "https://lichess.org/broadcast/new-in-chess-classic--finals/finals-day-1/BueO56UJ"
              },
              {
                "id": "yeGGfkfY",
                "name": "Finals Day 2",
                "slug": "finals-day-2",
                "url":
                    "https://lichess.org/broadcast/new-in-chess-classic--finals/finals-day-2/yeGGfkfY"
              }
            ]
          }
        ]);
  }

  /// gets a stream that emits pgns after a move is played
  static Future<Stream<String>> streamRoundGames(String roundId) {
    return http.Request("GET",
            Uri.parse("$baseUrl/api/stream/broadcast/round/$roundId.pgn"))
        .send()
        .then((response) => response.stream.transform(utf8.decoder));
  }
}
