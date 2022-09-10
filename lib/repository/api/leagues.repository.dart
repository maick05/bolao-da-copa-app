import 'package:bolao_da_copa/model/league.model.dart';
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

  Future<CustomResponse> updateNameLeague(int id, String name) async {
    return handleRequest(() async {
      final Map<String, dynamic> req = {"name": name};
      return httpService.makePost("/leagues/update/$id", req,
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }

  Future<CustomResponse> updateRulesLeague(int id, Rule rules) async {
    final Map<String, dynamic> rulesReq = {
      "exactlyMatch": rules.exactlyMatch,
      "oneScore": rules.oneScore,
      "winner": rules.winner,
      "penaltWinner": rules.penaltWinner,
    };

    return handleRequest(() async {
      return httpService.makePost("/classification/update/rules/league/$id",
          rulesReq, await HttpService.bearerAuthHeader('apiToken'));
    });
  }

  Future<CustomResponse> updateLeagueRemoveUser(int id, int userId) async {
    return handleRequest(() async {
      return httpService.makePost("/leagues/update/users/remove/$id", [userId],
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }

  Future<CustomResponse> updateLeagueAddUser(int id, List<int> userIds) async {
    return handleRequest(() async {
      return httpService.makePost("/leagues/update/users/add/$id", userIds,
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }
}
