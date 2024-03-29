import 'package:flutter/material.dart';
import 'package:convida/app/shared/global/globals.dart';

class OrganizationWidget extends StatefulWidget {
  final String healthType;
  final String sportType;
  final String partyType;
  //final String onlineType;
  final String artType;
  final String faithType;
  final String studyType;
  final String othersType;
  final String dataType;

  OrganizationWidget(
      {Key key,
      @required this.healthType,
      @required this.sportType,
      @required this.partyType,
      //@required this.onlineType,
      @required this.artType,
      @required this.faithType,
      @required this.studyType,
      @required this.othersType,
      @required this.dataType})
      : super(key: key);

  @override
  _OrganizationWidgetState createState() => _OrganizationWidgetState(
      healthType,
      sportType,
      partyType,
      //onlineType,
      artType,
      faithType,
      studyType,
      othersType,
      dataType);
}

class _OrganizationWidgetState extends State<OrganizationWidget> {
  String healthType;
  String sportType;
  String partyType;
  //String onlineType;
  String artType;
  String faithType;
  String studyType;
  String othersType;
  String dataType;

  _OrganizationWidgetState(
      this.healthType,
      this.sportType,
      this.partyType,
      //this.onlineType,
      this.artType,
      this.faithType,
      this.studyType,
      this.othersType,
      this.dataType);

  Color healthColor = Colors.white;
  Color sportColor = Colors.white;
  Color partyColor = Colors.white;
  //Color onlineColor = Colors.white;
  Color artColor = Colors.white;
  Color faithColor = Colors.white;
  Color studyColor = Colors.white;
  Color othersColor = Colors.white;

  Color dayColor = Colors.white;
  Color weekColor = Colors.white;
  Color monthColor = Colors.white;

