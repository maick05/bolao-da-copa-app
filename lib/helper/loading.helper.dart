import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingHelper {
  static Future<void> show() async {
    EasyLoading.show(status: "Carregando...");
  }

  static Future<void> hide() async {
    EasyLoading.dismiss();
  }
}
