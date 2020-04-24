import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/DAO/util_requisitions.dart';
import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/models/report.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RerportedEventWidget extends StatefulWidget {
  final Event event;
  RerportedEventWidget({Key key, @required this.event}) : super(key: key);

  @override
  _RerportedEventWidgetState createState() => _RerportedEventWidgetState(event);
}

class _RerportedEventWidgetState extends State<RerportedEventWidget> {
  Event event;
  _RerportedEventWidgetState(this.event);

  String _token;
  final _save = FlutterSecureStorage();
  String _url = globals.URL;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Denuncias do Evento"),
        ),
        body: FutureBuilder(
            future: getReports(event.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: double.infinity,
                              height: 120,
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    snapshot.data[index].report,
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  subtitle: Text(
                                    "Reportado por: ${snapshot.data[index].id}",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onTap: () async {
                                    
                                          
                                           
                                            final _id =
                                                await _save.read(key: "user");
                                            final _token =
                                                await _save.read(key: "token");

                                            Map<String, String> mapHeaders = {
                                              "Accept": "application/json",
                                              "Content-Type":
                                                  "application/json",
                                              HttpHeaders.authorizationHeader:
                                                  "Bearer $_token"
                                            };

                                            
                                            var r;
                                            print("Request on: /events/ignore/${snapshot.data[index].id}");
                                            try {
                                              r = await http.get(
                                                  "$_url/events/ignore/${snapshot.data[index].id}",

                                                  headers: mapHeaders);
                                              if (r.statusCode == 200) {
                                                showSuccess(
                                                    "Evento Ignorado com Sucesso!",
                                                    "pop",
                                                    context);
                                              } else if (r.statusCode == 401) {
                                                showError(
                                                    "Erro 401",
                                                    "Não autorizado, favor logar novamente",
                                                    context);
                                              } else if (r.statusCode == 404) {
                                                showError(
                                                    "Erro 404",
                                                    "Autor não foi encontrado",
                                                    context);
                                              } else if (r.statusCode == 500) {
                                                showError(
                                                    "Erro 500",
                                                    "Erro no servidor, favor tente novamente mais tarde",
                                                    context);
                                              } else {
                                                showError(
                                                    "Erro Desconhecido",
                                                    "StatusCode: ${r.statusCode}",
                                                    context);
                                              }
                                            } catch (e) {
                                              showError("Erro desconhecido",
                                                  "Erro: $e", context);
                                            }
                                        
                                  
                                  },
                                ),
                              ),
                            );
                          }),
                    ),
                    Expanded(
                      flex: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? 1
                          : 2,
                      child: Container(
                        color: Colors.white,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Icon(
                                            Icons.report_off,
                                            size: 26,
                                            color: Color(0xFF295492),
                                          ),
                                        ),
                                        Text("Ignorar Denuncias")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              event.active == true
                                  //Deactivate Event
                                  ? Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: InkWell(
                                          onTap: () async {
                                            bool success =
                                                await getDeactivate(event.id);
                                            if (success) {
                                              showSuccess("Evento Desativado",
                                                  "pop", context);
                                            }
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Icon(Icons.cancel,
                                                  size: 26, color: Colors.red),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0),
                                                child: Text("Desativar Evento"),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )

                                  //Ativate Event
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: InkWell(
                                          onTap: () async {
                                            bool success =
                                                await getActivate(event.id);
                                            if (success) {
                                              showSuccess("Evento Ativado",
                                                  "pop", context);
                                            }
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Icon(Icons.check_circle,
                                                  size: 26,
                                                  color: Colors.green),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0),
                                                child: Text("Ativar Evento"),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                            ]),
                      ),
                    )
                  ],
                );
              }
            }),
      ),
      onWillPop: null,
    );
  }

  Future<bool> checkToken() async {
    _token = await _save.read(key: "token");
    if (_token == null) {
      return false;
    } else {
      return true;
    }
  }

  getReports(String idEvent) async {
    bool ok = await checkToken();

    if (ok) {
      String _url = globals.URL;
      // final _id = await _save.read(key: "user");
      _token = await _save.read(key: "token");

      Map<String, String> mapHeaders = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_token"
      };
      var response;
      print("$_url/events/report/$idEvent");
      try {
        response =
            await http.get("$_url/events/report/$idEvent", headers: mapHeaders);

        print("-------------------------------------------------------");
        print("Request on: $_url/events/report/$idEvent");
        print("Status Code: ${response.statusCode}");
        print("Loading Reports...");
        print("-------------------------------------------------------");

        if ((response.statusCode == 200) || (response.statusCode == 201)) {
          final parsed =
              json.decode(response.body).cast<Map<String, dynamic>>();
          print(response.body);
          return parsed.map<Report>((json) => Report.fromJson(json)).toList();
        } else if (response.statusCode == 401) {
          showError(
              "Erro 401", "Não autorizado, favor logar novamente", context);
          return null;
        } else if (response.statusCode == 404) {
          showError("Erro 404", "Autor não foi encontrado", context);
          return null;
        } else if (response.statusCode == 500) {
          showError("Erro 500",
              "Erro no servidor, favor tente novamente mais tarde", context);
          return null;
        } else {
          showError("Erro Desconhecido", "StatusCode: ${response.statusCode}",
              context);
          return null;
        }
      } catch (e) {
        showError("Erro desconhecido", "Erro: $e", context);
        return null;
      }
    } else {
      showError("Necessário Login",
          "Favor logar novamente, pressione Ok para continuar", context);
    }
  }

  Future<bool> getDeactivate(String id) async {
    _token = await _save.read(key: "token");
    String _url = globals.URL;
    dynamic response;
    final String request = "$_url/events/deactivate/$id";

    try {
      var mapHeaders = getHeaderToken(_token);
      response = await http.get(request, headers: mapHeaders);
      printRequisition(request, response.statusCode, "Deactivate This Event");

      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        return true;
      } else {
        errorStatusCode(
            response.statusCode, context, "Erro ao Desativar Evento");
        return false;
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
      return false;
    }
  }

  Future<bool> getActivate(String id) async {
    final String _token = await _save.read(key: "token");
    final String _url = globals.URL;
    dynamic response;
    final String request = "$_url/events/activate/$id";

    try {
      var mapHeaders = getHeaderToken(_token);
      response = await http.get(request, headers: mapHeaders);
      printRequisition(request, response.statusCode, "Activate This Event");

      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        return true;
      } else {
        errorStatusCode(response.statusCode, context, "Erro ao Ativar Evento");
        return false;
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
      return false;
    }
  }
}
