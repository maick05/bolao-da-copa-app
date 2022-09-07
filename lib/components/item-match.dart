import 'package:bolao_da_copa/screens/make-bet.dart';
import 'package:flutter/material.dart';
import '../helper/date.helper.dart';
import '../model/match.model.dart';

class ItemMatch extends StatelessWidget {
  final RoundMatch _match;
  late bool list;

  ItemMatch(this._match, {Key? key, this.list = true}) : super(key: key);

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
            children: getSubtitleItem(_match, context, list)),
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

List<Widget> getSubtitleItem(RoundMatch match, context, bool list) {
  List<Widget> arrRow = [];
  arrRow.add(Text(DateHelper.formatDateTime(match.date)));

  late String textButton;
  late IconData icon;

  if ((match.scoreHome > -1 && match.scoreOutside > -1) ||
      match.date.isBefore(DateTime.now())) {
    textButton = "Ver Palpites";
    icon = Icons.arrow_back;
  } else {
    textButton = "Palpitar";
    icon = Icons.arrow_back;
  }

  arrRow.add(Directionality(
    textDirection: TextDirection.rtl,
    child: TextButton.icon(
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MakeBet(
                match: match,
              ),
            ))
      },
      icon: Icon(icon),
      label: Text(textButton),
    ),
  ));

  return arrRow;
}
