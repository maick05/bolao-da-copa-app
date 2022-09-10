// ignore_for_file: avoid_print

import 'package:bolao_da_copa/model/response/user-league-reponse.model.dart';
import 'package:bolao_da_copa/services/abstract.service.dart';

import '../../helper/local-storage.helper.dart';
import '../../model/response/custom-reponse.model.dart';
import '../../repository/api/user-api.repository.dart';

final UserApiRepository apiRepo = UserApiRepository();

class GetUserService extends AbstractService {
  static Future<CustomMessageResponse> getUserByUsername(
      String username) async {
    CustomResponse response = await apiRepo.getUserByEmail(username);

    switch (response.status) {
      case 200:
      case 201:
      case 202:
      case 203:
      case 204:
        await LocalStorageHelper.setValue<int>('userId', response.data['id']);
        return CustomMessageResponse(true, response.data);
      default:
        String msg = response.data['message'];
        return CustomMessageResponse(false, "Erro ao buscar usuario: " + msg);
    }
  }

  static Future<CustomMessageResponse> searchUser(String term) async {
    CustomResponse response = await apiRepo.searchUser(term);

    return AbstractService.validateGetResponse<UserLeague>(
        response, "buscar participante", UserLeague());
  }
}
