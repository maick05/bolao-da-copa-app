import 'package:bolao_da_copa/helper/loading.helper.dart';
import 'package:bolao_da_copa/helper/local-storage.helper.dart';
import 'package:bolao_da_copa/helper/toast.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> logout(BuildContext context) async {
  LoadingHelper.show();
  await LocalStorageHelper.remove("apiToken");
  await LocalStorageHelper.remove("userId");
  await LocalStorageHelper.clear();
  LoadingHelper.hide();
  await ToastHelper.show("Usuário Deslogado!");
  Navigator.pushReplacementNamed(context, 'login');
}
