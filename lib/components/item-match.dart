import 'package:bolao_da_copa/helper/loading.helper.dart';
import 'package:bolao_da_copa/helper/toast.helper.dart';
import 'package:bolao_da_copa/screens/make-bet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/date.helper.dart';
import '../model/match.model.dart';
import '../services/bets/make-bet.service.dart';

class ItemMatch extends StatelessWidget {
  final RoundMatch _match;
  final int _idRound;
  late bool list;

  ItemMatch(this._match, this._idRound, {Key? key, this.list = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          getImgTeam(_match.teamHomeImg),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              getTeamTextScore(_match),
              style: const TextStyle(fontSize: 22),
            ),
          ),
          getImgTeam(_match.teamOutsideImg),
        ])),
        subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: getSubtitleItem(_match, _idRound, context, list)),
      ),
    );
  }
}

getTeamTextScore(RoundMatch match) {
  if (match.scoreHome > -1 && match.scoreOutside > -1) {
    return match.teamHomeCode +
        " " +
        match.scoreHome.toString() +
        " X " +
        match.scoreOutside.toString() +
        " " +
        match.teamOutsideCode;
  } else {
    return match.teamHomeCode + " X " + match.teamOutsideCode;
  }
}

List<Widget> getSubtitleItem(
    RoundMatch match, int idRound, context, bool list) {
  List<Widget> arrRow = [];
  arrRow.add(Text(DateHelper.formatDateTime(match.date)));

  if (!list) return arrRow;

  late String textButton;
  late IconData icon;

  if (match.isAlreadyPlayed()) {
    textButton = "Ver Palpites";
    icon = Icons.arrow_back;
  } else {
    textButton = "Palpitar";
    icon = Icons.arrow_back;
  }

  arrRow.add(Directionality(
    textDirection: TextDirection.rtl,
    child: TextButton.icon(
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MakeBet(match: match, idRound: idRound),
            ))
      },
      icon: Icon(icon),
      label: Text(textButton),
    ),
  ));

  return arrRow;
}

class ItemBetMatch extends StatelessWidget {
  final RoundMatch _match;
  final Bet _bet;
  final String _title;
  final bool _user;
  final int _idRound;
  final _callbackDialog;

  const ItemBetMatch(
    this._match,
    this._bet,
    this._idRound,
    this._title,
    this._user,
    this._callbackDialog, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const WidgetSpan(child: Icon(Icons.person)),
                      const WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                        ),
                      ),
                      TextSpan(
                          text: _title,
                          style: const TextStyle(
                            color: Color(0xff4c505b),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ))
                    ],
                  ),
                )),
            title: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getChildrenRow(_match, _bet, _user))),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: getSubtitle(_bet, context, _match, _idRound, _user,
                        _callbackDialog))
              ],
            )));
  }
}

getSubtitle(
    Bet bet, context, RoundMatch match, int idRound, bool user, callback) {
  if (match.isAlreadyPlayed()) return const Text("");

  if (user) return getSubtitleMyBet(bet, context, match, idRound, callback);

  return const Text("");
}

getSubtitleMyBet(Bet bet, context, RoundMatch match, int idRound, callback) {
  return TextButton.icon(
    onPressed: () => {
      _displayTextInputDialog(context, match, idRound, bet.idUser, callback)
    },
    icon: Icon(
      bet.scoreHome > -1 ? Icons.edit : Icons.add,
      size: 15,
    ),
    label: Text(
      bet.scoreHome > -1 ? "Atualizar Palpite" : "Fazer Palpite",
      style: const TextStyle(fontSize: 12),
    ),
  );
}

List<Widget> getChildrenRow(RoundMatch match, Bet bet, bool user) {
  List<Widget> arrRow = [];

  arrRow.add(getImgTeam(match.teamHomeImg, size: 35));

  List<Widget> arrItemBet =
      user ? getMyBetScore(match, bet) : getBetScore(match, bet);
  for (var element in arrItemBet) {
    arrRow.add(element);
  }
  arrRow.add(getImgTeam(match.teamOutsideImg, size: 35));

  return arrRow;
}

getImgTeam(String img, {double size = 65}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Image(
        image: NetworkImage(img), width: size, height: size, fit: BoxFit.fill),
  );
}

getBetScore(RoundMatch match, Bet bet) {
  return Text(
    getTextBetScore(match, bet),
    style: const TextStyle(fontSize: 15),
  );
}

getTextBetScore(RoundMatch match, Bet bet) {
  return
      // match.teamHomeCode +
      " " + bet.scoreHome.toString() + " X " + bet.scoreOutside.toString() + " "
      // + match.teamOutsideCode
      ;
}

getMyBetScore(RoundMatch match, Bet bet) {
  return [
    Text(getTextBetScore(match, bet)),
  ];
}

Future<void> _displayTextInputDialog(BuildContext context, RoundMatch match,
    int idRound, int idUser, callbackDialog) async {
  final _scoreHomeController = TextEditingController();
  final _scoreOutsideController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Digite o Placar'),
          content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: TextField(
                      controller: _scoreHomeController,
                      decoration: InputDecoration(
                          labelText: match.teamHome,
                          labelStyle: TextStyle(color: Colors.grey[400])),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  // optional flex property if flex is 1 because the default flex is 1
                  flex: 1,
                  child: TextField(
                      controller: _scoreOutsideController,
                      decoration: InputDecoration(
                          labelText: match.teamOutside,
                          labelStyle: TextStyle(color: Colors.grey[400])),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                ),
              ]),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('CONFIRMAR'),
              onPressed: () async {
                LoadingHelper.show();
                var res = await MakeBetService.makeBet(
                    idUser,
                    idRound,
                    match.idTeamHome,
                    match.idTeamOutside,
                    int.parse(_scoreHomeController.text),
                    int.parse(_scoreOutsideController.text));

                LoadingHelper.hide();

                if (!res.success) {
                  ToastHelper.showError("Erro: " + res.message);
                  return;
                }

                await ToastHelper.show("Palpite criado com sucesso!");

                Navigator.pop(context, true);

                callbackDialog();
              },
            ),
          ],
        );
      });
}