  @override
  void initState() {
    if (healthType == 'Saúde e Bem-estar') {
      healthColor = Colors.redAccent;
    }
    if (sportType == 'Esporte e Lazer') {
      sportColor = Colors.green;
    }
    if (partyType == 'Festas e Comemorações') {
      partyColor = Colors.deepPurpleAccent;
    }
    // if (onlineType == 'Online') {
    //   onlineColor = Colors.cyan;
    // }
    if (artType == 'Arte e Cultura') {
      artColor = Colors.pink;
    }
    if (faithType == 'Fé e Espiritualidade') {
      faithColor = Colors.yellow;
    }
    if (studyType == 'Acadêmico e Profissional') {
      studyColor = Colors.blueAccent;
    }
    if (othersType == 'Outros') {
      othersColor = Colors.orange;
    }
    if (dataType == 'week') {
      weekColor = Color(0xFF4c84cd);
    }
    if (dataType == 'day') {
      dayColor = Color(0xFF4c84cd);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        moveBack();
        return null;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Organização e Filtros")),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
              child: Container(
                child: Text(
                  "Tipo de eventos:",
                  style: TextStyle(
                      color: Color(primaryColor), //Color(secondaryColor),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ActionChip(
                      pressElevation: 2,
                      elevation: 2,
                      shadowColor: Colors.redAccent,
                      backgroundColor: healthColor,
                      label: Text('Saúde e Bem-estar',
                          style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        setState(() {
                          // if ((type != "X") && (healthColor == Colors.white)) {
                          //   type = "Saúde e Bem-estar";
                          //   healthColor = Colors.redAccent;

                          //   sportColor = Colors.white;

                          //   partyColor = Colors.white;

                          //   artColor = Colors.white;

                          //   studyColor = Colors.white;

                          //   othersColor = Colors.white;
                          // }
                          // switchColor(Color color){
                          //   // if (color == healthColor){
                          //   //   healthType == "X";
                          //   //   healthColor = Colors.white;
                          //   // } else {
                          //   //   health = "Saúde e Bem-estar";
                          //   //   healthType = healthName;
                          //   //   healthColor = color;
                          //   // }

                          // }
                          if (healthType == "Saúde e Bem-estar") {
                            healthType = "X";
                            healthColor = Colors.white;
                          } else {
                            healthType = "Saúde e Bem-estar";
                            healthColor = Colors.redAccent;
                          }
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ActionChip(
                      pressElevation: 2,
                      elevation: 2,
                      shadowColor: Colors.green,
                      backgroundColor: sportColor,
                      label: Text('Esporte e Lazer',
                          style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        setState(() {
                          // if ((type != "X") && (sportColor == Colors.white)) {
                          //   type = "Esporte e Lazer";

                          //   healthColor = Colors.white;

                          //   sportColor = Colors.green;

                          //   partyColor = Colors.white;

                          //   artColor = Colors.white;

                          //   studyColor = Colors.white;

                          //   othersColor = Colors.white;
                          // }

                          if (sportType == "Esporte e Lazer") {
                            sportType = "X";
                            sportColor = Colors.white;
                          } else {
                            sportType = "Esporte e Lazer";
                            sportColor = Colors.green;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ActionChip(
                      pressElevation: 2,
                      elevation: 2,
                      shadowColor: Colors.deepPurpleAccent,
                      backgroundColor: partyColor,
                      label: Text('Festas e Comemorações',
                          style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        setState(() {
                          // if ((type != "X") && (partyColor == Colors.white)) {
                          //   type = "Festas e Comemorações";

                          //   healthColor = Colors.white;

                          //   sportColor = Colors.white;

                          //   partyColor = Colors.deepPurpleAccent;

                          //   artColor = Colors.white;

                          //   studyColor = Colors.white;

                          //   othersColor = Colors.white;
                          // }
                          if (partyType == "Festas e Comemorações") {
                            partyType = "X";
                            partyColor = Colors.white;
                          } else {
                            partyType = "Festas e Comemorações";
                            partyColor = Colors.deepPurpleAccent;
                          }
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ActionChip(
                      pressElevation: 2,
                      elevation: 2,
                      shadowColor: Colors.pink,
                      backgroundColor: artColor,
                      label: Text('Arte e Cultura',
                          style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        setState(() {
                          if (artType == "Arte e Cultura") {
                            artType = "X";
                            artColor = Colors.white;
                          } else {
                            artType = "Arte e Cultura";
                            artColor = Colors.pink;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ActionChip(
                      pressElevation: 2,
                      elevation: 2,
                      shadowColor: Colors.yellow,
                      backgroundColor: faithColor,
                      label: Text('Fé e Espiritualidade',
                          style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        setState(() {
                          if (faithType == "Fé e Espiritualidade") {
                            faithType = "X";
                            faithColor = Colors.white;
                          } else {
                            faithType = "";
                            faithColor = Colors.yellow;
                          }
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ActionChip(
                      pressElevation: 2,
                      elevation: 2,
                      shadowColor: Colors.blueAccent,
                      backgroundColor: studyColor,
                      label: Text('Acadêmico e Profissional',
                          style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        setState(() {
                          // if ((type != "X") && (studyColor == Colors.white)) {
                          //   type = "Acadêmico e Profissional";

                          //   healthColor = Colors.white;

                          //   sportColor = Colors.white;

                          //   partyColor = Colors.white;

                          //   artColor = Colors.white;

                          //   studyColor = Colors.blueAccent;

                          //   othersColor = Colors.white;
                          // }

                          if (studyType == "Acadêmico e Profissional") {
                            studyType = "X";
                            studyColor = Colors.white;
                          } else {
                            studyType = "Acadêmico e Profissional";
                            studyColor = Colors.blueAccent;
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(2.0),
                //     child: ActionChip(
                //       pressElevation: 2,
                //       elevation: 2,
                //       shadowColor: Colors.cyan,
                //       backgroundColor: onlineColor,
                //       label: Text('Online',
                //           style: TextStyle(fontSize: 14)),
                //       onPressed: () {
                //         setState(() {
                //           // if ((type != "X") && (partyColor == Colors.white)) {
                //           //   type = "Festas e Comemorações";

                //           //   healthColor = Colors.white;

                //           //   sportColor = Colors.white;

                //           //   partyColor = Colors.deepPurpleAccent;

                //           //   artColor = Colors.white;

                //           //   studyColor = Colors.white;

                //           //   othersColor = Colors.white;
                //           // }
                //           if (onlineType == "Online") {
                //             onlineType = "X";
                //             onlineColor = Colors.white;
                //           } else {
                //             onlineType = "Online";
                //             onlineColor = Colors.cyan;
                //           }
                //         });
                //       },
                //     ),
                //   ),
                // ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ActionChip(
                      pressElevation: 2,
                      elevation: 2,
                      shadowColor: Colors.orange,
                      backgroundColor: othersColor,
                      label: Text('Outros', style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        setState(() {
                          // if ((othersType != "X") && (othersColor == Colors.white)) {
                          //   othersType = "Outros";

                          //   healthColor = Colors.white;

                          //   sportColor = Colors.white;

                          //   partyColor = Colors.white;

                          //   artColor = Colors.white;

                          //   studyColor = Colors.white;

                          //   othersColor = Colors.orange;
                          // }

                          if (othersType == "Outros") {
                            othersType = "X";
                            othersColor = Colors.white;
                          } else {
                            othersType = "Outros";
                            othersColor = Colors.orange;
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
              child: Container(
                child: Text(
                  "Datas dos eventos:",
                  style: TextStyle(
                      color: Color(primaryColor), //Color(secondaryColor),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ActionChip(
                      pressElevation: 2,
                      elevation: 2,
                      shadowColor: Color(0xFF4c84cd),
                      backgroundColor: dayColor,
                      label: Text('Eventos acontecendo hoje',
                          style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        setState(() {
                          if (weekColor == Color(0xFF4c84cd) ||
                              monthColor == Color(0xFF4c84cd)) {
                            weekColor = Colors.white;
                            monthColor = Colors.white;
                            dayColor = Color(0xFF4c84cd);
                          } else if (dayColor == Colors.white) {
                            dayColor = Color(0xFF4c84cd);
                          } else {
                            dayColor = Colors.white;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ActionChip(
                      pressElevation: 2,
                      elevation: 2,
                      shadowColor: Color(0xFF4c84cd),
                      backgroundColor: weekColor,
                      label: Text('Eventos nos próximos 7 dias',
                          style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        setState(() {
                          if (dayColor == Color(0xFF4c84cd) ||
                              monthColor == Color(0xFF4c84cd)) {
                            dayColor = Colors.white;
                            monthColor = Colors.white;
                            weekColor = Color(0xFF4c84cd);
                          } else if (weekColor == Colors.white) {
                            weekColor = Color(0xFF4c84cd);
                          } else {
                            weekColor = Colors.white;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 4),
            child: RaisedButton(
              color: Color(secondaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("Aplicar",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () async {
                bool req = await applyConfigs();
                if (req) {
                  //Push main with the types:

                  Navigator.pushReplacementNamed(context, '/main', arguments: {
                    'healthType': healthType,
                    'sportType': sportType,
                    'partyType': partyType,
                    //'onlineType' : onlineType,
                    'artType': artType,
                    'faithType': faithType,
                    'studyType': studyType,
                    'othersType': othersType,
                    'dataType': dataType
                  });
                } else {
                  Navigator.pushReplacementNamed(context, '/main',
                      arguments: null);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void moveBack() {
    Navigator.of(context).pushReplacementNamed("/main", arguments: {
      'healthType': healthType,
      'sportType': sportType,
      'partyType': partyType,
      //'onlineType' : onlineType,
      'artType': artType,
      'faithType': faithType,
      'studyType': studyType,
      'othersType': othersType,
      'dataType': dataType
    });
  }

  Future<bool> applyConfigs() async {
    //Map Headers
    bool req = false;

    if (healthColor != Colors.white) {
      healthType = "Saúde e Bem-estar";
      req = true;
    } else {
      healthType = "X";
    }

    if (sportColor != Colors.white) {
      sportType = "Esporte e Lazer";
      req = true;
    } else {
      sportType = "X";
    }
    if (partyColor != Colors.white) {
      partyType = "Festas e Comemorações";
      req = true;
    } else {
      partyType = "X";
    }

    // if (onlineColor != Colors.white) {
    //   onlineType = "Online";
    //   req = true;
    // } else {
    //   onlineType = "X";
    // }

    if (artColor != Colors.white) {
      artType = "Arte e Cultura";
      req = true;
    } else {
      artType = "X";
    }

    if (faithColor != Colors.white) {
      faithType = "Fé e Espiritualidade";
      req = true;
    } else {
      faithType = "X";
    }

    if (studyColor != Colors.white) {
      studyType = "Acadêmico e Profissional";
      req = true;
    } else {
      studyType = "X";
    }
    if (othersColor != Colors.white) {
      othersType = "Outros";
      req = true;
    } else {
      othersType = "X";
    }

    //If all is X:
    if ((healthType == "X") &&
        (sportType == "X") &&
        (partyType == "X") &&
        //(onlineType == "X") &&
        (artType == "X") &&
        (faithType == "X") &&
        (studyType == "X") &&
        (othersType == "X")) {
      healthType = " ";
    }

    if ((healthColor == Colors.white) &&
        (sportColor == Colors.white) &&
        (partyColor == Colors.white) &&
        //(onlineColor == Colors.white) &&
        (artColor == Colors.white) &&
        (faithColor == Colors.white) &&
        (studyColor == Colors.white) &&
        (othersColor == Colors.white)) {
      healthType = "Saúde e Bem-estar";
      sportType = "Esporte e Lazer";
      partyType = "Festas e Comemorações";
      //onlineType = "Online";
      artType = "Arte e Cultura";
      faithType = "Fé e Espiritualidade";
      studyType = "Acadêmico e Profissional";
      othersType = "Outros";
    }

    if (dayColor != Colors.white) {
      dataType = "day";
      req = true;
    } else if (weekColor != Colors.white) {
      dataType = "week";
      req = true;
    } else {
      dataType = "all";
      req = true;
    }

    return req;
  }
}
