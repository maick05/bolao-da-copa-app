import 'package:bolao_da_copa/components/item-match.dart';
import 'package:bolao_da_copa/model/match.model.dart';
import 'package:flutter/material.dart';

import '../helper/loading.helper.dart';
import '../model/league.model.dart';

buildListBet(List<Bet> itens, RoundMatch match, int idRound,
    List<League> leagues, callbackSelector) {
  League? selectedLeague = leagues.isNotEmpty ? leagues[0] : null;
  return Container(
      margin: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
      child: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 25),
                child: Text(
                  "Palpites",
                  style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 223, 125, 14),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Center(
                      child: DropdownButton<League>(
                    items: leagues.map((item) {
                      return DropdownMenuItem<League>(
                        child: Text(item.name),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (newVal) async {
                      if (newVal == null) {
                        return;
                      }
                      LoadingHelper.show();
                      callbackSelector(newVal);
                      selectedLeague = newVal;
                      LoadingHelper.hide();
                    },
                    value: selectedLeague,
                  ))),
            ],
          ),
          buildList(itens, match, idRound)
        ],
      ));
}

buildList(List<Bet> itens, RoundMatch match, idRound) {
  if (itens.isNotEmpty) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(1),
        shrinkWrap: true,
        itemCount: itens.length,
        itemBuilder: (context, indice) {
          final bet = itens[indice];
          return ItemBetMatch(match, bet, idRound, bet.user, false, () {});
        });
  } else {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Text(
        "Não Há palpites para essa partida!",
        style: TextStyle(color: Color(0xFF696969)),
      ),
    );
  }
}
