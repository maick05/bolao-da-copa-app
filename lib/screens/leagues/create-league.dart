import 'package:bolao_da_copa/helper/local-storage.helper.dart';
import 'package:bolao_da_copa/helper/toast.helper.dart';
import 'package:bolao_da_copa/model/league.model.dart';
import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';
import 'package:bolao_da_copa/services/leagues/create-league.service.dart';
import 'package:bolao_da_copa/services/users/get-user.service.dart';
import 'package:bolao_da_copa/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import '../../components/add-users-league.dart';
import '../../helper/loading.helper.dart';
import '../../model/response/user-league-reponse.model.dart';

class CreateLeague extends StatefulWidget {
  const CreateLeague({Key? key}) : super(key: key);

  @override
  _CreateLeagueState createState() => _CreateLeagueState();
}

class _CreateLeagueState extends State<CreateLeague>
    with AfterLayoutMixin<CreateLeague> {
  late final int _userId;
  List<int> _userIds = [];
  List<UserLeague> _users = [];

  final TextEditingController _nameCtrl = TextEditingController();

  @override
  void afterFirstLayout(BuildContext context) async {
    _userId = await LocalStorageHelper.getValue<int>("userId");
    CustomMessageResponse userRes = await GetUserService.getById(_userId);
    print(userRes.message);
    setState(() {
      _userIds = [_userId];
      _users = [userRes.message];
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
                appBar: AppBar(
                  title: const Text('Criar Liga'),
                  backgroundColor: ColorTheme,
                ),
                resizeToAvoidBottomInset: false,
                body: SingleChildScrollView(
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
                                        labelStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorTheme),
                                      onPressed: () async {
                                        League league = League();
                                        league.idUserAdm = _userId;
                                        league.userIds = _userIds;
                                        await addUsersLeague(
                                            context, league, _users, _userId,
                                            (League league,
                                                List<UserLeague> usersAdd) {
                                          setState(() {
                                            _userIds = usersAdd
                                                .map((e) => e.id)
                                                .toList();
                                            _userIds.add(_userId);
                                          });
                                        }, (League league, int idUser) async {
                                          league.userIds.removeWhere(
                                              (element) => element == idUser);
                                        });
                                      },
                                      icon: const Icon(Icons.person_add),
                                      label: const Text("Add Participantes"),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorTheme),
                                      onPressed: () async {
                                        LoadingHelper.show();
                                        CustomMessageResponse res =
                                            await createLeague(
                                                _nameCtrl.text, _users);
                                        LoadingHelper.hide();

                                        if (!res.success) {
                                          ToastHelper.showError(res.message);
                                          return;
                                        }

                                        ToastHelper.showSuccess(res.message);

                                        Navigator.pop(context, true);
                                      },
                                      label: const Text("Salvar"),
                                      icon: const Icon(Icons.save),
                                    )),
                              ],
                            )
                          ],
                        ))))));
  }
}

Future<CustomMessageResponse> createLeague(
    String name, List<UserLeague> users) async {
  LoadingHelper.show();
  CustomMessageResponse message = await CreateLeagueService.createLeague(
      name, users.map((e) => e.id).toList());
  LoadingHelper.hide();

  if (!message.success) ToastHelper.showError(message.message);
  return message;
}
