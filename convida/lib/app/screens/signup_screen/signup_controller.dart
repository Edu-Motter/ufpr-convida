import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/models/login.dart';
import 'package:convida/app/shared/models/mobx/signup.dart';
import 'package:convida/app/shared/models/user.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/validations/user_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:mobx/mobx.dart';
part 'signup_controller.g.dart';

class SignupController = _SignupControllerBase with _$SignupController;

abstract class _SignupControllerBase with Store {
  var signup = Signup();
  String _url = globals.URL;

  @computed
  bool get isValid {
    return ((validateName() == null) &&
        (validadeLastName() == null) &&
        (validadeGrr() == null) &&
        (validadeEmail() == null) &&
        (validadePassword() == null));
  }

  String validateName() {
    return nameValidation(signup.name, "nome");
  }

  String validadeLastName() {
    return nameValidation(signup.lastName, "sobrenome");
  }

  String validadeGrr() {
    return grrValidation(signup.grr);
  }

  String validadeEmail() {
    return emailValidation(signup.email);
  }

  String validadePassword() {
    return passwordValidation(signup.password, signup.confirmPassword);
  }

  Future<int> checkGrr() async {
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    String grr = signup.grr;

    int statusC = await http
        .get("$_url/users/$grr", headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if ((statusCode == 200) || (statusCode == 201)) {
        //Return 500 because already exist a user with this GRR
        return 500;
      } else {
        return 200;
      }
    });
    print("StatusCode = $statusC");
    return statusC;
  }

  Future<int> postNewUser({String dateUser, BuildContext context}) async {
    User u = new User(
        grr: signup.grr,
        name: signup.name, //_userFirstNameController.text,
        lastName: signup.lastName,
        password: signup.password,
        email: signup.email,
        birth: dateUser);

    String userJson = json.encode(u.toJson());
    print("Novo Json com MOBX: $userJson");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    int code;

    try {
      code = await http
          .post("$_url/users", body: userJson, headers: mapHeaders)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        if ((statusCode == 200) || (statusCode == 201)) {
          print("Post User Success!");
          return statusCode;
        } else {
          print("Post User Error: $statusCode");
          return statusCode;
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }
    return code;
  }

  Future<int> postLoginUser({BuildContext context}) async {
    final _save = FlutterSecureStorage();

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    AccountCredentials l = new AccountCredentials(
      username: signup.grr,
      password: signup.password,
    );

    String loginJson = json.encode(l.toJson());

    int s;
    try {
      s = await http
          .post("$_url/login", body: loginJson, headers: mapHeaders)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        print("-------------------------------------------------------");
        print("Request on: $_url/login");
        print("Status Code: ${response.statusCode}");
        print("Posting User Login...");

        if ((statusCode == 200) || (statusCode == 201)) {
          var j = json.decode(response.body);
          print("Saving..");

          _save.write(key: "token", value: j["token"]);
          _save.write(key: "user", value: signup.grr);
          print("-------------------------------------------------------");
          return statusCode;
        } else {
          print("Error Token");
          print("-------------------------------------------------------");
          return statusCode;
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }

    final token = await _save.read(key: "token");

    Map<String, String> mapHeadersToken = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    if (s == 200 || s == 201) {
      try {
        String id = signup.grr;
        User user = await http
            .get("$_url/users/$id", headers: mapHeadersToken)
            .then((http.Response response) {
          final int statusCode = response.statusCode;

          print("-------------------------------------------------------");
          print("Request on: $_url/users/$id");
          print("Status Code: ${response.statusCode}");
          print("Loading User Profile...");
          print("-------------------------------------------------------");

          if ((statusCode == 200) || (statusCode == 201)) {
            return User.fromJson(jsonDecode(response.body));
          } else {}
        });

        _save.write(key: "name", value: "${user.name}");
        _save.write(key: "email", value: "${user.email}");
        _save.write(key: "lastName", value: "${user.lastName}");
      } catch (e) {
        showError("Erro desconhecido", "Erro: $e", context);
      }
    }
    return s;
  }
}
