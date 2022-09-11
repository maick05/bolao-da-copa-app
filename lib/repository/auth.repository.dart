import 'package:bolao_da_copa/services/http/http.service.dart';

import '../model/response/custom-reponse.model.dart';

class AuthRepository {
  HttpService httpService = HttpService("http://auth.devseeder.com");

  Future<CustomResponse> login(String username, String password) async {
    try {
      return httpService.makePost('/auth/login', ["BOLAO_DA_COPA/ALL/USER"],
          HttpService.basicAuthHeader(username, password));
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }

  Future<CustomResponse> create(
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
