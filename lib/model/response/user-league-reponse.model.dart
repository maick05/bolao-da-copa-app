import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';

class UserLeague extends CustomModelResponse {
  String user = "";
  String userEmail = "";
  int points = 0;
  int exactlyMatch = 0;
  int winner = 0;
  int oneScore = 0;
  int userId = 0;

  @override
  fromMap(Map<String, dynamic> mapObj) {
    UserLeague obj = UserLeague();
    obj.user = mapObj["user"];
    obj.userEmail = mapObj["userEmail"];
    obj.points = mapObj["points"];
    obj.exactlyMatch = mapObj["exactlyMatch"];
    obj.winner = mapObj["winner"];
    obj.oneScore = mapObj["oneScore"];
    obj.userId = mapObj["userId"];

    return obj;
  }
}
