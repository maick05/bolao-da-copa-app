import 'package:bolao_da_copa/model/dto/push-bet.dto.dart';
import 'package:bolao_da_copa/repository/api/api.repository.dart';
import 'package:bolao_da_copa/services/http/http.service.dart';

import '../../model/response/custom-reponse.model.dart';

class BetsApiRepository extends ApiRepository {
  Future<CustomResponse> getBetsByMatch(
      int idRound, int idTeamHome, int idTeamOutside, int idLeague) async {
    return handleRequest(() async {
      final Map<String, dynamic> dto = {
        "idRound": idRound,
        "idTeamHome": idTeamHome,
        "idTeamOutside": idTeamOutside
      };

      return httpService.makePost("/bets/match/1/2022/$idLeague", dto,
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }

  Future<CustomResponse> pushBet(PushBetDTO betDto) async {
    return handleRequest(() async {
      final Map<String, dynamic> dto = {
        "idRound": betDto.idRound,
        "idUser": betDto.idUser,
        "idCompetition": betDto.idCompetition,
        "edition": betDto.edition,
        "idTeamHome": betDto.idTeamHome,
        "idTeamOutside": betDto.idTeamOutside,
        "scoreHome": betDto.scoreHome,
        "scoreOutside": betDto.scoreOutside
      };

      return httpService.makePost(
          "/bets/push", dto, await HttpService.bearerAuthHeader('apiToken'));
    });
  }
}
