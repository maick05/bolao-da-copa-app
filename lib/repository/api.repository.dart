import 'package:bolao_da_copa/services/http/http.service.dart';

import '../model/custom-reponse.model.dart';

class ApiRepository {
  HttpService httpService = HttpService("http://192.168.128.1:3010");

  Future<CustomResponse> createUser(
      String name, String username, String password) async {
    try {
      final Map<String, String> user = {
        "name": name,
        "username": username,
        "password": password
      };
      return httpService.makePost('/users/create', user, '');
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }
}
