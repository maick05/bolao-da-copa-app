import 'package:after_layout/after_layout.dart';
import 'package:bolao_da_copa/model/match.model.dart';
import 'package:flutter/material.dart';

import '../components/item-match.dart';

class MakeBet extends StatefulWidget {
  final RoundMatch match;
  const MakeBet({Key? key, required this.match}) : super(key: key);

  @override
  _MakeBet createState() => _MakeBet();
}

class _MakeBet extends State<MakeBet> with AfterLayoutMixin<MakeBet> {
  @override
  void afterFirstLayout(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: WillPopScope(
            onWillPop: () async {
              print("pop");
              return false;
            },
            child: Scaffold(
                body: RefreshIndicator(
                    onRefresh: () async => {},
                    child: Column(children: [
                      ItemMatch(
                        widget.match,
                        list: false,
                      )
                    ])))));
  }
}
