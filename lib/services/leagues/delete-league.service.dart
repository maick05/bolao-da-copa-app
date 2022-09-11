import 'package:bolao_da_copa/services/abstract.service.dart';
import '../../model/response/custom-reponse.model.dart';
import '../../repository/api/leagues.repository.dart';

final LeaguesApiRepository apiRepo = LeaguesApiRepository();

class DeleteLeagueService extends AbstractService {
  static Future<CustomMessageResponse> deleteLeague(int id) async {
    CustomResponse response = await apiRepo.deleteLeague(id);

    return AbstractService.validateResponse(response, "Deletar liga",
        msgSuccess: "Ligada deletada com sucesso!");
  }
}
