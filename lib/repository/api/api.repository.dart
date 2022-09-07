import 'package:bolao_da_copa/services/http/http.service.dart';
import '../../model/response/custom-reponse.model.dart';

abstract class ApiRepository {
  HttpService httpService = HttpService("http://192.168.16.108:3010");

  Future<CustomResponse> handleRequest(callback) async {
    try {
      return callback();
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }
}
