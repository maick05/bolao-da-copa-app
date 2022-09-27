import 'package:bolao_da_copa/services/http/http.service.dart';

import '../model/response/custom-reponse.model.dart';

class AuthRepository {
  HttpService httpService = HttpService("http://auth.devseeder.com");

  Future<CustomResponse> login(String username, String password) async {
    try {
      return httpService.makePost(
          '/auth/login',
          ["BOLAO_DA_COPA/ALL/USER", "AUTH/API/UPDATE_PASSWORD"],
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

  Future<CustomResponse> updateUserPassword(String username, String actualPass,
      String newPass, String confirmPass) async {
    final Map<String, String> body = {
      "username": username,
      "projectKey": "BOLAO_DA_COPA",
      "actualPassword": actualPass,
      "newPassword": newPass,
      "confirmPassword": confirmPass
    };
    try {
      return httpService.makePost('/security/password/update', body,
          await HttpService.bearerAuthHeader('apiToken'));
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }

  Future<CustomResponse> updateForgotUserPassword(
      String username,
      String actualPass,
      String newPass,
      String confirmPass,
      String validationTokenId,
      String validationCode) async {
    final Map<String, String> body = {
      "username": username,
      "projectKey": "BOLAO_DA_COPA",
      "actualPassword": actualPass,
      "newPassword": newPass,
      "confirmPassword": confirmPass,
      "validationTokenId": validationTokenId,
      "validationCode": validationCode
    };
    try {
      return httpService.makePost('/security/password/forgot/update', body,
          await HttpService.bearerAuthHeader('apiToken'));
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }

  Future<CustomResponse> forgotPassword(String username) async {
    final Map<String, String> body = {
      "username": username,
      "projectKey": "BOLAO_DA_COPA"
    };
    try {
      return httpService.makePost('/security/password/forgot', body, '');
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }

  Future<CustomResponse> confirmCodeForgotPassword(
      String username, String code) async {
    final Map<String, String> body = {
      "username": username,
      "projectKey": "BOLAO_DA_COPA",
      "code": code
    };
    try {
      return httpService.makePost(
          '/security/password/forgot/confirm', body, '');
    } on Exception catch (e) {
      return CustomResponse(500, e);
    } on Error catch (e) {
      return CustomResponse(500, e);
    }
  }
}
