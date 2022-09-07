import 'package:bolao_da_copa/services/http/http.service.dart';

import '../model/response/custom-reponse.model.dart';

class ApiRepository {
  HttpService httpService = HttpService("http://192.168.16.108:3010");

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

  Future<CustomResponse> getActualRound() async {
    try {
      return httpService.makeGet("/rounds/actual/1/2022",
          await HttpService.bearerAuthHeader('apiToken'));
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }

  Future<CustomResponse> getRounds() async {
    try {
      return httpService.makeGet("/rounds/competition/1/2022",
          await HttpService.bearerAuthHeader('apiToken'));
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }

  Future<CustomResponse> getMatchesByRound(int idRound) async {
    try {
      return httpService.makeGet("/rounds/matches/$idRound/1/2022",
          await HttpService.bearerAuthHeader('apiToken'));
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }

  Future<CustomResponse> getUserByEmail(String email) async {
    try {
      return httpService.makeGet("/users/email/$email",
          await HttpService.bearerAuthHeader('apiToken'));
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }
}
