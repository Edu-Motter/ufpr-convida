import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/models/mobx/new_event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  String validateDesc(){
    return descriptionValidation(alterEvent.desc);
  }

  String validateAddress(){
    return addressValidation(alterEvent.address);
  }

  String validateComplement(){
    return complementValidation(alterEvent.complement);
  }

  String validateLink(){
    return linkValidation(alterEvent.link);
  }

  Future<int> putEvent(String type, bool isSwitchedSubs, Event event , BuildContext context) async {
    final _save = FlutterSecureStorage();
    final _id = await _save.read(key: "user");
    final _token = await _save.read(key: "token");
    User user;
    
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    // try {
    //   user = await http
    //       .get("$_url/users/$_id", headers: mapHeaders)
    //       .then((http.Response response) {
    //     final int statusCode = response.statusCode;
    //     if ((statusCode == 200) || (statusCode == 201)) {
    //       return User.fromJson(jsonDecode(response.body));
    //     } else {
    //       showError("Erro no servidor", "Erro: $statusCode", context);
    //     }
    //   });
    // } catch (e) {
    //   showError("Erro desconhecido", "Erro: $e", context);
    // }

    if (isSwitchedSubs == false) {
      alterEvent.setSubStart("");
      alterEvent.setSubEnd("");
    }

    Event p = new Event(
        id: event.id,
        name: alterEvent.name,
        target: alterEvent.target,
        desc: alterEvent.desc,
        hrStart: alterEvent.hrStart,
        hrEnd: alterEvent.hrEnd,
        dateStart: alterEvent.dateStart,
        dateEnd: alterEvent.dateEnd,
        link: alterEvent.link,
        type: type,
        address: alterEvent.address,
        complement: alterEvent.complement,
        startSub: alterEvent.subStart,
        endSub: alterEvent.subEnd,
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