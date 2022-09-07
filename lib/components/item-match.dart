import 'package:flutter/material.dart';
import '../helper/date.helper.dart';
import '../model/match.model.dart';

class ItemMatch extends StatelessWidget {
  final RoundMatch _match;

  const ItemMatch(this._match, {Key? key, bool list = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image(
                image: NetworkImage(_match.teamHomeImg),
                width: 65,
                height: 65,
                fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              getTeamTextScore(_match),
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image(
                image: NetworkImage(_match.teamOutsideImg),
                width: 65,
                height: 65,
                fit: BoxFit.fill),
          ),
        ])),
        subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: getSubtitleItem(_match, context)),
      ),
    );
  }
}

getTeamTextScore(RoundMatch match) {
  if (match.scoreHome > -1 && match.scoreOutside > -1) {
    return match.teamHomeCode +
        " " +
        match.scoreHome.toString() +
        " X " +
        match.scoreOutside.toString() +
        " " +
        match.teamOutsideCode;
  } else {
    return match.teamHomeCode + " X " + match.teamOutsideCode;
  }
}

List<Widget> getSubtitleItem(RoundMatch match, context) {
  List<Widget> arrRow = [];
  arrRow.add(Text(DateHelper.formatDateTime(match.date)));

  if ((match.scoreHome > -1 && match.scoreOutside > -1) ||
      match.date.isBefore(DateTime.now())) {
    return arrRow;
  } else {
    arrRow.add(Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton.icon(
        onPressed: () => {
          // a
        },
        icon: const Icon(Icons.arrow_back),
        label: const Text("Palpitar"),
      ),
    ));
    return arrRow;
  }
}
