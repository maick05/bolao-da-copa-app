import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';

import 'response/user-league-reponse.model.dart';

class League extends CustomModelResponse {
  int id = 0;
  String name = "";
  String userAdm = "";
  int idUserAdm = 0;
  List<int> userIds = [];
  Rule rules = Rule();
  List<UserLeague> users = [];

  @override
  fromMap(Map<String, dynamic> mapObj) {
    id = mapObj['id'];
    idUserAdm = mapObj['idUserAdm'];
    name = mapObj['name'];
    userAdm = mapObj['userAdm'] ?? "";

    League obj = League();
    obj.id = mapObj['id'];
    obj.idUserAdm = mapObj['idUserAdm'];
    obj.name = mapObj['name'];
    obj.userAdm = mapObj['userAdm'] ?? "";
    mapObj['userIds'].forEach((element) => {obj.userIds.add(element)});

    obj.rules.exactlyMatch = mapObj['rules']['exactlyMatch'];
    obj.rules.oneScore = mapObj['rules']['oneScore'];
    obj.rules.winner = mapObj['rules']['winner'];
    obj.rules.penaltWinner = mapObj['rules']['penaltWinner'];

    List<dynamic> listUsers = [];

    if (mapObj['users'] != null) {
      listUsers = List<dynamic>.from(mapObj['users']);
    }

    for (var element in listUsers) {
      UserLeague user = UserLeague();
      var userMap = user.fromMap(element);
      obj.users.add(userMap);
      users.add(userMap);
    }

    return obj;
  }
}

class Rule {
  int exactlyMatch = 0;
  int oneScore = 0;
  int winner = 0;
  int penaltWinner = 0;
}
