// ignore_for_file: avoid_print

import '../../model/response/custom-reponse.model.dart';
import '../../repository/api.repository.dart';

class CreateUserService {
  static Future<CustomMessageResponse> createUser(
      String name, String username, String password) async {
    var apiRepo = ApiRepository();
    CustomResponse response =
        await apiRepo.createUser(name, username, password);

    String msg = response.data['message'];
    switch (response.status) {
      case 200:
      case 201:
      case 202:
      case 203:
      case 204:
        return CustomMessageResponse(true, "Usuário criado com sucesso!");
      default:
        if (response.data['message']
            .contains("already exists for this project")) {
          msg = "Já existe um usuário com esse e-mail!";
        }
        return CustomMessageResponse(false, "Erro ao criar usuario: " + msg);
    }
  }
}
