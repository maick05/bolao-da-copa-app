// ignore_for_file: avoid_print, must_be_immutable

import 'package:bolao_da_copa/helper/date.helper.dart';
import 'package:bolao_da_copa/model/match.model.dart';
import 'package:bolao_da_copa/model/response/actual-round.model.dart';
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
  final List<String> _rounds = ["Round 1", "Round 2"];
  dynamic selectedMatchType = 1;

  @override
  void afterFirstLayout(BuildContext context) async {
    ActualRound round = await loadRounds();
    setState(() {
      widget._itensPlayed = round.matchesPlayed;
      widget._itensNext = round.nextMatches;
      widget._itens = round.nextMatches;
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
                  child: DropdownButton<String>(
                    value: "Round 1",
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        // dropdownValue = value!;
                      });
                    },
                    items:
                        _rounds.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )),
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
