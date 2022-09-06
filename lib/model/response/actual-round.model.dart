import '../match.model.dart';
import 'custom-reponse.model.dart';

class ActualRound extends CustomModelResponse {
  List<RoundMatch> matchesPlayed = [];
  List<RoundMatch> nextMatches = [];
  int idRound = 0;

  ActualRound();

  @override
  fromMap(Map<String, dynamic> mapObj) {
    idRound = mapObj['idRound'];

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

class RoundCompetition extends CustomModelResponse {
  int id = 0;
  String name = "";
  int idStage = 0;

  @override
  fromMap(Map<String, dynamic> mapObj) {
    var obj = RoundCompetition();
    obj.id = mapObj['id'];
    obj.name = mapObj['name'];
    obj.idStage = mapObj['idStage'];
    return obj;
  }

  @override
  String toString() => 'ListItem a=$id b=$name c=$idStage';
}
