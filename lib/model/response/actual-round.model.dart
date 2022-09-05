import '../match.model.dart';
import 'custom-reponse.model.dart';

class ActualRound extends CustomModelResponse {
  List<RoundMatch> matchesPlayed = [];
  List<RoundMatch> nextMatches = [];

  ActualRound();

  @override
  fromMap(Map<String, dynamic> mapObj) {
    List<dynamic> listPlayed = List<dynamic>.from(mapObj['matchesPlayed']);

    for (var element in listPlayed) {
      RoundMatch match = RoundMatch();
      match.fromMap(element);
      matchesPlayed.add(match);
    }

    List<dynamic> listNext = List<dynamic>.from(mapObj['nextMatches']);

    for (var element in listNext) {
      RoundMatch match = RoundMatch();
      match.fromMap(element);
      nextMatches.add(match);
    }

    return this;
  }
}
