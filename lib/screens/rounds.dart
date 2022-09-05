// ignore_for_file: avoid_print, must_be_immutable

import 'package:bolao_da_copa/model/match.model.dart';
import 'package:bolao_da_copa/model/response/actual-round.model.dart';
import 'package:bolao_da_copa/services/rounds/get-rounds.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:after_layout/after_layout.dart';

class Rounds extends StatefulWidget {
  Rounds({Key? key}) : super(key: key);

  List<RoundMatch> _itens = [];

  @override
  _RoundsState createState() => _RoundsState();
}

class _RoundsState extends State<Rounds> with AfterLayoutMixin<Rounds> {
  @override
  void afterFirstLayout(BuildContext context) async {
    var rounds = await loadRounds();
    setState(() {
      widget._itens = rounds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
            itemCount: widget._itens.length,
            itemBuilder: (context, indice) {
              final match = widget._itens[indice];
              return ItemMatch(match);
            }),
      ),
    );
  }
}

Future<List<RoundMatch>> loadRounds() async {
  EasyLoading.show(status: 'Carregando...');
  var response = await GetRoundsService.getActualRound();
  EasyLoading.dismiss();

  if (!response.success) {
    EasyLoading.showError(response.message);
    return [];
  }

  ActualRound data = response.message;
  return data.matchesPlayed;
}

class ItemMatch extends StatelessWidget {
  final RoundMatch _match;

  const ItemMatch(this._match, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(_match.teamHomeCode + " X " + _match.teamOutsideCode),
        subtitle: Text("Group " + _match.idGroup),
      ),
    );
  }
}
