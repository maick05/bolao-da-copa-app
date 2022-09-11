import 'package:bolao_da_copa/repository/api/api.repository.dart';
import 'package:bolao_da_copa/services/http/http.service.dart';

import '../../model/response/custom-reponse.model.dart';

class UserApiRepository extends ApiRepository {
  Future<CustomResponse> createUser(
      String name, String username, String password) async {
    return handleRequest(() async {
      final Map<String, String> user = {
        "name": name,
        "username": username,
        "password": password
      };
      return httpService.makePost('/users/create', user, '');
    });
  }

  Future<CustomResponse> getUserByEmail(String email) async {
    return handleRequest(() async {
      return httpService.makeGet("/users/email/$email",
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }

  Future<CustomResponse> searchUser(String term) async {
    return handleRequest(() async {
      return httpService.makeGet("/users/search/$term",
          await HttpService.bearerAuthHeader('apiToken'));
    });
  }

  Future<CustomResponse> getById(int id) async {
    return handleRequest(() async {
      return httpService.makeGet(
          "/users/details/$id", await HttpService.bearerAuthHeader('apiToken'));
    });
  }
}
