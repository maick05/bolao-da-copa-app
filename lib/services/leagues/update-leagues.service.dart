import 'package:bolao_da_copa/model/league.model.dart';
import 'package:bolao_da_copa/services/abstract.service.dart';
import '../../model/response/custom-reponse.model.dart';
import '../../repository/api/leagues.repository.dart';

final LeaguesApiRepository apiRepo = LeaguesApiRepository();

class UpdateLeaguesService extends AbstractService {
  static Future<CustomMessageResponse> updateLeague(
      int id, String name, Rule rules) async {
    CustomMessageResponse response =
        await UpdateLeaguesService.updateLeagueName(id, name);

    if (!response.success) return response;

    return UpdateLeaguesService.updateRulesLeague(id, rules);
  }

  static Future<CustomMessageResponse> updateLeagueName(
      int id, String name) async {
    CustomResponse response = await apiRepo.updateNameLeague(id, name);
    return AbstractService.validateResponse(response, "Atualizar nome da liga",
        msgSuccess: "");
  }

  static Future<CustomMessageResponse> updateRulesLeague(
      int id, Rule rules) async {
    CustomResponse response = await apiRepo.updateRulesLeague(id, rules);
    return AbstractService.validateResponse(
        response, "Atualizar regras da liga",
        msgSuccess: "Liga atualizada com sucesso!");
  }

  static Future<CustomMessageResponse> updateLeagueRemoveUser(
      int id, int userId) async {
    CustomResponse response = await apiRepo.updateLeagueRemoveUser(id, userId);
    return AbstractService.validateResponse(response, "Remover participante",
        msgSuccess: "Participante removido com sucesso!");
  }

  static Future<CustomMessageResponse> updateLeagueAddUser(
      int id, List<int> userIds) async {
    CustomResponse response = await apiRepo.updateLeagueAddUser(id, userIds);
    return AbstractService.validateResponse(response, "Adicionar participante",
        msgSuccess: "Participante adicionado com sucesso!");
  }
}
