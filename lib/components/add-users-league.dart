import 'package:bolao_da_copa/helper/loading.helper.dart';
import 'package:bolao_da_copa/helper/toast.helper.dart';
import 'package:bolao_da_copa/model/response/user-league-reponse.model.dart';
import 'package:flutter/material.dart';
import '../model/league.model.dart';
import '../model/response/custom-reponse.model.dart';
import '../services/users/get-user.service.dart';
import 'package:collection/collection.dart';

Future<void> AddUsersLeague(
    BuildContext context,
    League league,
    List<UserLeague> users,
    int userId,
    callbackDialogAdd,
    callbackRemove) async {
  TextEditingController searchCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 10.0),
              child: AlertDialog(
                scrollable: true,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                contentPadding: const EdgeInsets.all(5),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                title: const Text('Adicionar Participante'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (league.idUserAdm == userId)
                      Autocomplete<UserLeague>(
                        key: _formKey,
                        displayStringForOption: ((option) =>
                            option.name + ", " + option.email),
                        fieldViewBuilder: (context, controller, focusNode,
                            onEditingComplete) {
                          searchCtrl = controller;
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            onEditingComplete: onEditingComplete,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: "Digite nome ou email...",
                            ),
                          );
                        },
                        optionsBuilder:
                            (TextEditingValue textEditingValue) async {
                          print("Typing..." + textEditingValue.text);
                          if (textEditingValue.text == '' ||
                              textEditingValue.text.length <= 2) {
                            return const Iterable<UserLeague>.empty();
                          }
                          LoadingHelper.show();
                          CustomMessageResponse res =
                              await GetUserService.searchUser(
                                  textEditingValue.text);
                          LoadingHelper.hide();

                          var results = res.message.where((UserLeague element) {
                            List<int> usersMap =
                                users.map((e) => e.id).toList();
                            return !usersMap.contains(element.id) &&
                                element.id != userId;
                          });

                          if (!res.success || res.message.isEmpty) {
                            if (!res.success) {
                              ToastHelper.showError(res.message);
                            }
                            return const Iterable<UserLeague>.empty();
                          }

                          return results;
                        },
                        onSelected: (UserLeague selection) {
                          searchCtrl.clear();
                          // searchCtrl.text = "";
                          setState(() {
                            users.add(selection);
                          });
                        },
                      ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemCount: users.length,
                              itemBuilder: (context, indice) {
                                final user = users[indice];
                                return Card(
                                    child: ListTile(
                                        title: Text(
                                          user.name,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 75, 73, 73)),
                                        ),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(user.email),
                                            if (league.idUserAdm == userId)
                                              Wrap(
                                                  direction: Axis.horizontal,
                                                  alignment: WrapAlignment.end,
                                                  children: [
                                                    IconButton(
                                                        tooltip:
                                                            "Remover Participante",
                                                        onPressed: () async {
                                                          showAlertConfirmDialog(
                                                              context,
                                                              () async {
                                                            if (checkNewUser(
                                                                league.users,
                                                                user)) {
                                                              setState(
                                                                  () => {
                                                                        users.removeWhere((element) =>
                                                                            element.id ==
                                                                            user.id)
                                                                      });
                                                              return;
                                                            }

                                                            CustomMessageResponse
                                                                res =
                                                                await callbackRemove(
                                                                    league,
                                                                    user.id);
                                                            if (!res.success) {
                                                              return;
                                                            }

                                                            setState(() => {
                                                                  users.removeWhere(
                                                                      (element) =>
                                                                          element
                                                                              .id ==
                                                                          user.id)
                                                                });
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete)),
                                                  ])
                                          ],
                                        )));
                              }),
                        ],
                      ),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('FECHAR'),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  if (league.idUserAdm == userId)
                    TextButton(
                      child: const Text('CONFIRMAR'),
                      onPressed: () async {
                        List<UserLeague> usersFilter = users
                            .where((element) =>
                                !league.userIds.contains(element.id))
                            .toList();
                        await callbackDialogAdd(league, usersFilter);
                        Navigator.pop(context, true);
                      },
                    ),
                ],
              ));
        });
      });
}

showAlertConfirmDialog(BuildContext context, callback) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text('CANCELAR'),
    onPressed: () {
      Navigator.pop(context, true);
    },
  );

  Widget continueButton = TextButton(
    child: const Text('CONFIRMAR'),
    onPressed: () {
      callback();
      Navigator.pop(context, true);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Atenção"),
    content: const Text("Tem certeza que deseja remover este participante?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

bool checkNewUser(List<UserLeague> usersLeague, UserLeague actualUser) {
  var res =
      usersLeague.firstWhereOrNull((element) => element.id == actualUser.id);
  print("res ----> ");
  print(res);
  return res == null;
}
