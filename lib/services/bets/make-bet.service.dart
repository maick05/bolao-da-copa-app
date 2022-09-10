import 'package:bolao_da_copa/model/dto/push-bet.dto.dart';
import 'package:bolao_da_copa/repository/api/bets.repository.dart';
import 'package:bolao_da_copa/services/abstract.service.dart';

import '../../model/response/custom-reponse.model.dart';

final BetsApiRepository apiRepo = BetsApiRepository();

class MakeBetService extends AbstractService {
  static Future<CustomMessageResponse> makeBet(
      int idUser,
      int idRound,
      int idTeamHome,
      int idTeamOutside,
      int scoreHome,
      int scoreOutside) async {
    PushBetDTO bet = PushBetDTO();

    bet.idUser = idUser;
    bet.idRound = idRound;
    bet.idTeamHome = idTeamHome;
    bet.idTeamOutside = idTeamOutside;
    bet.scoreHome = scoreHome;
    bet.scoreOutside = scoreOutside;

    CustomResponse response = await apiRepo.pushBet(bet);
    return AbstractService.validateResponse(response, "fazer palpite");
  }
}
