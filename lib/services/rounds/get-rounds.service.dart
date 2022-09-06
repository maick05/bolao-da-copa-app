import 'package:bolao_da_copa/model/response/actual-round.model.dart';

import '../../model/response/custom-reponse.model.dart';
import '../../repository/api.repository.dart';
import '../abstract.service.dart';

class GetRoundsService extends AbstractService {
  static Future<CustomMessageResponse> getActualRound() async {
    var apiRepo = ApiRepository();

    CustomResponse response = await apiRepo.getActualRound();

    return AbstractService.validateGetResponse(
        response, "buscar rounds", ActualRound(),
        list: false);
  }

  static Future<CustomMessageResponse> getRounds() async {
    var apiRepo = ApiRepository();

    CustomResponse response = await apiRepo.getRounds();

    return AbstractService.validateGetResponse<RoundCompetition>(
        response, "buscar rounds", RoundCompetition());
  }

  static Future<CustomMessageResponse> getMatchesByRound(int idRound) async {
    var apiRepo = ApiRepository();

    CustomResponse response = await apiRepo.getMatchesByRound(idRound);

    return AbstractService.validateGetResponse<RoundCompetition>(
        response, "buscar rounds", ActualRound(),
        list: false);
  }
}
