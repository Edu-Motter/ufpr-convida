import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:http/http.dart' as http;

class MyEventsWidget extends StatefulWidget {
  @override
  _MyEventsWidgetState createState() => _MyEventsWidgetState();
}

class _MyEventsWidgetState extends State<MyEventsWidget> {
  final _save = FlutterSecureStorage();
  String _url = globals.URL;
  var jsonData;
  String _imageAsset = "";
  DateFormat date = new DateFormat.yMMMMd("pt_BR");
  DateFormat hour = new DateFormat.Hm();
  String _token;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: FutureBuilder(
        future: checkToken(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else if (snapshot.data) {
            return Container(
              color: Colors.white,
              child: Center(
                child: FutureBuilder(
                  future: getMyEvents(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null && _token != null) {
                      return CircularProgressIndicator();
                    } else if (snapshot.data.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(
                                  "Ainda não existem eventos criados por você",
                                  style: TextStyle(
                                      color: Color(0xFF8A275D),
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(
                                  "Para criar um evento, basta ir ao Mapa pressionar exatamente no local que deseja criar seu evento e esperar alguns segundos",
                                  style: TextStyle(
                                      color: Color(0xFF295492),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: 48),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                color: Color(0xFF295492),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: () {
                                  //When press Signup:
                                  Navigator.of(context)
                                      .pushReplacementNamed("/main");
                                },
                                padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                                child: Text('Ir ao Mapa',
                                    //Color(0xFF295492),(0xFF8A275D)
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<Event> values = snapshot.data;
                            //Select the image:
                            //print("");

                            if (values[index].type == 'Saúde e Bem-estar') {
                              _imageAsset = 'type-health.png';
                            } else if (values[index].type ==
                                'Esporte e Lazer') {
                              _imageAsset = 'type-sport.png';
                            } else if (values[index].type ==
                                'Festas e Comemorações') {
                              _imageAsset = 'type-party.png';
                            } else if (values[index].type == 'Online') {
                              _imageAsset = 'type-online.png';
                            } else if (values[index].type == 'Arte e Cultura') {
                              _imageAsset = 'type-art.png';
                            } else if (values[index].type ==
                                'Fé e Espiritualidade') {
                              _imageAsset = 'type-faith.png';
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
                                    child: Image.asset("assets/$_imageAsset"),
                                  ),
                                  isThreeLine: true,
                                  onTap: () {
                                    //Mudei aqui
                                    Navigator.pushNamed(
                                        context, '/my-detailed-event',
                                        arguments: {'id': values[index].id});
                                  },
                                ),
                              ),
                            );
                          });
                    }
                  },
                ),
              ),
            );
          } else {
            return ListView(children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //Botao Entrar
                    Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Image.asset(
                          //Image:
                          "assets/logo-ufprconvida-sembordas.png",
                          scale: 1.5,
                          //color: Colors.white70,
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Color(0xFF295492),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () async {
                              //Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed("/login", arguments: "my-events");
                            },
                            padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                            child: Text('Fazer Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Color(0xFF8A275D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              //Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed("/signup", arguments: "my-events");
                            },
                            padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                            child: Text('Fazer Cadastro',
                                //Color(0xFF295492),(0xFF8A275D)
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    )),
                  ],
                ),
              )
            ]);
          }
        },
      ),
    );
  }

  Future<List> getMyEvents() async {
    _token = await _save.read(key: "token");
    String _id = await _save.read(key: "user");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    var response;
    try {
      response =
          await http.get("$_url/users/myevents?text=$_id", headers: mapHeaders);

      print("-------------------------------------------------------");
      print("Request on: $_url/users/myevents?text=$_id");
      print("Status Code: ${response.statusCode}");
      print("Loading My Events...");
      print("-------------------------------------------------------");

      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed.map<Event>((json) => Event.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        showError("Erro 401", "Não autorizado, favor logar novamente", context);
        return null;
      } else if (response.statusCode == 404) {
        showError("Erro 404", "Evento não foi encontrado", context);
        return null;
      } else if (response.statusCode == 500) {
        showError(
            "Erro 500",
            "Erro no servidor, favor tente novamente mais tarde (Meus Eventos)",
            context);
        return null;
      } else {
        showError(
            "Erro Desconhecido", "StatusCode: ${response.statusCode}", context);
        return null;
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
      return null;
    }
  }

  Future<bool> checkToken() async {
    _token = await _save.read(key: "token");
    if (_token == null) {
      return false;
    } else {
      return true;
    }
  }
}
