import 'package:after_layout/after_layout.dart';
import 'package:bolao_da_copa/helper/loading.helper.dart';
import 'package:bolao_da_copa/helper/local-storage.helper.dart';
import 'package:bolao_da_copa/model/league.model.dart';
import 'package:bolao_da_copa/model/match.model.dart';
import 'package:bolao_da_copa/services/bets/get-bets.service.dart';
import 'package:bolao_da_copa/services/leagues/get-leagues.service.dart';
import 'package:flutter/material.dart';
import '../../components/item-match.dart';
import '../../components/list-bet.dart';
import 'package:collection/collection.dart';

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
  League? _selectedLeague;
  List<League> _leagues = [];
  int _userId = 0;

  @override
  void afterFirstLayout(BuildContext context) async {
    await loadPage();
  }

  Future<void> loadPage() async {
    LoadingHelper.show();

    _userId = await LocalStorageHelper.getValue<int>("userId");

    List<League> leagues = await getLeagues(_userId);

    setState(() {
      _leagues = leagues;
      _selectedLeague = leagues.isNotEmpty ? leagues[0] : null;
    });

    if (leagues.isEmpty) {
      return;
    }

    List<Bet> betsMatch = await getBets(widget.idRound, widget.match.idTeamHome,
        widget.match.idTeamOutside, leagues[0].id);

    setState(() {
      _bets = betsMatch.where((element) => element.idUser != _userId).toList();
      Bet? betFindUser =
          betsMatch.firstWhereOrNull((element) => element.idUser == _userId);
      _betsUser = betFindUser != null ? [betFindUser] : [];
    });

    LoadingHelper.hide();
  }

  Future<void> setLeague(League league) async {
    List<Bet> betsMatch = await getBets(widget.idRound, widget.match.idTeamHome,
        widget.match.idTeamOutside, league.id);
    setState(() {
      LoadingHelper.show();
      _selectedLeague = league;
      _bets = betsMatch.where((element) => element.idUser != _userId).toList();
      LoadingHelper.hide();
    });
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
                              widget,
                              _selectedLeague,
                              _betsUser,
                              _bets,
                              _userId,
                              _leagues,
                              loadPage,
                              setLeague)),
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

getBetsRows(widget, selectedLeague, List<Bet> betsUser, List<Bet> bets,
    int userId, List<League> leagues, callbackDiialog, callbackSelector) {
  List<Widget> arrRow = [];
  arrRow.add(getItemMatch(widget));
  betsUser.isNotEmpty
      ? arrRow.add(getMyBet(widget, betsUser, widget.idRound, callbackDiialog))
      : arrRow
          .add(getEmptyBet(widget, userId, widget.idRound, callbackDiialog));

  if (widget.match.isAlreadyPlayed() && leagues.isNotEmpty) {
    arrRow.add(buildListBet(selectedLeague, bets, widget.match, widget.idRound,
        leagues, callbackSelector));
  }

  if (leagues.isEmpty) {
    arrRow.add(const Padding(
      padding: EdgeInsets.all(15.0),
      child: Text(
        "Você não está participando de nenhuma Liga!",
        style: TextStyle(color: Color(0xFF696969)),
      ),
    ));
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
  return res.message.isNotEmpty ? res.message : [];
}

Future<List<League>> getLeagues(int idUser) async {
  var res = await GetLeaguesService.getLeaguesByUser(idUser);
  return res.message.isNotEmpty ? res.message : [];
}
