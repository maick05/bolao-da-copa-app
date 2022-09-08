// ignore_for_file: avoid_print

import 'package:bolao_da_copa/model/response/user-league-reponse.model.dart';
import 'package:bolao_da_copa/repository/api/classification.repository.dart';
import 'package:bolao_da_copa/services/abstract.service.dart';

import '../../model/response/custom-reponse.model.dart';

final ClassificationApiRepository apiRepo = ClassificationApiRepository();

class ClassificationService extends AbstractService {
  static Future<CustomMessageResponse> getClassificationByLeague(
      int idUser) async {
    CustomResponse response = await apiRepo.getClassificationByLeague(idUser);

    return AbstractService.validateGetResponse<UserLeague>(
        response, "buscar classificação", UserLeague());
  }
}
