import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';

class League extends CustomModelResponse {
  int id = 0;
  String name = "";
  int idUserAdm = 0;
  List<int> userIds = [];

  @override
  fromMap(Map<String, dynamic> mapObj) {
    id = mapObj['id'];
    idUserAdm = mapObj['idUserAdm'];
    name = mapObj['name'];
    userIds = [];

    League obj = League();
    obj.id = mapObj['id'];
    obj.idUserAdm = mapObj['idUserAdm'];
    obj.name = mapObj['name'];

    return obj;
  }
}
