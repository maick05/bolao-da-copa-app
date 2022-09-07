import 'package:bolao_da_copa/repository/api/bets.repository.dart';
import 'package:bolao_da_copa/services/abstract.service.dart';

import '../../model/match.model.dart';
import '../../model/response/custom-reponse.model.dart';

final BetsApiRepository apiRepo = BetsApiRepository();

class GetBetsService extends AbstractService {
  static Future<CustomMessageResponse> getMatchesByRound(
      int idRound, int idTeamHome, int idTeamOutside, int idLeague) async {
    CustomResponse response = await apiRepo.getBetsByMatch(
        idRound, idTeamHome, idTeamOutside, idLeague);
    return AbstractService.validateGetResponse<Bet>(
        response, "buscar palpites", Bet());
  }
}
