import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/models/mobx/new_event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/models/user.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/validations/event_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:convida/app/shared/global/globals.dart' as globals;
part 'new_event_controller.g.dart';

class NewEventController = _NewEventControllerBase with _$NewEventController;

abstract class _NewEventControllerBase with Store {
  var newEvent = NewEvent();
  String _url = globals.URL;

  @computed
  bool get isValid {
    return ((validateName() == null) &&
        (validateTarget() == null) &&
        (validateDesc() == null) &&
        (validateAddress() == null) &&
        (validateComplement() == null) &&
        (validateLink() == null));
  }

  @action
  String setNewType() {
    return newEvent.type;
  }

  String validateName() {
    return nameValidation(newEvent.name);
  }

  String validateTarget() {
    return targetValidation(newEvent.target);
  }

  String validateDesc() {
    return descriptionValidation(newEvent.desc);
  }

  String validateAddress() {
    return addressValidation(newEvent.address);
  }

  String validateComplement() {
    return complementValidation(newEvent.complement);
  }

  String validateLink() {
    return linkValidation(newEvent.link);
  }

  String validadeDateStart() {
    return dateValidation(newEvent.dateStart);
  }

  String validadeDateEnd() {
    return dateValidation(newEvent.dateEnd);
  }

  String validadeHourStart() {
    return hourValidation(newEvent.hrStart, 'início do evento');
  }

  String validadeHourEnd() {
    return hourValidation(newEvent.hrEnd, 'fim do evento');
  }

  String validadeSubStart() {
    return dateValidation(newEvent.subStart);
  }

  String validadeSubEnd() {
    return dateValidation(newEvent.subEnd);
  }

  String datesValidations(bool isSwitchedSubs) {
    //*Tratar todas as datas:
    DateFormat dateFormat = new DateFormat("dd/MM/yyyy");
    DateFormat hourFormat = new DateFormat("HH:mm");

    DateTime parsedHrStart = hourFormat.parse(newEvent.hrStart);
    DateTime parsedHrEnd = hourFormat.parse(newEvent.hrEnd);

    DateTime parsedDateStart = dateFormat.parse(newEvent.dateStart);
    DateTime parsedDateEnd = dateFormat.parse(newEvent.dateEnd);

    DateTime parsedSubEnd;
    DateTime parsedSubStart;
    if (isSwitchedSubs) {
      parsedSubEnd = dateFormat.parse(newEvent.subStart);
      parsedSubStart = dateFormat.parse(newEvent.subEnd);
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

  Future<int> postNewEvent(String type, bool isSwitchedSubs, LatLng coords,
      BuildContext context) async {
    final _save = FlutterSecureStorage();
    String _token = await _save.read(key: "token");
    String _id = await _save.read(key: "user");
    User user;
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    try {
      user = await http
          .get("$_url/users/$_id", headers: mapHeaders)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        if ((statusCode == 200) || (statusCode == 201)) {
          return User.fromJson(jsonDecode(response.body));
        } else {
          showError("Erro no servidor", "Erro: $statusCode", context);
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }

    if (isSwitchedSubs == false) {
      newEvent.setSubStart("");
      newEvent.setSubEnd("");
    }

    //*Tratar todas as datas:
    DateFormat dateFormat = new DateFormat("dd/MM/yyyy");
    DateFormat hourFormat = new DateFormat("HH:mm");
    DateFormat postFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");

    DateTime parsedDateStart = dateFormat.parse(newEvent.dateStart);
    DateTime parsedDateEnd = dateFormat.parse(newEvent.dateEnd);
    DateTime parsedHrStart = hourFormat.parse(newEvent.hrStart);
    DateTime parsedHrEnd = hourFormat.parse(newEvent.hrEnd);

    String postDateStart = postFormat.format(parsedDateStart);
    String postDateEnd = postFormat.format(parsedDateEnd);
    String postHrStart = postFormat.format(parsedHrStart);
    String postHrEnd = postFormat.format(parsedHrEnd);

    String postSubStart = "";
    String postSubEnd = "";

    if (isSwitchedSubs) {
      DateTime parsedSubStart = dateFormat.parse(newEvent.subStart);
      DateTime parsedSubEnd = dateFormat.parse(newEvent.subEnd);
      postSubStart = postFormat.format(parsedSubStart);
      postSubEnd = postFormat.format(parsedSubEnd);
    }

    Event p = new Event(
        name: newEvent.name,
        target: newEvent.target,
        desc: newEvent.desc,
        address: newEvent.address,
        complement: newEvent.complement,
        hrStart: postHrStart,
        hrEnd: postHrEnd,
        dateStart: postDateStart,
        dateEnd: postDateEnd,
        link: newEvent.link,
        type: type,
        startSub: postSubStart,
        endSub: postSubEnd,
        author: user.grr,
        lat: coords.latitude,
        lng: coords.longitude);

    String eventJson = json.encode(p.toJson());
    int code;

    try {
      code = await http
          .post("$_url/events", body: eventJson, headers: mapHeaders)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        if ((statusCode == 200) || (statusCode == 201)) {
          print("Post Event Success!");
          return statusCode;
        } else {
          print("Post Event Error: $statusCode");
          return statusCode;
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
      return 500;
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
