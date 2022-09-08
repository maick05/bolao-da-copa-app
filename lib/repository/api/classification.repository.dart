import 'package:bolao_da_copa/repository/api/api.repository.dart';
import 'package:bolao_da_copa/services/http/http.service.dart';

import '../../model/response/custom-reponse.model.dart';

class ClassificationApiRepository extends ApiRepository {
  Future<CustomResponse> getClassificationByLeague(int idLeague) async {
    return handleRequest(() async {
      return httpService.makeGet("/bets/classification/league/$idLeague",
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }
}
