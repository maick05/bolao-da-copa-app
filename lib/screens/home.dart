import 'package:bolao_da_copa/screens/rounds.dart';
import 'package:flutter/material.dart';

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
        color: Color(0xFF8D1B3D),
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
                  indicatorColor: Color(0xFF8D1B3D),
                  tabs: [
                    Tab(icon: Icon(Icons.calendar_month)),
                    Tab(icon: Icon(Icons.group)),
                    Tab(icon: Icon(Icons.star)),
                  ],
                ),
                title: const Text('Bolão da Copa'),
              ),
              body: TabBarView(
                children: [
                  Rounds(),
                  const Icon(Icons.group),
                  const Icon(Icons.star),
                ],
              ),
            ),
          )),
    );
  }
}
