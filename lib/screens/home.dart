import 'package:flutter/material.dart';

void main() {
  runApp(const HomeTabBar());
}

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.calendar_month)),
                Tab(icon: Icon(Icons.group)),
                Tab(icon: Icon(Icons.star)),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.calendar_month),
              Icon(Icons.group),
              Icon(Icons.star),
            ],
          ),
        ),
      ),
    );
  }
}
