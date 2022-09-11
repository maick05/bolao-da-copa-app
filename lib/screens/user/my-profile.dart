import 'package:bolao_da_copa/helper/local-storage.helper.dart';
import 'package:bolao_da_copa/helper/toast.helper.dart';
import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';
import 'package:bolao_da_copa/screens/user/logout.dart';
import 'package:bolao_da_copa/services/users/get-user.service.dart';
import 'package:bolao_da_copa/services/users/update-user.service%20.dart';
import 'package:bolao_da_copa/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import '../../helper/loading.helper.dart';
import '../../model/response/user-league-reponse.model.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>
    with AfterLayoutMixin<MyProfile> {
  late final int _userId;
  UserLeague _user = UserLeague();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  @override
  void afterFirstLayout(BuildContext context) async {
    _userId = await LocalStorageHelper.getValue<int>("userId");
    CustomMessageResponse userRes = await GetUserService.getById(_userId);
    setState(() {
      _user = userRes.message;
      _nameCtrl.text = _user.name;
      _emailCtrl.text = _user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Minha Conta'),
                  backgroundColor: ColorTheme,
                ),
                resizeToAvoidBottomInset: false,
                body: SingleChildScrollView(
                    child: Container(
                        margin: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _nameCtrl,
                                    decoration: InputDecoration(
                                        labelText: "Nome",
                                        labelStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _emailCtrl,
                                    decoration: InputDecoration(
                                        labelText: "Nome Usuário/Email",
                                        labelStyle:
                                            TextStyle(color: Colors.grey[400])),
                                    enabled: false,
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorTheme),
                                      onPressed: () async {
                                        showAlertConfirmDialog(context,
                                            () async {
                                          await LoadingHelper.show();
                                          CustomMessageResponse res =
                                              await inactive(_userId);
                                          await LoadingHelper.hide();

                                          if (!res.success) return;

                                          await ToastHelper.showSuccess(
                                              res.message);
                                          await logout(context);
                                        });
                                      },
                                      icon:
                                          const Icon(Icons.disabled_by_default),
                                      label: const Text("Inativar Conta"),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorTheme),
                                      onPressed: () async {
                                        LoadingHelper.show();
                                        CustomMessageResponse res =
                                            await updateUser(
                                          _userId,
                                          _nameCtrl.text,
                                        );
                                        LoadingHelper.hide();
                                        ToastHelper.showSuccess(res.message);
                                      },
                                      label: const Text("Salvar"),
                                      icon: const Icon(Icons.save),
                                    )),
                              ],
                            )
                          ],
                        ))))));
  }
}

Future<CustomMessageResponse> updateUser(int id, String name) async {
  LoadingHelper.show();
  CustomMessageResponse message = await UpdateUserService.updateUser(id, name);
  LoadingHelper.hide();

  if (!message.success) await ToastHelper.showError(message.message);
  return message;
}

Future<CustomMessageResponse> inactive(int id) async {
  LoadingHelper.show();
  CustomMessageResponse message = await UpdateUserService.inactiveUser(id);
  LoadingHelper.hide();

  if (!message.success) await ToastHelper.showError(message.message);
  return message;
}

showAlertConfirmDialog(BuildContext context, callback) {
  // set up the buttons
  // set up the AlertDialog
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Atenção"),
        content: const Text("Tem certeza que deseja inativar sua conta?"),
        actions: [
          TextButton(
            child: const Text('CANCELAR'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          TextButton(
            child: const Text('CONFIRMAR'),
            onPressed: () async {
              Navigator.pop(context, true);
              callback();
            },
          ),
        ],
      );
    },
  );
}
