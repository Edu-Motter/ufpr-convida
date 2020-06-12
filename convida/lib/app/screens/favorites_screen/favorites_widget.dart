import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:convida/app/shared/global/globals.dart';

enum WhyFarther { Link, Favoritar, Mapa }

class FavoritesWidget extends StatefulWidget {
  @override
  _FavoritesWidgetState createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  String _url = globals.URL;
  var jsonData;
  String _imageAsset = "";
  DateFormat date = new DateFormat.yMMMMd("pt_BR");
  DateFormat hour = new DateFormat.Hm();
  String _token;
  final _save = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: FutureBuilder(
          future: checkToken(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            } else if (snapshot.data) {
              return Container(
                child: Center(
                  child: FutureBuilder(
                    future: getAllFavorites(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      List<Event> values = snapshot.data;
                      if (snapshot.data == null && snapshot.connectionState != ConnectionState.done) {
                        return CircularProgressIndicator();
                      } else if (values.length == 0) {
                        //Caso nao haver eventos!
                        return Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text(
                                    "Ainda não existem eventos favoritados por você",
                                    style: TextStyle(
                                        color: Color(secondaryColor),
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
                                    "Para favoritar um evento, basta visualizar detalhadamente o evento e pressionar na estrela que estará branca, então ela ficará amarela indicando que o evento foi favoritado com sucesso",
                                    style: TextStyle(
                                        color: Color(primaryColor),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 48),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Color(primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed("/main");
                                  },
                                  padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                                  child: Text('Ir aos Eventos',
                                      //Color(primaryColor),(secondaryColor)
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: values.length,
                            itemBuilder: (BuildContext context, int index) {
                              //Select the image:
                              print("Event type: ${values[index].type}");

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
                              } else if (values[index].type ==
                                  'Arte e Cultura') {
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
                                      maxLines: 3,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 20.0,
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
                                      radius: 28.0,
                                      backgroundColor: Colors.white,
                                      child: Image.asset("assets/$_imageAsset"),
                                    ),
                                    isThreeLine: true,
                                    onTap: () {
                                      Navigator.pushNamed(context, '/event',
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
                          (queryData.orientation == Orientation.portrait)
                              ? Container(
                                  height: queryData.size.height / 2.5,
                                  width: queryData.size.width / 1.2,
                                  child: Image.asset(
                                    //Image:
                                    "assets/logo-ufprconvida.png",
                                    scale: 2,
                                  ),
                                )
                              : Container(
                                  height: queryData.size.height / 2.5,
                                  width: queryData.size.width / 2,
                                  child: Image.asset(
                                    //Image:
                                    "assets/logo-ufprconvida.png",
                                    scale: 2,
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: Color(primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              onPressed: () async {
                                //Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pushNamed("/login", arguments: "fav");
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
                              color: Color(secondaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              onPressed: () {
                                //When press Signup:
                                //Navigator.of(context).pop();
                                // Navigator.push(context, SlideRightRoute(page: AboutWidget()));
                                Navigator.of(context)
                                    .pushNamed("/signup", arguments: "fav");
                              },
                              padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                              child: Text('Fazer Cadastro',
                                  //Color(primaryColor),(secondaryColor)
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      )),
                    ],
                  ),
                ),
              ]);
            }
          }),
    );
  }

  Future<List> getAllFavorites() async {
    final _id = await _save.read(key: "user");
    _token = await _save.read(key: "token");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };
    var response;

    try {
      response = await http.get("$_url/users/fav/$_id", headers: mapHeaders);

      print("-------------------------------------------------------");
      print("Request on: $_url/users/fav/$_id");
      print("Status Code: ${response.statusCode}");
      print("Loading Favorites Events...");
      print("-------------------------------------------------------");

      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        try {
          final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
          return parsed.map<Event>((json) => Event.fromJson(json)).toList();
        } catch (e) {
          List<Event> noEvents = [];
          return noEvents ;
        }
      } else if (response.statusCode == 401) {
        showError("Erro 401", "Não autorizado, favor logar novamente", context);
        return null;
      } else if (response.statusCode == 404) {
        showError("Erro 404", "Autor não foi encontrado", context);
        return null;
      } else if (response.statusCode == 500) {
        showError("Erro 500",
            "Erro no servidor, favor tente novamente mais tarde", context);
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
