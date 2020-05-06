import 'dart:convert';
import 'dart:io';

import 'package:convida/app/shared/DAO/util_requisitions.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:convida/app/shared/models/mobx/report.dart';
import 'package:convida/app/shared/models/report.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

part 'reported_event_controller.g.dart';

class ReportedEventController = _ReportedEventControllerBase
    with _$ReportedEventController;

abstract class _ReportedEventControllerBase with Store {
  final String _url = globals.URL;
  final _save = FlutterSecureStorage();

  @observable
  ObservableList listReports = [].asObservable();

  updateList(idEvent, BuildContext context) async {
    try {
      var reports = await getReports(idEvent, context);
      if (reports.length > 0) {
        for (var r in reports) {
          if (r.ignored == false) {
            ReportModel reportModel = ReportModel(
                description: r.report, author: r.grr, ignored: false, id: r.id);
            listReports.add(reportModel);
          }
        }
      }
    } catch (e) {}
    //print("lista: $listReports");
  }

  @action
  removeReport(ReportModel report, BuildContext context) {
    ignoreReport(context, report.id);
    updateList(report, context);
    listReports.removeWhere((item) => (item.description == report.description &&
        item.author == report.author));
  }

  Future<List<Report>> getReports(String idEvent, BuildContext context) async {
    bool ok = await checkToken();

    if (ok) {
      final _token = await _save.read(key: "token");

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

  Future<bool> checkToken() async {
    final _token = await _save.read(key: "token");
    if (_token == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> getDeactivate(String id, BuildContext context) async {
    final _token = await _save.read(key: "token");
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

  Future<bool> getActivate(String id, BuildContext context) async {
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

  ignoreReport(BuildContext context, String reportId) async {
    final _id = await _save.read(key: "user");
    final _token = await _save.read(key: "token");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    var r;
    print("Request on: /events/ignore/$reportId");
    try {
      r = await http.get("$_url/events/ignore/$reportId", headers: mapHeaders);
      if (r.statusCode == 200) {
        showSuccess("Verificado com Sucesso!", "null", context);
      } else if (r.statusCode == 401) {
        showError("Erro 401", "Não autorizado, favor logar novamente", context);
      } else if (r.statusCode == 404) {
        showError("Erro 404", "Autor não foi encontrado", context);
      } else if (r.statusCode == 500) {
        showError("Erro 500",
            "Erro no servidor, favor tente novamente mais tarde", context);
      } else {
        showError("Erro Desconhecido", "StatusCode: ${r.statusCode}", context);
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }
  }
}
