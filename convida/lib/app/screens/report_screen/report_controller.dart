import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:convida/app/shared/models/event.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';
part 'report_controller.g.dart';

class ReportController = _ReportControllerBase with _$ReportController;

abstract class _ReportControllerBase with Store {
  @observable
  List<Event> listItems;

  @action
  setListItems(List<Event> value) => listItems = value;

  Future<List<Event>> 
  getReportedEvents(BuildContext context) async {
    final _save = FlutterSecureStorage();
    var _token = await _save.read(key: "token");
    String _id = await _save.read(key: "user");

    String _url = globals.URL;

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    var response;
    try {
      response =
          await http.get("$_url/events/reported", headers: mapHeaders);

      print("-------------------------------------------------------");
      print("Request on: $_url/users/myevents?text=$_id");
      print("Status Code: ${response.statusCode}");
      print("Loading Reported Events...");
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
}
