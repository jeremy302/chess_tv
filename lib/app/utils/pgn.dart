import "package:dartchess/dartchess.dart";

/// converts last position in [pgn] into a FEN string
String pgnToFen(PgnGame pgn) {
  var moves = pgn.moves.mainline();
  var pos = PgnGame.startingPosition(pgn.headers);
  for (var move in moves) {
    var mv = pos.parseSan(move.san);
    if (mv != null) {
      pos = pos.play(mv);
    }
  }
  return pos.fen;
}
