import 'package:badges/badges.dart';
import 'package:bolao_da_copa/helper/local-storage.helper.dart';
import 'package:bolao_da_copa/model/league.model.dart';
import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';
import 'package:bolao_da_copa/model/response/user-league-reponse.model.dart';
import 'package:bolao_da_copa/services/classification/classification.service.dart';
import 'package:bolao_da_copa/services/leagues/get-leagues.service.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import '../../helper/loading.helper.dart';

class Classification extends StatefulWidget {
  const Classification({Key? key}) : super(key: key);

  @override
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification>
    with AfterLayoutMixin<Classification> {
  List<UserLeague> _users = [];
  List<League> _leagues = [];
  League? _selectedLeague;
  late final int _userId;

  @override
  void afterFirstLayout(BuildContext context) async {
    _userId = await LocalStorageHelper.getValue<int>("userId");
    await loadPage(true);
  }

  Future<void> loadPage(bool first, {int selectedLeague = 1}) async {
    LoadingHelper.show();
    setState(() {
      if (first) {
        _leagues = [];
      }
      _users = [];
    });

    List<League> leagues = first ? await getLeagues(_userId) : _leagues;
    int idSelected = first ? leagues[0].id : selectedLeague;
    List<UserLeague> users =
        leagues.isNotEmpty ? await getUsersClassification(idSelected) : [];

    setState(() {
      _leagues = leagues;
      if (leagues.isNotEmpty) {
        _users = users;
        _selectedLeague =
            leagues.firstWhere((element) => element.id == idSelected);
      }
    });
    LoadingHelper.hide();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Center(
                                child: DropdownButton<League>(
                              items: _leagues.map((item) {
                                return DropdownMenuItem<League>(
                                  child: Text(item.name),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (newVal) async {
                                if (newVal == null) {
                                  return;
                                }
                                await loadPage(false,
                                    selectedLeague: newVal.id);
                              },
                              value: _selectedLeague,
                            ))),
                      ],
                    ),
                    buildList(_users, _leagues)
                  ],
                ))));
  }
}

buildList(List<UserLeague> users, List<League> leagues) {
  if (leagues.isNotEmpty) {
    return Expanded(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
                columnSpacing: 30,
                columns: const <DataColumn>[
                  DataColumn(
                    tooltip: "Posição",
                    label: Expanded(
                      child: Text(
                        '#',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Nome',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    tooltip: "Pontuação",
                    label: Expanded(
                      child: Text(
                        'Pont.',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    tooltip: "Acerto de Placar",
                    label: Expanded(
                      child: Text(
                        'Placar',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    tooltip: "Acerto de Vencedor ou Empate",
                    label: Expanded(
                      child: Text(
                        'Venc.',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: users
                    .asMap()
                    .entries
                    .map((entry) => DataRow(cells: [
                          DataCell(SizedBox(
                              width: 30,
                              child: Badge(
                                badgeContent: Text(
                                  "#" + (entry.key + 1).toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                badgeColor: getColorBadge(entry.key + 1),
                              ))),
                          DataCell(SizedBox(
                              child: Text(
                            entry.value.user,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color.fromARGB(255, 75, 73, 73)),
                          ))),
                          DataCell(SizedBox(
                            width: 22,
                            child: Text(
                              entry.value.points.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.orange),
                            ),
                          )),
                          DataCell(Text(
                            entry.value.exactlyMatch.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.blue),
                          )),
                          DataCell(Text(
                            entry.value.winner.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.blue),
                          ))
                        ]))
                    .toList())));
  } else {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Text(
        "Você não está vinculado a nenhuma liga!",
        style: TextStyle(color: Color(0xFF696969)),
      ),
    );
  }
}

getColorBadge(pos) {
  switch (pos) {
    case 1:
      return Colors.green;
    case 2:
      return Colors.grey;
    case 3:
      return const Color.fromARGB(255, 233, 170, 75);
    default:
      return Colors.blue;
  }
}

getLeagues(int userId) async {
  CustomMessageResponse res = await GetLeaguesService.getLeaguesByUser(userId);
  return res.message;
}

getUsersClassification(int idLeague) async {
  CustomMessageResponse res =
      await ClassificationService.getClassificationByLeague(idLeague);
  return res.message;
}
