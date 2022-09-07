import 'package:bolao_da_copa/model/match.model.dart';
import 'package:bolao_da_copa/model/response/actual-round.model.dart';
import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';
import 'package:bolao_da_copa/services/rounds/get-rounds.service.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../components/item-match.dart';
import '../helper/loading.helper.dart';
import '../helper/toast.helper.dart';

RoundCompetition firstRound() {
  var round = RoundCompetition();
  round.id = -1;
  return round;
}

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
  RoundCompetition? _selectedRound = firstRound();

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await loadPage(true);
  }

  Future<void> loadPage(bool first, {int selectedRound = 1}) async {
    setState(() {
      _rounds = [];
    });

    ActualRound round =
        first ? await loadRounds() : await getMatchesRound(_selectedRound!.id);
    List<RoundCompetition> rounds = await getDBRounds();

    setState(() {
      if (rounds.length > _rounds.length) {
        _rounds = rounds;
      }
    });

    await setItens(
        round, rounds.firstWhere((element) => element.id == round.idRound));
  }

  setItens(ActualRound round, RoundCompetition selectedRound) {
    setState(() {
      _selectedRound = selectedRound;
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
                            LoadingHelper.show();
                            ActualRound roundsById =
                                await getMatchesRound(newVal.id);

                            setItens(roundsById, newVal);

                            LoadingHelper.hide();
                          },
                          value: _selectedRound,
                        ))),
                  ]),
                  Expanded(
                      child: SizedBox(
                          child: buildList(widget._itens, _selectedRound!.id)))
                ]))));
  }
}

buildList(List<RoundMatch> itens, idRound) {
  if (itens.isNotEmpty) {
    return ListView.builder(
        itemCount: itens.length,
        itemBuilder: (context, indice) {
          final match = itens[indice];
          return ItemMatch(match, idRound);
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
  LoadingHelper.show();
  var response = await GetRoundsService.getActualRound();
  LoadingHelper.hide();

  if (!response.success) {
    ToastHelper.showError(response.message);
    return ActualRound();
  }

  ActualRound data = response.message;
  return data;
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
  return res.message;
}
