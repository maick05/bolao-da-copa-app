// ignore_for_file: avoid_print, must_be_immutable

import 'package:bolao_da_copa/helper/date.helper.dart';
import 'package:bolao_da_copa/model/match.model.dart';
import 'package:bolao_da_copa/model/response/actual-round.model.dart';
import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';
import 'package:bolao_da_copa/services/rounds/get-rounds.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:after_layout/after_layout.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Rounds extends StatefulWidget {
  Rounds({Key? key}) : super(key: key);

  List<RoundMatch> _itens = [];
  List<RoundMatch> _itensPlayed = [];
  List<RoundMatch> _itensNext = [];

  @override
  _RoundsState createState() => _RoundsState();
}

class _RoundsState extends State<Rounds> with AfterLayoutMixin<Rounds> {
  List<RoundCompetition> _rounds = [];
  dynamic selectedMatchType = 1;
  RoundCompetition? _selectedRound;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    List<RoundCompetition> rounds = await getDBRounds();
    setState(() {
      _rounds = rounds;
    });
    await loadPage(true);
  }

  Future<void> loadPage(bool first) async {
    print("loading page...");
    print(first);
    ActualRound round =
        first ? await loadRounds() : await getMatchesRound(_selectedRound!.id);

    setItens(round);

    setState(() {
      _selectedRound =
          _rounds.firstWhere((element) => element.id == round.idRound);
    });
  }

  setItens(ActualRound round) {
    setState(() {
      widget._itens = [];
      widget._itensNext = round.nextMatches;
      widget._itensPlayed = round.matchesPlayed;
      if (round.matchesPlayed.isNotEmpty) {
        selectedMatchType = 0;
        widget._itens = round.matchesPlayed;
      }
      if (round.nextMatches.isNotEmpty) {
        selectedMatchType = 1;
        widget._itens = round.nextMatches;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: RefreshIndicator(
                onRefresh: () async => {loadPage(false)},
                child: Column(children: [
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ToggleSwitch(
                        activeBgColor: const [Color(0xFF8D1B3D)],
                        minWidth: 100,
                        initialLabelIndex: selectedMatchType,
                        totalSwitches: 2,
                        labels: const ["Já Jogadas", "Próximas"],
                        onToggle: (index) {
                          setState(() {
                            selectedMatchType = index;
                          });

                          if (index == 1) {
                            setState(() {
                              widget._itens = widget._itensNext;
                            });
                          } else {
                            setState(() {
                              widget._itens = widget._itensPlayed;
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                            child: DropdownButton<RoundCompetition>(
                          items: _rounds.map((item) {
                            return DropdownMenuItem<RoundCompetition>(
                              child: Text(item.name),
                              value: item,
                            );
                          }).toList(),
                          onChanged: (newVal) async {
                            if (newVal == null) {
                              return;
                            }

                            EasyLoading.show(status: "Carregando...");
                            ActualRound roundsById =
                                await getMatchesRound(newVal.id);
                            setState(() {
                              _selectedRound = newVal;
                              setItens(roundsById);
                            });
                            EasyLoading.dismiss();
                          },
                          value: _selectedRound,
                        ))),
                  ]),
                  Expanded(child: SizedBox(child: buildList(widget._itens)))
                ]))));
  }
}

buildList(List<RoundMatch> itens) {
  if (itens.isNotEmpty) {
    return ListView.builder(
        itemCount: itens.length,
        itemBuilder: (context, indice) {
          final match = itens[indice];
          return ItemMatch(match);
        });
  } else {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Text(
        "Não Há partidas para serem mostradas!",
        style: TextStyle(color: Color(0xFF696969)),
      ),
    );
  }
}

Future<ActualRound> loadRounds() async {
  EasyLoading.show(status: 'Carregando...');
  var response = await GetRoundsService.getActualRound();
  EasyLoading.dismiss();

  if (!response.success) {
    EasyLoading.showError(response.message);
    return ActualRound();
  }

  ActualRound data = response.message;
  return data;
}

class ItemMatch extends StatelessWidget {
  final RoundMatch _match;

  const ItemMatch(this._match, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image(
                image: NetworkImage(_match.teamHomeImg),
                width: 65,
                height: 65,
                fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              getTeamTextScore(_match),
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image(
                image: NetworkImage(_match.teamOutsideImg),
                width: 65,
                height: 65,
                fit: BoxFit.fill),
          ),
        ])),
        subtitle: Text(DateHelper.formatDateTime(_match.date)),
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

// getRounds() async {
//   return LocalStorageHelper.getValueIfNotExists("rounds", getDBRounds());
// }

getDBRounds() async {
  CustomMessageResponse res = await GetRoundsService.getRounds();
  return res.message;
}

getMatchesRound(int id) async {
  CustomMessageResponse res = await GetRoundsService.getMatchesByRound(id);
  print("$id --> id");
  return res.message;
}
