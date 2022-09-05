import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';

abstract class AbstractService {
  static CustomMessageResponse validateGetResponse(CustomResponse response,
      String action, CustomModelResponse objectResponse) {
    switch (response.status) {
      case 200:
      case 201:
      case 202:
      case 203:
      case 204:
        return CustomMessageResponse(
            true, objectResponse.fromMap(response.data));
      default:
        return CustomMessageResponse(
            false, "Erro ao " + action + ": " + response.data['message']);
    }
  }
}
