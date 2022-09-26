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
}
