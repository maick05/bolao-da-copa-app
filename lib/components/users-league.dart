// import 'package:flutter/material.dart';

// Future<void> _showUsersLeague(BuildContext context, UserLeague, int idRound,
//     int idUser, callbackDialog) async {
//   final _scoreHomeController = TextEditingController();
//   final _scoreOutsideController = TextEditingController();

//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Digite o Placar'),
//           content: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                       controller: _scoreHomeController,
//                       decoration: InputDecoration(
//                           labelText: match.teamHome,
//                           labelStyle: TextStyle(color: Colors.grey[400])),
//                       keyboardType: TextInputType.number,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.digitsOnly
//                       ]),
//                 ),
//                 const SizedBox(width: 10.0),
//                 Expanded(
//                   // optional flex property if flex is 1 because the default flex is 1
//                   flex: 1,
//                   child: TextField(
//                       controller: _scoreOutsideController,
//                       decoration: InputDecoration(
//                           labelText: match.teamOutside,
//                           labelStyle: TextStyle(color: Colors.grey[400])),
//                       keyboardType: TextInputType.number,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.digitsOnly
//                       ]),
//                 ),
//               ]),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('CANCELAR'),
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//             ),
//             TextButton(
//               child: const Text('CONFIRMAR'),
//               onPressed: () async {
//                 LoadingHelper.show();
//                 var res = await MakeBetService.makeBet(
//                     idUser,
//                     idRound,
//                     match.idTeamHome,
//                     match.idTeamOutside,
//                     int.parse(_scoreHomeController.text),
//                     int.parse(_scoreOutsideController.text));

//                 LoadingHelper.hide();

//                 if (!res.success) {
//                   ToastHelper.showError("Erro: " + res.message);
//                   return;
//                 }

//                 await ToastHelper.show("Palpite criado com sucesso!");

//                 Navigator.pop(context, true);

//                 callbackDialog();
//               },
//             ),
//           ],
//         );
//       });
// }
