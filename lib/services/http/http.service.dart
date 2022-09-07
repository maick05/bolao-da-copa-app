import 'dart:convert';
import 'package:bolao_da_copa/helper/local-storage.helper.dart';
import 'package:http/http.dart';
import '../../model/response/custom-reponse.model.dart';

class HttpService {
  String url;
  HttpService(this.url);

  Future<CustomResponse> makePost(String endpoint, data, String auth) async {
    var uri = Uri.parse(url + endpoint);
    print('making post...' + uri.toString());
    Response res =
        await post(uri, body: json.encode(data), headers: <String, String>{
      "authorization": auth,
      "projectkey": "BOLAO_DA_COPA",
      "Content-Type": "application/json",
      "Accept": "application/json"
    });

    return CustomResponse(
        res.statusCode, res.body.isNotEmpty ? json.decode(res.body) : {});
  }

  Future<CustomResponse<DataResponse>> makeGet<DataResponse>(
      String endpoint, String auth) async {
    var uri = Uri.parse(url + endpoint);
    print('making get...' + uri.toString());

    Response res = await get(uri, headers: <String, String>{
      "Authorization": auth,
      "Content-Type": "application/json",
      "Accept": "application/json"
    });

    return CustomResponse(
        res.statusCode, res.body.isNotEmpty ? (json.decode(res.body)) : {});
  }

  static String basicAuthHeader(String username, String password) {
    return 'Basic ' + base64.encode(utf8.encode('$username:$password'));
  }

  static Future<String> bearerAuthHeader(String tokenKey) async {
    String token = await LocalStorageHelper.getValue<String>(tokenKey);
    return 'Bearer ' + token;
  }
}
