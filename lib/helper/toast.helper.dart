import 'package:flutter_easyloading/flutter_easyloading.dart';

class ToastHelper {
  static Future<void> show(msg) async {
    EasyLoading.showInfo(msg);
  }

  static Future<void> showError(msg) async {
    EasyLoading.showError(msg);
  }

  static Future<void> showSuccess(msg) async {
    EasyLoading.showSuccess(msg);
  }
}
