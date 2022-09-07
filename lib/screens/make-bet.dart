import 'package:after_layout/after_layout.dart';
import 'package:bolao_da_copa/helper/loading.helper.dart';
import 'package:bolao_da_copa/helper/local-storage.helper.dart';
import 'package:bolao_da_copa/model/match.model.dart';
import 'package:bolao_da_copa/services/bets/get-bets.service.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../components/item-match.dart';

class MakeBet extends StatefulWidget {
  final RoundMatch match;
  final int idRound;

  const MakeBet({Key? key, required this.match, required this.idRound})
      : super(key: key);

  @override
  _MakeBet createState() => _MakeBet();
}

class _MakeBet extends State<MakeBet> with AfterLayoutMixin<MakeBet> {
  List<Bet> _bets = [];
  List<Bet> _betsUser = [];
  int _userId = 0;

  @override
  void afterFirstLayout(BuildContext context) async {
    await loadPage();
  }

  Future<void> loadPage() async {
    LoadingHelper.show();
    List<Bet> betsMatch = await getBets(
        widget.idRound, widget.match.idTeamHome, widget.match.idTeamOutside, 1);
    _userId = await LocalStorageHelper.getValue<int>("userId");

    setState(() {
      _bets = betsMatch;
      Bet? betFindUser =
          betsMatch.firstWhereOrNull((element) => element.idUser == _userId);
      _betsUser = betFindUser != null ? [betFindUser] : [];
    });

    LoadingHelper.hide();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
                body: RefreshIndicator(
                    onRefresh: () async => {await loadPage()},
                    child: SingleChildScrollView(
                      child: Column(
                          children: getBetsRows(
                              widget, _betsUser, _bets, _userId, loadPage)),
                    )))));
  }
}

getItemMatch(widget) {
  return ItemMatch(
    widget.match,
    widget.idRound,
    list: false,
  );
}

getBetsRows(widget, List<Bet> betsUser, List<Bet> bets, int userId, callback) {
  List<Widget> arrRow = [];
  arrRow.add(getItemMatch(widget));
  betsUser.isNotEmpty
      ? arrRow.add(getMyBet(widget, betsUser, widget.idRound, callback))
      : arrRow.add(getEmptyBet(widget, userId, widget.idRound, callback));

  if (bets.isNotEmpty) {
    // arrRow.add(null);
  }

  return arrRow;
}

getMyBet(widget, List<Bet> betsUser, int idRound, callback) {
  return ItemBetMatch(
      widget.match, betsUser[0], idRound, "Meu Palpite", true, callback);
}

getEmptyBet(widget, userId, int idRound, callback) {
  Bet bet = Bet();
  bet.scoreHome = -1;
  bet.scoreOutside = -1;
  bet.idUser = userId;
  return ItemBetMatch(
      widget.match, bet, idRound, "Meu Palpite", true, callback);
}

Future<List<Bet>> getBets(
    int idRound, int idTeamHome, int idTeamOutside, int idLeague) async {
  var res = await GetBetsService.getMatchesByRound(
      idRound, idTeamHome, idTeamOutside, idLeague);

  return res.message;
}
