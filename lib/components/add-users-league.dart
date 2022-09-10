import 'package:bolao_da_copa/helper/loading.helper.dart';
import 'package:bolao_da_copa/helper/toast.helper.dart';
import 'package:bolao_da_copa/model/response/user-league-reponse.model.dart';
import 'package:bolao_da_copa/services/leagues/update-leagues.service.dart';
import 'package:flutter/material.dart';
import '../model/league.model.dart';
import '../model/response/custom-reponse.model.dart';
import '../services/users/get-user.service.dart';

Future<void> AddUsersLeague(
    BuildContext context, League league, callbackDialog) async {
  List<UserLeague> actualResult = [];
  List<UserLeague> users = [];
  TextEditingController searchCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(3),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            title: const Text('Adicionar Participante'),
            content: SingleChildScrollView(
                child: Column(
              children: [
                // TypeAheadFormField(
                //     key: GlobalKey(),
                //     textFieldConfiguration: TextFieldConfiguration(
                //         controller: searchCtrl,
                //         autofocus: true,
                //         style: DefaultTextStyle.of(context)
                //             .style
                //             .copyWith(fontStyle: FontStyle.italic),
                //         decoration: const InputDecoration(
                //             border: OutlineInputBorder())),
                //     suggestionsCallback: (pattern) async {
                //       CustomMessageResponse res =
                //           await GetUserService.searchUser(pattern);
                //       LoadingHelper.hide();

                //       if (!res.success) {
                //         ToastHelper.showError(res.message);
                //         return const Iterable<String>.empty();
                //       }

                //       return res.message;
                //     },
                //     itemBuilder: (context, dynamic suggestion) {
                //       return ListTile(
                //         title: Text(suggestion.name + ", " + suggestion.email),
                //       );
                //     },
                //     onSuggestionSelected: (dynamic suggestion) {
                //       searchCtrl.clear();
                //       setState(() {
                //         users.add(suggestion);
                //       });
                //     }),
                Autocomplete<UserLeague>(
                  key: _formKey,
                  displayStringForOption: ((option) =>
                      option.name + ", " + option.email),
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                    searchCtrl = controller;
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onEditingComplete: onEditingComplete,
                    );
                  },
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    print("Typing..." + textEditingValue.text);
                    if (textEditingValue.text == '' ||
                        textEditingValue.text.length <= 2) {
                      return const Iterable<UserLeague>.empty();
                    }
                    LoadingHelper.show();
                    CustomMessageResponse res =
                        await GetUserService.searchUser(textEditingValue.text);
                    LoadingHelper.hide();

                    if (!res.success || res.message.isEmpty) {
                      if (!res.success) ToastHelper.showError(res.message);
                      return const Iterable<UserLeague>.empty();
                    }

                    return res.message;
                  },
                  onSelected: (UserLeague selection) {
                    searchCtrl.clear();
                    // searchCtrl.text = "";
                    setState(() {
                      users.add(selection);
                    });
                    print("_formKey.currentWidget");
                    print(_formKey.currentWidget);
                  },
                ),
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
                                    color: Color.fromARGB(255, 75, 73, 73)),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(user.email),
                                  Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.end,
                                      children: [
                                        IconButton(
                                            tooltip: "Remover Participante",
                                            onPressed: () async {
                                              showAlertConfirmDialog(context,
                                                  () async {
                                                setState(() => {
                                                      users.removeWhere(
                                                          (element) =>
                                                              element.id ==
                                                              user.id)
                                                    });
                                              });
                                            },
                                            icon: const Icon(Icons.delete)),
                                      ])
                                ],
                              )));
                    })
              ],
            )),
            actions: <Widget>[
              TextButton(
                child: const Text('FECHAR'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: const Text('CONFIRMAR'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
      });
}

Future<CustomMessageResponse> addUser(
    League league, List<UserLeague> users) async {
  LoadingHelper.show();
  CustomMessageResponse message =
      await UpdateLeaguesService.updateLeagueAddUser(
          league.id, users.map((e) => e.id).toList());
  LoadingHelper.hide();

  if (!message.success) ToastHelper.showError(message.message);
  return message;
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
    title: const Text("AlertDialog"),
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
