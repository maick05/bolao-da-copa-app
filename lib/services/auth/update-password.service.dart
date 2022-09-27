import 'package:bolao_da_copa/helper/local-storage.helper.dart';
import 'package:bolao_da_copa/repository/auth.repository.dart';
import 'package:bolao_da_copa/services/abstract.service.dart';

import '../../model/response/custom-reponse.model.dart';

class UpdatePasswordService {
  static Future<CustomMessageResponse> updateUserPassword(
      String actualPass, String newPass, String confirmPass) async {
    var authRepo = AuthRepository();
    CustomResponse response = await authRepo.updateUserPassword(
        await LocalStorageHelper.getValue('username'),
        actualPass,
        newPass,
        confirmPass);

    return AbstractService.validateResponse(
        response, "atualizar senha do usuário");
  }

  static Future<CustomMessageResponse> updateForgotUserPassword(
      String actualPass,
      String newPass,
      String confirmPass,
      String validationTokenId,
      String validationCode) async {
    var authRepo = AuthRepository();
    CustomResponse response = await authRepo.updateForgotUserPassword(
        await LocalStorageHelper.getValue('username'),
        actualPass,
        newPass,
        confirmPass,
        validationTokenId,
        validationCode);

    return AbstractService.validateResponse(
        response, "atualizar senha do usuário");
  }

  static Future<CustomMessageResponse> forgotPassword(String username) async {
    var authRepo = AuthRepository();
    CustomResponse response = await authRepo.forgotPassword(username);

    return AbstractService.validateResponse(
        response, "enviar código para recuperar senha");
  }

  static Future<CustomMessageResponse> confirmCodeForgotPassword(
      String username, String code) async {
    var authRepo = AuthRepository();
    CustomResponse response =
        await authRepo.confirmCodeForgotPassword(username, code);

    return AbstractService.validateResponse(
        response, "confirmar código para recuperar senha");
  }
}
