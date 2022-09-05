import '../../model/custom-reponse.model.dart';
import '../../repository/api.repository.dart';
import '../abstract.service.dart';

class GetRoundsService extends AbstractService {
  static Future<CustomMessageResponse> getActualRound(int idRound) async {
    var apiRepo = ApiRepository();

    CustomResponse response = await apiRepo.getActualRound(idRound.toString());

    return AbstractService.validateGetResponse(response, "buscar rounds");
  }
}
