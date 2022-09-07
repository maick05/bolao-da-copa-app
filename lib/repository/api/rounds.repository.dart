import 'package:bolao_da_copa/repository/api/api.repository.dart';
import 'package:bolao_da_copa/services/http/http.service.dart';
import '../../model/response/custom-reponse.model.dart';

class RoundsApiRepository extends ApiRepository {
  Future<CustomResponse> getActualRound() async {
    return handleRequest(() async {
      return httpService.makeGet("/rounds/actual/1/2022",
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }

  Future<CustomResponse> getRounds() async {
    return handleRequest(() async {
      return httpService.makeGet("/rounds/competition/1/2022",
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }

  Future<CustomResponse> getMatchesByRound(int idRound) async {
    return handleRequest(() async {
      return httpService.makeGet("/rounds/matches/$idRound/1/2022",
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }
}
