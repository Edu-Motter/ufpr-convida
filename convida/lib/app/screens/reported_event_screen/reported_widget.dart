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
                //List<Report> reports = snapshot.data
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
                                      "Reportado por: ${snapshot.data[index].grr}",
                                      maxLines: 1, style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500),),
                                  onTap: () {
                                    //!Irá mostrar todos os dados do Autor
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
                                            Icons.check_box,
                                            size: 26,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text("Ignorar Denuncias")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () async {
                                      bool success =  await getDeactivate(event.id);
                                      if(success){
                                        showSuccess("Evento Desativado", "pop", context);
                                      }
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Icon(Icons.cancel,
                                            size: 26, color: Colors.red),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Text("Desativar Evento"),
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
      final _id = await _save.read(key: "user");
      _token = await _save.read(key: "token");

      Map<String, String> mapHeaders = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $_token"
      };
      var response;

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
        errorStatusCode(response.statusCode, context, "Erro ao Desativar Evento");
        return false;
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
      return false;
    }
  }
}
