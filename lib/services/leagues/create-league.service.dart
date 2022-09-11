import 'package:bolao_da_copa/services/abstract.service.dart';
import '../../model/response/custom-reponse.model.dart';
import '../../repository/api/leagues.repository.dart';

final LeaguesApiRepository apiRepo = LeaguesApiRepository();

class CreateLeagueService extends AbstractService {
  static Future<CustomMessageResponse> createLeague(
      String name, List<int> userIds) async {
    CustomResponse response = await apiRepo.createLeague(name, userIds);

    return AbstractService.validateResponse(response, "Criar liga",
        msgSuccess: "Ligada criada com sucesso!");
  }
}
