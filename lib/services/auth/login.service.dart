// ignore_for_file: avoid_print

import 'package:bolao_da_copa/repository/auth.repository.dart';

import '../../helper/local-storage.helper.dart';
import '../../model/response/custom-reponse.model.dart';
import '../users/get-user.service.dart';

class LoginService {
  static Future<CustomMessageResponse> login(
      String username, String password) async {
    var authRepo = AuthRepository();
    CustomResponse response = await authRepo.login(username, password);

    switch (response.status) {
      case 401:
        return CustomMessageResponse(
            false, "Usuário e/ou senha são inválido(s)");
      case 200:
      case 201:
        CustomMessageResponse resUser =
            await GetUserService.getUserByUsername(username);

        if (!resUser.success) return resUser;

        await LocalStorageHelper.setValue<String>(
            'apiToken', response.data['token']);
        return CustomMessageResponse(true, "");
      default:
        return CustomMessageResponse(
            false, "Erro ao fazer login: " + response.data.message);
    }
  }
}
