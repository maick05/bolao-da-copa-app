import 'package:bolao_da_copa/helper/toast.helper.dart';
import 'package:bolao_da_copa/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import '../../model/response/custom-reponse.model.dart';

class UpdatePassword extends StatefulWidget {
  final callbackUpdate;
  const UpdatePassword(this.callbackUpdate, {Key? key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword>
    with AfterLayoutMixin<UpdatePassword> {
  final TextEditingController _actualPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  void afterFirstLayout(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Atualizar Senha'),
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
                                    controller: _actualPass,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: "Senha Atual",
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
                                    controller: _newPass,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: "Nova Senha",
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
                                    controller: _confirmPass,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: "Confirmação da Senha",
                                        labelStyle:
                                            TextStyle(color: Colors.grey[400])),
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
                                        if (_newPass.text !=
                                            _confirmPass.text) {
                                          ToastHelper.showError(
                                              "Nova senha e senha de confirmação devem ser iguais!");
                                          return;
                                        }

                                        if (_newPass.text.length < 5) {
                                          ToastHelper.showError(
                                              "Nova senha deve conter pelo menos 5 caracteres!");
                                          return;
                                        }

                                        CustomMessageResponse res =
                                            await widget.callbackUpdate(
                                          _actualPass.text,
                                          _newPass.text,
                                          _confirmPass.text,
                                        );

                                        if (!res.success) return;

                                        ToastHelper.showSuccess(
                                            "Senha alterada com sucesso!");
                                        Navigator.pop(context, true);
                                      },
                                      label: const Text("Confirmar Alteração"),
                                      icon: const Icon(Icons.save),
                                    )),
                              ],
                            ),
                          ],
                        ))))));
  }
}
