import 'package:bolao_da_copa/helper/local-storage.helper.dart';
import 'package:bolao_da_copa/model/league.model.dart';
import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';
import 'package:bolao_da_copa/screens/leagues/edit-league.dart';
import 'package:bolao_da_copa/services/leagues/get-leagues.service.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import '../../helper/loading.helper.dart';

class MyLeagues extends StatefulWidget {
  const MyLeagues({Key? key}) : super(key: key);

  @override
  _MyLeaguesState createState() => _MyLeaguesState();
}

class _MyLeaguesState extends State<MyLeagues>
    with AfterLayoutMixin<MyLeagues> {
  List<League> _leagues = [];
  int _userId = -1;

  @override
  void afterFirstLayout(BuildContext context) async {
    _userId = await LocalStorageHelper.getValue<int>("userId");
    await loadPage();
  }

  Future<void> loadPage() async {
    LoadingHelper.show();
    setState(() {
      _leagues = [];
    });

    List<League> leagues = await getLeagues(_userId);

    setState(() {
      _leagues = leagues;
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
                      children: const [
                        Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 10, right: 44),
                            child: Text("")),
                      ],
                    ),
                    buildList(_leagues, _userId)
                  ],
                ))));
  }
}

buildList(List<League> leagues, userId) {
  if (leagues.isNotEmpty) {
    return Expanded(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(1),
                shrinkWrap: true,
                itemCount: leagues.length,
                itemBuilder: (context, indice) {
                  final league = leagues[indice];
                  return Card(
                      child: ListTile(
                    title: Text(league.name),
                    subtitle: Row(children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Adm: " +
                                (league.idUserAdm == userId
                                    ? "Eu"
                                    : league.userAdm),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(league.userIds.length.toString() +
                              " Participantes")),
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: IconButton(
                          tooltip: userId == league.idUserAdm
                              ? "Editar Liga"
                              : "Ver Informações",
                          icon: Icon(userId == league.idUserAdm
                              ? Icons.edit
                              : Icons.info_outline),
                          color: userId == league.idUserAdm
                              ? Colors.orange
                              : Colors.blue,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditLeague(idLeague: league.id),
                                ));
                          },
                        ),
                      ),
                      if (userId == league.idUserAdm)
                        Padding(
                            padding: const EdgeInsets.all(1),
                            child: IconButton(
                              tooltip: "Deletar Liga",
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {},
                            ))
                    ]),
                  ));
                })));
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

getLeagues(int userId) async {
  CustomMessageResponse res = await GetLeaguesService.getLeaguesByUser(userId);
  return res.message;
}
