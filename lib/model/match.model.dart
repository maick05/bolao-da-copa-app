class RoundMatch {
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

  fromMap(Map<String, dynamic> mapObj) {
    idTeamHome = mapObj['idTeamHome'];
    idTeamOutside = mapObj['idTeamOutside'];
    idGroup = mapObj['idGroup'];
    scoreHome = mapObj['scoreHome'] ?? -1;
    scoreOutside = mapObj['scoreOutside'] ?? -1;
    goals = [];
    bets = [];
    // date = DateTime.parse(mapObj['date']);
    teamHome = mapObj['teamHome'];
    teamHomeCode = mapObj['teamHomeCode'];
    teamHomeImg = mapObj['teamHomeImg'];
    teamOutside = mapObj['teamOutside'];
    teamOutsideCode = mapObj['teamOutsideCode'];
    teamOutsideImg = mapObj['teamOutsideImg'];
    return this;
  }
}

class Bet {
  int idUser = 0;
  int scoreHome = 0;
  int scoreOutside = -1;
  late ScoreBet scoreBet;
  late DateTime dateTime;
  String user = "";
}

class ScoreBet {
  bool exactlyMatch = false;
  bool oneScore = false;
  bool winner = false;
  bool penaltWinner = false;
  int scoreBet = 0;
  int idLeague = 0;
}
