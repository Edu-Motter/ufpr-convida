import 'package:convida/app/shared/models/mobx/new_event.dart';
import 'package:mobx/mobx.dart';
import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/models/login.dart';
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
}