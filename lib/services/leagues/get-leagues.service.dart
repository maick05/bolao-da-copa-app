import 'package:bolao_da_copa/model/league.model.dart';
import 'package:bolao_da_copa/services/abstract.service.dart';
import '../../model/response/custom-reponse.model.dart';
import '../../repository/api/leagues.repository.dart';

final LeaguesApiRepository apiRepo = LeaguesApiRepository();

class GetLeaguesService extends AbstractService {
  static Future<CustomMessageResponse> getLeaguesByUser(int idUser) async {
    CustomResponse response = await apiRepo.getLeaguesByUser(idUser);

    return AbstractService.validateGetResponse<League>(
        response, "buscar ligas", League());
  }

  static Future<CustomMessageResponse> getLeagueById(int id) async {
    CustomResponse response = await apiRepo.getLeagueById(id);

    return AbstractService.validateGetResponse<League>(
        response, "buscar liga", League(),
        list: false);
  }
}
