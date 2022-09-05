// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart';
import '../../model/custom-reponse.model.dart';

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

    return CustomResponse(res.statusCode, jsonDecode(res.body));
  }

  static String basicAuthHeader(String username, String password) {
    return 'Basic ' + base64.encode(utf8.encode('$username:$password'));
  }
}
