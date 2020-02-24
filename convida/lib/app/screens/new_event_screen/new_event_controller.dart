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
  String setNewType(){
    return newEvent.type;
  }

  String validateName() {
    return nameValidation(newEvent.name);
  }

  String validateTarget() {
    return targetValidation(newEvent.target);
  }

  String validateDesc(){
    return descriptionValidation(newEvent.desc);
  }

  String validateAddress(){
    return addressValidation(newEvent.address);
  }

  String validateComplement(){
    return complementValidation(newEvent.complement);
  }

  String validateLink(){
    return linkValidation(newEvent.link);
  }

  Future<int> postNewEvent(String type, bool isSwitchedSubs, LatLng coords, BuildContext context) async {
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

    Event p = new Event(
        name: newEvent.name,
        target: newEvent.target,
        desc: newEvent.desc,
        address: newEvent.address,
        complement: newEvent.complement,
        hrStart: newEvent.hrStart,
        hrEnd: newEvent.hrEnd,
        dateStart: newEvent.dateStart,
        dateEnd: newEvent.dateEnd,
        link: newEvent.link,
        type: type,
        startSub: newEvent.subStart,
        endSub: newEvent.subEnd,
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