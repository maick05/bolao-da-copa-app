import 'package:bolao_da_copa/helper/loading.helper.dart';
import 'package:bolao_da_copa/helper/toast.helper.dart';
import 'package:bolao_da_copa/services/leagues/update-leagues.service.dart';
import 'package:flutter/material.dart';

import '../model/league.model.dart';
import '../model/response/custom-reponse.model.dart';
import '../model/response/user-league-reponse.model.dart';

Future<void> ShowUsersLeague(BuildContext context, League league,
    List<UserLeague> users, int idUser, callbackDialog) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(5),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          title: const Text('Participantes da Liga'),
          content: SingleChildScrollView(
              child: Column(
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
                                  color: Color.fromARGB(255, 75, 73, 73)),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              var res = await removeUser(
                                                  league, user.id);
                                              if (!res.success) return;

                                              Navigator.pop(context, true);

                                              await callbackDialog();
                                              await ToastHelper.showSuccess(
                                                  res.message);
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
          ],
        );
      });
}

Future<CustomMessageResponse> removeUser(League league, int idUser) async {
  LoadingHelper.show();
  CustomMessageResponse message =
      await UpdateLeaguesService.updateLeagueRemoveUser(league.id, idUser);
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
