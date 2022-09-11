// ignore_for_file: avoid_print

import 'package:bolao_da_copa/repository/api/user-api.repository.dart';
import 'package:bolao_da_copa/services/abstract.service.dart';

import '../../model/response/custom-reponse.model.dart';

final UserApiRepository apiRepo = UserApiRepository();

class UpdateUserService {
  static Future<CustomMessageResponse> updateUser(int id, String name) async {
    CustomResponse response = await apiRepo.updateUser(id, name);

    return AbstractService.validateResponse(response, "atualizar usuário",
        msgSuccess: "Usuário atualizado com sucesso!");
  }

  static Future<CustomMessageResponse> inactiveUser(int id) async {
    CustomResponse response = await apiRepo.inactivateUser(id);

    return AbstractService.validateResponse(response, "inativar usuário",
        msgSuccess: "Usuário inativado com sucesso!");
  }
}
