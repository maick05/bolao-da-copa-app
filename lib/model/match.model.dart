import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';

class RoundMatch extends CustomModelResponse {
  int idTeamHome = 0;
  int idTeamOutside = 0;
  String idGroup = "";
  int scoreHome = -1;
  int scoreOutside = -1;
  int penaltWinner = 0;
  int penaltHome = 0;
  int penaltOutside = 0;
  List goals = [];
  List<Bet> bets = [];
  late DateTime date;
  String teamHome = "";
  String teamHomeCode = "";
  String teamHomeImg = "";
  String teamOutside = "";
  String teamOutsideCode = "";
  String teamOutsideImg = "";

  bool isAlreadyPlayed() {
    return (scoreHome > -1 && scoreOutside > -1) ||
        date.isBefore(DateTime.now());
  }

  @override
  fromMap(Map<String, dynamic> mapObj) {
    idTeamHome = mapObj['idTeamHome'];
    idTeamOutside = mapObj['idTeamOutside'];
    idGroup = mapObj['idGroup'];
    scoreHome = mapObj['scoreHome'] ?? -1;
    scoreOutside = mapObj['scoreOutside'] ?? -1;
    goals = [];
    bets = [];
    date = DateTime.parse(mapObj['date']);
    teamHome = mapObj['teamHome'];
    teamHomeCode = mapObj['teamHomeCode'];
    teamHomeImg = mapObj['teamHomeImg'];
    teamOutside = mapObj['teamOutside'];
    teamOutsideCode = mapObj['teamOutsideCode'];
    teamOutsideImg = mapObj['teamOutsideImg'];
    return this;
  }
}

class Bet extends CustomModelResponse {
  int idUser = 0;
  int scoreHome = 0;
  int scoreOutside = -1;
  List<ScoreBet> scoreBet = [];
  late DateTime dateTime;
  String user = "";

  @override
  fromMap(Map<String, dynamic> mapObj) {
    idUser = mapObj['idUser'];
    user = mapObj['user'];
    scoreHome = mapObj['scoreHome'] ?? -1;
    scoreOutside = mapObj['scoreOutside'] ?? -1;
    dateTime = DateTime.parse(mapObj['dateTime']);

    Bet obj = Bet();
    obj.idUser = idUser;
    obj.user = user;
    obj.scoreHome = scoreHome;
    obj.scoreOutside = scoreOutside;
    obj.dateTime = dateTime;

    // List<dynamic> scores = List<dynamic>.from(mapObj['scoreBet']);

    // for (var element in scores) {
    //   ScoreBet match = ScoreBet();
    //   match.fromMap(element);
    //   scores.add(match);
    // }

    return obj;
  }
}

class ScoreBet extends CustomModelResponse {
  bool exactlyMatch = false;
  bool oneScore = false;
  bool winner = false;
  bool penaltWinner = false;
  int scoreBet = 0;
  int idLeague = 0;

  @override
  fromMap(Map<String, dynamic> mapObj) {
    exactlyMatch = mapObj['exactlyMatch'];
    oneScore = mapObj['oneScore'];
    winner = mapObj['winner'];
    penaltWinner = mapObj['penaltWinner'];
    scoreBet = mapObj['scoreBet'];
    idLeague = mapObj['idLeague'];
    return this;
  }
}
