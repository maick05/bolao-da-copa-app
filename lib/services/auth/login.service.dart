// ignore_for_file: avoid_print

import 'package:bolao_da_copa/repository/auth.repository.dart';

class LoginService {
  static login(String username, String password) async {
    var authRepo = AuthRepository();
    var res = await authRepo.login(username, password);
    print('res');
    print(res);
  }
}
