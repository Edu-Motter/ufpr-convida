import 'package:convida/app/shared/DAO/util_requisitions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:convida/app/shared/util/dialogs_widget.dart';

String _url = globals.URL;

//*Requisition to get Events with Type e Search
Future<List> getEvents(String search, String type, BuildContext context) async {
  String parsedSearch = Uri.encodeFull(search);
  String parsedType = Uri.encodeFull(type);
  dynamic response;
  final String request =
        "$_url/events/nametypesearch?text=$parsedSearch&type=$parsedType";
        
  try {
    
    response = await http.get(request);
    printRequisition(request, response.statusCode, "Get Events");

    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Event>((json) => Event.fromJson(json)).toList();
    } else {
      errorStatusCode(response.statusCode, context, "Erro ao carregar Eventos");
      return null;
    }
  } catch (e) {
    showError("Erro desconhecido", "Erro: $e", context);
    return null;
  }
}

//*Requisition to post a New Event
Future<bool> postNewEvent(
    String newEvent, String token, BuildContext context) async {
  dynamic response;
  final String request = "$_url/events";
  try {
    
    var mapHeaders = getHeaderToken(token);
    response = await http.post(request, body: newEvent, headers: mapHeaders);
    printRequisition(request, response.statusCode, "Post New Event");

    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      return true;
    } else {
      errorStatusCode(response.statusCode, context, "Erro ao criar Evento");
      return false;
    }
  } catch (e) {
    showError("Erro desconhecido", "Erro: $e", context);
    return false;
  }
}

Future<bool> putEvent(
    String event, String token, String eventId, BuildContext context) async {
  dynamic response;
  final String request = "$_url/events/$eventId";

  
  try {
    var mapHeaders = getHeaderToken(token);
    response = await http.put(request, body: event, headers: mapHeaders);
    printRequisition(request, response.statusCode, "Put Event");

    if ((response.statusCode == 200) || (response.statusCode == 201)) {
      return true;
    } else {
      errorStatusCode(response.statusCode, context, "Erro ao criar Evento");
      return false;
    }
  } catch (e) {
    showError("Erro desconhecido", "Erro: $e", context);
    return false;
  }
}
