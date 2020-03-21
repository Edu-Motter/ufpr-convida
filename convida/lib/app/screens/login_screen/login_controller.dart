import 'package:convida/app/shared/models/login.dart';
import 'package:convida/app/shared/models/mobx/login.dart';
import 'package:convida/app/shared/models/user.dart';
import 'package:mobx/mobx.dart';
import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/validations/login_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:convida/app/shared/global/globals.dart' as globals;
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  Login login = new Login();
  Login recovery = new Login();
  String _url = globals.URL;

  String validateUser() {
    return userValidation(login.user);
  }

  String validatePassword() {
    return passwordValidation(login.password);
  }

  

  bool validadeLogin(BuildContext context) {
    String ok = validateUser();
    print(ok);
    if (ok != null) {
      showError("Usuário Inválido", "Favor entre com um nome de usuário válido",
          context);
      return false;
    }
    ok = validatePassword();
    if (ok != null) {
      showError("Senha Inválida", "Favor entre com uma senha válida", context);
      return false;
    }
    return true;
  }

  Future<int> postLoginUser(BuildContext context) async {
    final _save = FlutterSecureStorage();
    //* GRR To Lower Case
    login.user = login.user.toLowerCase();

    AccountCredentials l = new AccountCredentials(
      username: login.user,
      password: login.password,
    );

    String loginJson = json.encode(l.toJson());

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

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

          _save.write(key: "token", value: j["token"]);
          _save.write(key: "user", value: login.user);
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
    print("TOKEN: $token");

    Map<String, String> mapHeadersToken = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    if (s == 200 || s == 201) {
      try {
        //Get user:
        String id = login.user;
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
          } else {
            showError("Erro desconhecido", "Erro: $statusCode", context);
          }
        });

        if (user.name == null){
          return 0;
        }
        //_save.write(key: "adm", value: "${user.adm}");
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
