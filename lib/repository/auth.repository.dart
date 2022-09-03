import 'package:bolao_da_copa/services/http/http.service.dart';

class AuthRepository {
  HttpService httpService = HttpService("http://auth.devseeder.com");

  Future<Object> login(String username, String password) {
    return httpService.makePost('/auth/login', ["BOLAO_DA_COPA/ALL/ADM"],
        HttpService.basicAuthHeader(username, password));
  }
}
