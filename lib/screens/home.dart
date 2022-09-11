import 'package:bolao_da_copa/screens/rounds/rounds.dart';
import 'package:bolao_da_copa/screens/user/logout.dart';
import 'package:bolao_da_copa/screens/user/my-profile.dart';
import 'package:flutter/material.dart';

import '../style/theme.dart';
import 'leagues/classification.dart';
import 'leagues/my-leagues.dart';

void main() {
  runApp(const HomeTabBar());
}

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        color: ColorTheme,
      )),
      home: DefaultTabController(
          length: 3,
          child: WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  indicatorColor: ColorTheme,
                  tabs: [
                    Tab(icon: Icon(Icons.calendar_month)),
                    Tab(icon: Icon(Icons.workspace_premium)),
                    Tab(icon: Icon(Icons.group)),
                  ],
                ),
                title: const Text('Bolão da Copa'),
                actions: [
                  PopupMenuButton(
                      // add icon, by default "3 dot" icon
                      // icon: Icon(Icons.book)
                      itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("Minha Conta"),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text("Sair"),
                      ),
                    ];
                  }, onSelected: (value) {
                    if (value == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyProfile(),
                          ));
                    } else if (value == 1) {
                      logout(context);
                    }
                  }),
                ],
              ),
              body: TabBarView(
                children: [
                  Rounds(),
                  const Classification(),
                  const MyLeagues(),
                ],
              ),
            ),
          )),
    );
  }
}
