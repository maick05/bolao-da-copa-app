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

firstRound() {
  RoundCompetition firstRound = RoundCompetition();
  firstRound.id = -1;
  firstRound.name = "1 R";
  return firstRound;
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
  RoundCompetition? _selectedRound;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    ActualRound round = await loadRounds();
    List<RoundCompetition> rounds = await getDBRounds();

    setState(() {
      widget._itensPlayed = round.matchesPlayed;
      widget._itensNext = round.nextMatches;
      widget._itens = round.nextMatches;
      _rounds = rounds;
      _selectedRound =
          _rounds.firstWhere((element) => element.id == round.idRound);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
        children: [
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
                    ActualRound roundsById = await getMatchesRound(newVal.id);
                    setState(() {
                      _selectedRound = newVal;
                      widget._itensNext = roundsById.nextMatches;
                      widget._itensPlayed = roundsById.matchesPlayed;
                      if (roundsById.matchesPlayed.isNotEmpty) {
                        widget._itens = roundsById.matchesPlayed;
                      }
                      if (roundsById.nextMatches.isNotEmpty) {
                        widget._itens = roundsById.nextMatches;
                      }
                    });
                    EasyLoading.dismiss();
                  },
                  value: _selectedRound,
                ))),
          ]),
          Expanded(
              child: SizedBox(
            child: ListView.builder(
                itemCount: widget._itens.length,
                itemBuilder: (context, indice) {
                  final match = widget._itens[indice];
                  return ItemMatch(match);
                }),
          ))
        ],
      )),
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
                width: 75,
                height: 75,
                fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              _match.teamHomeCode + " X " + _match.teamOutsideCode,
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image(
                image: NetworkImage(_match.teamOutsideImg),
                width: 75,
                height: 75,
                fit: BoxFit.fill),
          ),
        ])),
        subtitle: Text(DateHelper.formatDateTime(_match.date)),
      ),
    );
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
  return res.message;
}
