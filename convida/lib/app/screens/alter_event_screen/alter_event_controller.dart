import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/models/mobx/new_event.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/validations/event_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:convida/app/shared/global/globals.dart' as globals;
part 'alter_event_controller.g.dart';

class AlterEventController = _AlterEventControllerBase with _$AlterEventController;

abstract class _AlterEventControllerBase with Store {
  NewEvent alterEvent = NewEvent();
  String _url = globals.URL;
  
  String validateName() {
    return nameValidation(alterEvent.name);
  }

  String validateTarget() {
    return targetValidation(alterEvent.target);
  }

  String validateDesc() {
    return descriptionValidation(alterEvent.desc);
  }

  String validateAddress() {
    return addressValidation(alterEvent.address);
  }

  String validateComplement() {
    return complementValidation(alterEvent.complement);
  }

  String validateLink() {
    return linkValidation(alterEvent.link);
  }

  String validadeDateStart() {
    return dateValidation(alterEvent.dateStart);
  }

  String validadeDateEnd() {
    return dateValidation(alterEvent.dateEnd);
  }

  String validadeHourStart() {
    return hourValidation(alterEvent.hrStart, 'início do evento');
  }

  String validadeHourEnd() {
    return hourValidation(alterEvent.hrEnd, 'fim do evento');
  }

  String validadeSubStart() {
    return dateValidation(alterEvent.subStart);
  }

  String validadeSubEnd() {
    return dateValidation(alterEvent.subEnd);
  }

  String datesValidations(bool isSwitchedSubs) {
    //*Tratar todas as datas:
    DateFormat dateFormat = new DateFormat("dd/MM/yyyy");
    DateFormat hourFormat = new DateFormat("HH:mm");

    DateTime parsedHrStart = hourFormat.parse(alterEvent.hrStart);
    DateTime parsedHrEnd = hourFormat.parse(alterEvent.hrEnd);

    DateTime parsedDateStart = dateFormat.parse(alterEvent.dateStart);
    DateTime parsedDateEnd = dateFormat.parse(alterEvent.dateEnd);

    DateTime parsedSubEnd;
    DateTime parsedSubStart;
    if (isSwitchedSubs) {
      parsedSubEnd = dateFormat.parse(alterEvent.subStart);
      parsedSubStart = dateFormat.parse(alterEvent.subEnd);
    }

    //Check if Date Start > Date End
    if (parsedDateStart.compareTo(parsedDateEnd) > 0) {
      return "A Data de Fim do evento está antes da Data de Início!";
    }
    //Check if Date Start == Date End, Check Hours
    else if (parsedDateStart.day == parsedDateEnd.day) {
      if (parsedHrStart.compareTo(parsedHrEnd) > 0) {
        return "Evento no mesmo dia, as horas estão incorretas!";
      }
      return "";
    } else if (isSwitchedSubs) {
      //Check if Date Sub Start < Date Sub End
      if (parsedSubStart.compareTo(parsedSubEnd) > 0) {
        return "O Fim das inscrições está antes do Início!";
      }
      //?Talvez não seja boa essa validação, comparar com o fim?
      //Check if Date Start > Date Sub End
      if (parsedDateStart.compareTo(parsedSubStart) > 0) {
        return "As inscrições não encerram antes do Evento iniciar!";
      }

      return "";
    } else {
      return "";
    }
  }

  Future<int> putEvent(String type, bool isSwitchedSubs, Event event , BuildContext context) async {
    final _save = FlutterSecureStorage();
    final _token = await _save.read(key: "token");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    if (isSwitchedSubs == false) {
      alterEvent.setSubStart("");
      alterEvent.setSubEnd("");
    }

    DateFormat dateFormat = new DateFormat("dd/MM/yyyy");
    DateFormat hourFormat = new DateFormat("HH:mm");
    DateFormat postFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");

    DateTime parsedDateStart = dateFormat.parse(alterEvent.dateStart);
    DateTime parsedDateEnd = dateFormat.parse(alterEvent.dateEnd);
    DateTime parsedHrStart = hourFormat.parse(alterEvent.hrStart);
    DateTime parsedHrEnd = hourFormat.parse(alterEvent.hrEnd);

    String postDateStart = postFormat.format(parsedDateStart);
    String postDateEnd = postFormat.format(parsedDateEnd);
    String postHrStart = postFormat.format(parsedHrStart);
    String postHrEnd = postFormat.format(parsedHrEnd);

    String postSubStart = "";
    String postSubEnd = "";

    if (isSwitchedSubs) {
      DateTime parsedSubStart = dateFormat.parse(alterEvent.subStart);
      DateTime parsedSubEnd = dateFormat.parse(alterEvent.subEnd);
      postSubStart = postFormat.format(parsedSubStart);
      postSubEnd = postFormat.format(parsedSubEnd);
    }


    Event p = new Event(
        id: event.id,
        name: alterEvent.name,
        target: alterEvent.target,
        desc: alterEvent.desc,
        hrStart: postHrStart,
        hrEnd:postHrEnd,
        dateStart: postDateStart,
        dateEnd: postDateEnd,
        link: alterEvent.link,
        type: type,
        address: alterEvent.address,
        complement: alterEvent.complement,
        startSub: postSubStart,
        endSub: postSubEnd,
        author: event.author,
        lat: event.lat,
        lng: event.lng);

    String eventJson = json.encode(p.toJson());

    int code;
    try {
      code = await http
          .put("$_url/events/${event.id}", body: eventJson, headers: mapHeaders)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        if ((statusCode == 200) || (statusCode == 201)) {
          print("Put Event Success!");
          return statusCode;
        } else {
          print("Put Evento Error: $statusCode");
          return statusCode;
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }

    return code;
  }
}

errorStatusCode(int statusCode, BuildContext context){
  if (statusCode == 401) {
    showError("Erro 401", "Não autorizado, favor logar novamente", context);
  } else if (statusCode == 404) {
    showError("Erro 404", "Evento ou usuário não foi encontrado", context);
  } else if (statusCode == 500) {
    showError("Erro 500", "Erro no servidor, favor tente novamente mais tarde",
        context);
  } else {
    showError("Erro Desconhecido", "StatusCode: $statusCode", context);
  }
}