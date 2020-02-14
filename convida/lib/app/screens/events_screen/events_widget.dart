import 'dart:convert';

import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:http/http.dart' as http;

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class EventsWidget extends StatefulWidget {
  @override
  _EventsWidgetState createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  String _url = globals.URL;
  var jsonData;
  String _imageAsset = "";
  DateFormat date = new DateFormat.yMMMMd("pt_BR");
  DateFormat hour = new DateFormat.Hm();

  String search = "";
  String type = "";

  Color healthColor = Colors.white;
  Color sportColor = Colors.white;
  Color partyColor = Colors.white;
  Color artColor = Colors.white;
  Color studyColor = Colors.white;
  Color othersColor = Colors.white;

  Color healthLine = Colors.black;
  Color sportLine = Colors.black;
  Color partyLine = Colors.black;
  Color artLine = Colors.black;
  Color studyLine = Colors.black;
  Color othersLine = Colors.black;

  final TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: FutureBuilder(
            //initialData: "Loading..",
            future: getEvents(search, type),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<Event> values = snapshot.data;
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 5,
                                            child: TextFormField(
                                                controller: _searchController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Pesquisar Evento: ",
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.5)),
                                                )),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.5),
                                                      color: Color(0xFF295492),
                                                    ),
                                                    width: 50,
                                                    height: 50,
                                                    child: Icon(Icons.search,
                                                        color: Colors.white,
                                                        size: 32),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      search = _searchController
                                                          .text;
                                                    });
                                                  }),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                              Expanded(
                                flex: 2,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      //Icon 1
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // border: new Border.all(
                                            //     color: Colors.grey,
                                            //     width: 1.0,
                                            //     style: BorderStyle.solid),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.redAccent,
                                                blurRadius: 1,
                                                spreadRadius: 1
                                                //offset: new Offset(1.0, 1.0,1,1),
                                              )
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                if ((type != "") &&
                                                    (healthColor ==
                                                        Colors.white)) {
                                                  search =
                                                      _searchController.text;
                                                  type = "Saúde e Bem-estar";
                                                  healthColor =
                                                      Colors.redAccent;
                                                  healthLine = Colors.white;

                                                  sportColor = Colors.white;
                                                  sportLine = Colors.black;

                                                  partyColor = Colors.white;
                                                  partyLine = Colors.black;

                                                  artColor = Colors.white;
                                                  artLine = Colors.black;

                                                  studyColor = Colors.white;
                                                  studyLine = Colors.black;

                                                  othersColor = Colors.white;
                                                  othersLine = Colors.black;
                                                } else if (type ==
                                                    "Saúde e Bem-estar") {
                                                  type = "";
                                                  healthColor = Colors.white;
                                                  healthLine = Colors.black;
                                                } else {
                                                  type = "Saúde e Bem-estar";
                                                  healthColor =
                                                      Colors.redAccent;
                                                  healthLine = Colors.white;
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: healthColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.5)),
                                              width: 47,
                                              height: 47,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Image.asset(
                                                    "assets/type-mini-health.png",
                                                    color: healthLine),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // border: new Border.all(
                                            //     color: Colors.grey,
                                            //     width: 1.0,
                                            //     style: BorderStyle.solid),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.green,
                                                blurRadius: 1,
                                                spreadRadius: 1
                                                //offset: new Offset(1.0, 1.0,1,1),
                                              )
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                print(type);
                                                if ((type != "") &&
                                                    (sportColor ==
                                                        Colors.white)) {
                                                  search =
                                                      _searchController.text;
                                                  type = "Esporte e Lazer";

                                                  healthColor = Colors.white;
                                                  healthLine = Colors.black;

                                                  sportColor = Colors.green;
                                                  sportLine = Colors.white;

                                                  partyColor = Colors.white;
                                                  partyLine = Colors.black;

                                                  artColor = Colors.white;
                                                  artLine = Colors.black;

                                                  studyColor = Colors.white;
                                                  studyLine = Colors.black;

                                                  othersColor = Colors.white;
                                                  othersLine = Colors.black;
                                                } else if (type ==
                                                    "Esporte e Lazer") {
                                                  type = "";
                                                  sportColor = Colors.white;
                                                  sportLine = Colors.black;
                                                } else {
                                                  type = "Esporte e Lazer";
                                                  sportColor = Colors.green;
                                                  sportLine = Colors.white;
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: sportColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.5)),
                                              width: 47,
                                              height: 47,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Image.asset(
                                                    "assets/type-mini-sport.png",
                                                    color: sportLine),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // border: new Border.all(
                                            //     color: Colors.grey,
                                            //     width: 1.0,
                                            //     style: BorderStyle.solid),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.deepPurpleAccent,
                                                blurRadius: 1,
                                                spreadRadius: 1
                                                //offset: new Offset(1.0, 1.0,1,1),
                                              )
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                print(type);
                                                if ((type != "") &&
                                                    (partyColor ==
                                                        Colors.white)) {
                                                  search =
                                                      _searchController.text;
                                                  type =
                                                      "Festas e Comemorações";

                                                  healthColor = Colors.white;
                                                  healthLine = Colors.black;

                                                  sportColor = Colors.white;
                                                  sportLine = Colors.black;

                                                  partyColor =
                                                      Colors.deepPurpleAccent;
                                                  partyLine = Colors.white;

                                                  artColor = Colors.white;
                                                  artLine = Colors.black;

                                                  studyColor = Colors.white;
                                                  studyLine = Colors.black;

                                                  othersColor = Colors.white;
                                                  othersLine = Colors.black;
                                                } else if (type ==
                                                    "Festas e Comemorações") {
                                                  type = "";
                                                  partyColor = Colors.white;
                                                  partyLine = Colors.black;
                                                } else {
                                                  type =
                                                      "Festas e Comemorações";
                                                  partyColor =
                                                      Colors.deepPurpleAccent;
                                                  partyLine = Colors.white;
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: partyColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.5)),
                                              width: 47,
                                              height: 47,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Image.asset(
                                                      "assets/type-mini-party.png",
                                                      color: partyLine)),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // border: new Border.all(
                                            //     color: Colors.grey,
                                            //     width: 1.0,
                                            //     style: BorderStyle.solid),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.pink,
                                                blurRadius: 1,
                                                spreadRadius: 1
                                                //offset: new Offset(1.0, 1.0,1,1),
                                              )
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                print(type);
                                                if ((type != "") &&
                                                    (artColor ==
                                                        Colors.white)) {
                                                  search =
                                                      _searchController.text;
                                                  type = "Cultura e Religião";

                                                  healthColor = Colors.white;
                                                  healthLine = Colors.black;

                                                  sportColor = Colors.white;
                                                  sportLine = Colors.black;

                                                  partyColor = Colors.white;
                                                  partyLine = Colors.black;

                                                  artColor = Colors.pink;
                                                  artLine = Colors.white;

                                                  studyColor = Colors.white;
                                                  studyLine = Colors.black;

                                                  othersColor = Colors.white;
                                                  othersLine = Colors.black;
                                                } else if (type ==
                                                    "Cultura e Religião") {
                                                  type = "";
                                                  artColor = Colors.white;
                                                  artLine = Colors.black;
                                                } else {
                                                  type = "Cultura e Religião";
                                                  artColor = Colors.pink;
                                                  artLine = Colors.white;
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: artColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.5)),
                                              width: 47,
                                              height: 47,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Image.asset(
                                                    "assets/type-mini-art.png",
                                                    color: artLine),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // border: new Border.all(
                                            //     color: Colors.grey,
                                            //     width: 1.0,
                                            //     style: BorderStyle.solid),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.blueAccent,
                                                blurRadius: 1,
                                                spreadRadius: 1
                                                //offset: new Offset(1.0, 1.0,1,1),
                                              )
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                print(type);
                                                if ((type != "") &&
                                                    (studyColor ==
                                                        Colors.white)) {
                                                  search =
                                                      _searchController.text;
                                                  type =
                                                      "Acadêmico e Profissional";

                                                  healthColor = Colors.white;
                                                  healthLine = Colors.black;

                                                  sportColor = Colors.white;
                                                  sportLine = Colors.black;

                                                  partyColor = Colors.white;
                                                  partyLine = Colors.black;

                                                  artColor = Colors.white;
                                                  artLine = Colors.black;

                                                  studyColor =
                                                      Colors.blueAccent;
                                                  studyLine = Colors.white;

                                                  othersColor = Colors.white;
                                                  othersLine = Colors.black;
                                                } else if (type ==
                                                    "Acadêmico e Profissional") {
                                                  type = "";
                                                  studyColor = Colors.white;
                                                  studyLine = Colors.black;
                                                } else {
                                                  type =
                                                      "Acadêmico e Profissional";
                                                  studyColor =
                                                      Colors.blueAccent;
                                                  studyLine = Colors.white;
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: studyColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.5)),
                                              width: 47,
                                              height: 47,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Image.asset(
                                                    "assets/type-mini-graduation.png",
                                                    color: studyLine),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // border: new Border.all(
                                            //     color: Colors.grey,
                                            //     width: 1.0,
                                            //     style: BorderStyle.solid),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.orange,
                                                blurRadius: 1,
                                                spreadRadius: 1
                                                //offset: new Offset(1.0, 1.0,1,1),
                                              )
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                print(type);
                                                if ((type != "") &&
                                                    (othersColor ==
                                                        Colors.white)) {
                                                  search =
                                                      _searchController.text;
                                                  type = "Outros";

                                                  healthColor = Colors.white;
                                                  healthLine = Colors.black;

                                                  sportColor = Colors.white;
                                                  sportLine = Colors.black;

                                                  partyColor = Colors.white;
                                                  partyLine = Colors.black;

                                                  artColor = Colors.white;
                                                  artLine = Colors.black;

                                                  studyColor = Colors.white;
                                                  studyLine = Colors.black;

                                                  othersColor = Colors.orange;
                                                  othersLine = Colors.white;
                                                } else if (type == "Outros") {
                                                  type = "";
                                                  othersColor = Colors.white;
                                                  othersLine = Colors.black;
                                                } else {
                                                  type = "Outros";
                                                  othersColor = Colors.orange;
                                                  othersLine = Colors.white;
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: othersColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.5)),
                                              width: 47,
                                              height: 47,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2, 2, 1, 1),
                                                child: Image.asset(
                                                    "assets/type-mini-others.png",
                                                    color: othersLine),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 5,
                          child: ListView.builder(
                              itemCount: values.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (values[index].type == 'Saúde e Bem-estar') {
                                  _imageAsset = 'type-health.png';
                                } else if (values[index].type ==
                                    'Esporte e Lazer') {
                                  _imageAsset = 'type-sport.png';
                                } else if (values[index].type ==
                                    'Festas e Comemorações') {
                                  _imageAsset = 'type-party.png';
                                } else if (values[index].type ==
                                    'Cultura e Religião') {
                                  _imageAsset = 'type-art.png';
                                } else if (values[index].type ==
                                    'Acadêmico e Profissional') {
                                  _imageAsset = 'type-graduation.png';
                                } else {
                                  _imageAsset = 'type-others.png';
                                }

                                DateTime eventDate =
                                    DateTime.parse(values[index].dateStart);
                                DateTime eventHour =
                                    DateTime.parse(values[index].hrStart);

                                return SizedBox(
                                  width: double.infinity,
                                  height: 120,
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                        values[index].name,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 21.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        "${date.format(eventDate)} - ${hour.format(eventHour)}",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      leading: CircleAvatar(
                                        radius: 42.0,
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                            "assets/$_imageAsset"),
                                      ),
                                      isThreeLine: true,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/event', arguments: {
                                          'id': values[index].id
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }))
                    ],
                  ),
                );
              }
            }));
  }

  Future<List> getEvents(String search, String type) async {
    String parsedSearch = Uri.encodeFull(search);
    String parsedType = Uri.encodeFull(type);
    var response;
    try {
      response = await http
        .get("$_url/events/nametypesearch?text=$parsedSearch&type=$parsedType");
    print("-------------------------------------------------------");
    print("Request on: $_url/events/nametypesearch?text=$parsedSearch&type=$parsedType");
    print("Status Code: ${response.statusCode}");
    print("Loading All Events... ");
    print("-------------------------------------------------------");

      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed.map<Event>((json) => Event.fromJson(json)).toList();
      } 
      
      else if (response.statusCode == 401) {
        showError("Erro 401", "Não autorizado, favor logar novamente", context);
        return null;
      } else if (response.statusCode == 404) {
        showError("Erro 404", "Autor não foi encontrado", context);
        return null;
      } else if (response.statusCode == 500) {
        showError("Erro 500",  "Erro no servidor, favor tente novamente mais tarde", context);
        return null;
      } else {
        showError("Erro Desconhecido", "StatusCode: ${response.statusCode}", context);
        return null;
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
      return null;
    }
  }
}
