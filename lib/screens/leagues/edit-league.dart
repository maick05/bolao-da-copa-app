import 'package:bolao_da_copa/helper/local-storage.helper.dart';
import 'package:bolao_da_copa/helper/toast.helper.dart';
import 'package:bolao_da_copa/model/league.model.dart';
import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';
import 'package:bolao_da_copa/services/leagues/get-leagues.service.dart';
import 'package:bolao_da_copa/services/leagues/update-leagues.service.dart';
import 'package:bolao_da_copa/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/services.dart';
import '../../components/add-users-league.dart';
import '../../components/show-users-league.dart';
import '../../helper/loading.helper.dart';
import '../../model/response/user-league-reponse.model.dart';

class EditLeague extends StatefulWidget {
  final int idLeague;

  const EditLeague({Key? key, required this.idLeague}) : super(key: key);

  @override
  _EditLeagueState createState() => _EditLeagueState();
}

class _EditLeagueState extends State<EditLeague>
    with AfterLayoutMixin<EditLeague> {
  League _league = League();
  late final int _userId;
  bool _isUserAdm = false;
  final List<UserLeague> _usersToAdd = [];

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _exactlyMatchCtrl = TextEditingController();
  final TextEditingController _winnerCtrl = TextEditingController();
  final TextEditingController _oneScoreCtrl = TextEditingController();
  final TextEditingController _penaltWinnerCtrl = TextEditingController();

  @override
  void afterFirstLayout(BuildContext context) async {
    _userId = await LocalStorageHelper.getValue<int>("userId");
    await loadPage(widget.idLeague);
  }

  Future<void> loadPage(idLeague) async {
    LoadingHelper.show();

    League league = await getLeagueById(idLeague);

    setState(() {
      _league = league;
      _isUserAdm = _userId == league.idUserAdm;

      _nameCtrl.text = _league.name;
      _exactlyMatchCtrl.text = _league.rules.exactlyMatch.toString();
      _winnerCtrl.text = _league.rules.winner.toString();
      _oneScoreCtrl.text = _league.rules.oneScore.toString();
      _penaltWinnerCtrl.text = _league.rules.penaltWinner.toString();
    });

    LoadingHelper.hide();
  }

  Future<void> setUsersAdd(user) async {
    setState(() {
      _usersToAdd.add(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SingleChildScrollView(
                    child: RefreshIndicator(
                        onRefresh: () async {
                          loadPage(widget.idLeague);
                        },
                        child: Container(
                            margin: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _nameCtrl,
                                        decoration: InputDecoration(
                                            labelText: "Nome",
                                            labelStyle: TextStyle(
                                                color: Colors.grey[400])),
                                        readOnly: !_isUserAdm,
                                        enabled: _isUserAdm,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Padding(
                                        padding:
                                            EdgeInsets.only(top: 17, bottom: 5),
                                        child: Text(
                                          "Regras",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 60,
                                  child: TextFormField(
                                      controller: _exactlyMatchCtrl,
                                      decoration: InputDecoration(
                                          labelText: "Placar Exato",
                                          labelStyle: TextStyle(
                                              color: Colors.grey[400])),
                                      readOnly: !_isUserAdm,
                                      enabled: _isUserAdm,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ]),
                                ),
                                SizedBox(
                                  height: 60,
                                  child: TextFormField(
                                      controller: _winnerCtrl,
                                      decoration: InputDecoration(
                                          labelText: "Vencedor ou Empate",
                                          labelStyle: TextStyle(
                                              color: Colors.grey[400])),
                                      readOnly: !_isUserAdm,
                                      enabled: _isUserAdm,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ]),
                                ),
                                SizedBox(
                                  height: 60,
                                  child: TextFormField(
                                      controller: _oneScoreCtrl,
                                      decoration: InputDecoration(
                                          labelText: "Nº de Gols de um Time",
                                          labelStyle: TextStyle(
                                              color: Colors.grey[400])),
                                      readOnly: !_isUserAdm,
                                      enabled: _isUserAdm,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ]),
                                ),
                                SizedBox(
                                    height: 60,
                                    child: TextFormField(
                                      controller: _penaltWinnerCtrl,
                                      decoration: InputDecoration(
                                          labelText:
                                              "Vencedor de Disputa de Pênaltis",
                                          labelStyle: TextStyle(
                                              color: Colors.grey[400])),
                                      readOnly: !_isUserAdm,
                                      enabled: _isUserAdm,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorTheme),
                                          onPressed: () async {
                                            await ShowUsersLeague(
                                                context,
                                                _league,
                                                _league.users,
                                                _userId, () {
                                              loadPage(_league.id);
                                            });
                                          },
                                          icon: const Icon(Icons.people),
                                          label: const Text("Participantes"),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorTheme),
                                          onPressed: () async {
                                            await AddUsersLeague(
                                                context, _league, setUsersAdd);
                                          },
                                          icon: const Icon(Icons.person_add),
                                          label: const Text("Add"),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorTheme),
                                          onPressed: () async {
                                            LoadingHelper.show();
                                            CustomMessageResponse res =
                                                await updateLeague(
                                                    _league.id,
                                                    _nameCtrl.text,
                                                    _exactlyMatchCtrl.text,
                                                    _winnerCtrl.text,
                                                    _oneScoreCtrl.text,
                                                    _penaltWinnerCtrl.text);
                                            LoadingHelper.hide();
                                            ToastHelper.showSuccess(
                                                res.message);
                                          },
                                          child: const Text("Salvar"),
                                        )),
                                  ],
                                )
                              ],
                            )))))));
  }
}

getLeagueById(int idLeague) async {
  CustomMessageResponse res = await GetLeaguesService.getLeagueById(idLeague);
  return res.message;
}

updateLeague(id, name, exactlyMatch, winner, oneScore, penaltWinner) async {
  Rule rules = Rule();

  rules.exactlyMatch = int.parse(exactlyMatch);
  rules.winner = int.parse(winner);
  rules.oneScore = int.parse(oneScore);
  rules.penaltWinner = int.parse(penaltWinner);
  return UpdateLeaguesService.updateLeague(id, name, rules);
}
