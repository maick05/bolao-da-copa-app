import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';

class UserClassification extends CustomModelResponse {
  String user = "";
  String userEmail = "";
  int points = 0;
  int exactlyMatch = 0;
  int winner = 0;
  int oneScore = 0;
  int userId = 0;

  @override
  fromMap(Map<String, dynamic> mapObj) {
    UserClassification obj = UserClassification();
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

class UserLeague extends CustomModelResponse {
  int id = 0;
  String name = "";
  String email = "";

  @override
  fromMap(Map<String, dynamic> mapObj) {
    UserLeague obj = UserLeague();
    obj.id = mapObj["id"];
    obj.name = mapObj["name"];
    obj.email = mapObj["email"];

    return obj;
  }
}
