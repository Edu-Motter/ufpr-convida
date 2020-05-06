import 'package:convida/app/shared/DAO/util_requisitions.dart';
import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/models/mobx/new_event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'dart:convert';
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
    return dateValidation(newEvent.dateStart, "de início do evento");
  }

  String validadeDateEnd() {
    return dateValidation(newEvent.dateEnd, "de fim do evento");
  }

  String validadeHourStart() {
    return hourValidation(newEvent.hrStart, 'início do evento');
  }

  String validadeHourEnd() {
    return hourValidation(newEvent.hrEnd, 'fim do evento');
  }

  String validadeSubStart() {
    return dateValidation(newEvent.subStart, "de início das inscrições");
  }

  String validadeSubEnd() {
    return dateValidation(newEvent.subEnd, "de fim das inscrições");
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
      parsedSubStart = dateFormat.parse(newEvent.subStart);
      parsedSubEnd = dateFormat.parse(newEvent.subEnd);
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
      //Check if Date Sub End > Sub start
      if (parsedSubStart.compareTo(parsedSubEnd) > 0) {
        return "O Fim das inscrições está antes do Início!";
      }
      //?Talvez não seja boa essa validação, comparar com o fim?
      //Check if Date End > Date Sub End

      if (parsedSubEnd.compareTo(parsedDateEnd) > 0) {
        return "As inscrições não encerram junto com o Evento!";
      }

      return "";
    } else {
      return "";
    }
  }

  Future<int> postNewEvent(String type, bool isSwitchedSubs, LatLng coords, bool isOnline,
      BuildContext context) async {
    final _save = FlutterSecureStorage();
    String _token = await _save.read(key: "token");
    String _id = await _save.read(key: "user");
    User user;

    var mapHeaders = getHeaderToken(_token);

    //!GET USER
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
        lng: coords.longitude,
        active: true,
        online: isOnline);

    String eventJson = json.encode(p.toJson());
    int code;

    //!POST EVENT
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

  bool checkAll(BuildContext context, bool isSwitchedSubs) {
    String error;

    error = nameValidation(newEvent.name);
    if (error != null) {
      showError("Nome inválido", error, context);
      return false;
    }

    error = targetValidation(newEvent.target);
    if (error != null) {
      showError("Público Alvo inválido", error, context);
      return false;
    }

    error = descriptionValidation(newEvent.desc);
    if (error != null) {
      showError("Descrição inválida", error, context);
      return false;
    }

    error = addressValidation(newEvent.address);
    if (error != null) {
      showError("Endereço inválido", error, context);
      return false;
    }

    error = complementValidation(newEvent.complement);
    if (error != null) {
      showError("Complemento inválido", error, context);
      return false;
    }

    error = linkValidation(newEvent.link);
    if (error != null) {
      showError("Link ou Email inválido", error, context);
      return false;
    }

    error = hourValidation(newEvent.hrStart, "início do evento");
    if (error != null) {
      showError("Horário inválido", error, context);
      return false;
    }

    error = hourValidation(newEvent.hrEnd, "fim do evento");
    if (error != null) {
      showError("Horário inválido", error, context);
      return false;
    }

    error = dateValidation(newEvent.dateStart, "de início do evento");
    if (error != null) {
      showError("Data inválida", error, context);
      return false;
    }

    error = dateValidation(newEvent.dateEnd, "de fim do evento");
    if (error != null) {
      showError("Data inválida", error, context);
      return false;
    }

    if (isSwitchedSubs) {
      error = dateValidation(newEvent.subStart, "de início das inscrições");
      if (error != null) {
        showError("Data inválida", error, context);
        return false;
      }

      error = dateValidation(newEvent.subEnd, "de fim das inscrições");
      if (error != null) {
        showError("Data inválida", error, context);
        return false;
      }
    }

    return true;
  }
}
