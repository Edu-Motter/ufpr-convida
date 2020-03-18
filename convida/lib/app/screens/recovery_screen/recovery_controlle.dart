import 'package:convida/app/shared/DAO/util_requisitions.dart';
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
import 'package:convida/app/shared/models/mobx/login.dart';
import 'package:mobx/mobx.dart';
part 'recovery_controlle.g.dart';

class RecoveryController = _RecoveryControllerBase with _$RecoveryController;

abstract class _RecoveryControllerBase with Store {
  Login recovery = new Login();
  String _url = globals.URL;

  @observable
  bool loading = false;

  bool pop = false;

  String validadeRecoveryUser() {
    return userValidation(recovery.user);
  }

  String validadeRecoveryEmail() {
    return recoveryEmailValidation(recovery.password);
  }

  Future<bool> postRecovery(BuildContext context) async {
    loading = true;
    // final _save = FlutterSecureStorage();
    //* GRR To Lower Case
    recovery.user = recovery.user.toLowerCase();

    AccountCredentials l = new AccountCredentials(
      username: recovery.user,
      password: recovery.password,
    );

    String loginJson = json.encode(l.toJson());
    dynamic response;
    final String request = "$_url/users/recovery";
    try {
      showLoading('Estamos processando seu pedido, aguarde!', context);
      var mapHeaders = getHeader();
      response = await http.post(request, body: loginJson, headers: mapHeaders);
      printRequisition(request, response.statusCode, "Post Recovery");

      if ((response.statusCode == 200) || (response.statusCode == 204)) {
        loading = false;
        if (pop == false)
          Navigator.pop(context); 
        showSuccess('Deu boa!', 'pop', context);
        return true;
      } else {
        loading = false;
        errorStatusCode(
            response.statusCode, context, "Erro ao tentar Recuperar sua Senha");
        return false;
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
      return false;
    }
  }

  void showLoading(String s, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(s),
          content: new Text("Prescione 'Ok' para continar"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
                pop = true;
              },
            ),
          ],
        );
      },
    );
  }
}
