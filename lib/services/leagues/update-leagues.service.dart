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
}
