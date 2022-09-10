import 'package:bolao_da_copa/repository/api/api.repository.dart';
import 'package:bolao_da_copa/services/http/http.service.dart';

import '../../model/response/custom-reponse.model.dart';

class LeaguesApiRepository extends ApiRepository {
  Future<CustomResponse> getLeaguesByUser(int idUser) async {
    return handleRequest(() async {
      return httpService.makeGet("/leagues/user/$idUser",
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }

  Future<CustomResponse> getLeagueById(int id) async {
    return handleRequest(() async {
      return httpService.makeGet("/leagues/details/$id",
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }
}
