import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/models/login.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/validations/user_validation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:convida/app/shared/models/user.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();
  bool created = false;

  final DateFormat formatter = new DateFormat.yMMMMd("pt_BR");
  final DateFormat dateFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
  String showDateUser = "";
  String dateUser;

  DateTime selectedDateUser = DateTime.now();

  //Controllers:
  final TextEditingController _userGrrController = new TextEditingController();
  final TextEditingController _userFirstNameController =
      new TextEditingController();
  final TextEditingController _userLastNameController =
      new TextEditingController();
  final TextEditingController _userEmailController =
      new TextEditingController();
  final TextEditingController _userPasswordController =
      new TextEditingController();
  final TextEditingController _userPassConfirmController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    String where = "";
    try {
      where = ModalRoute.of(context).settings.arguments as String;
    } catch (e) {
      print(e.toString());
    }

    try {
      return WillPopScope(
        onWillPop: () {
          if (where == "map") {
            Navigator.pushReplacementNamed(context, '/main');
            return null;
          } else if ((where == "fav") || (where == "my-events")) {
            Navigator.pop(context);
            return null;
          } else
            return null;
        },
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      //Text:
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Cadastro",
                            style: TextStyle(
                                color: Color(0xFF295492), //Color(0xFF8A275D),
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      //User first name:
                      userFirstName(),

                      //User last name
                      userLastName(),

                      //User GRR:
                      userGrr(),
                      //User Birthday
                      Padding(
                          padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.5),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                )),
                            child: InkWell(
                              onTap: () async {
                                final selectedDate =
                                    await _selectedDate(context);
                                if (selectedDate == null) return 0;

                                setState(() {
                                  this.selectedDateUser = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day);
                                  dateUser =
                                      dateFormat.format(selectedDateUser);
                                  showDateUser =
                                      formatter.format(selectedDateUser);
                                  print("Formato data post: $dateUser");
                                });
                                return 0;
                              },
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: new Text(
                                      "Data de Nasc.: ",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        //Dia
                                        Text(
                                          "$showDateUser",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),

                      //User email:
                      userEmail(),

                      //User password
                      userPassword(),

                      //Confirm password:
                      userConfirmPassword(),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Color(0xFF295492),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  onPressed: () {
                                    if (where == "map") {
                                      Navigator.pushReplacementNamed(
                                          context, '/main');
                                    } else if ((where == "fav") ||
                                        (where == "my-events") ||
                                        (where == "login")) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pushReplacementNamed(
                                          context, '/main');
                                    }
                                  },
                                  padding: EdgeInsets.fromLTRB(45, 12, 45, 12),
                                  child: Text('Cancelar',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Color(0xFF8A275D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  onPressed: () async {
                                    if (_userGrrController.text
                                        .startsWith("GRR")) {
                                      _userGrrController.text =
                                          _userGrrController.text.toLowerCase();
                                      print(_userGrrController.text);
                                    }

                                    int ok = await checkGrr();
                                    if (ok == 500) {
                                      String msg = "GRR Inválido!";
                                      String error =
                                          "O GRR informado já foi cadastrado";
                                      showError(msg, error, context);
                                    }
                                    if (showDateUser == "") {
                                      String msg =
                                          "Data de nascimento não informada!";
                                      String error =
                                          "Favor informar sua data de nascimento";
                                      showError(msg, error, context);
                                    } else if (created) {
                                      Navigator.pushReplacementNamed(
                                          context, '/main');
                                    } else if ((_formKey.currentState
                                            .validate()) &&
                                        (created == false) &&
                                        (ok == 200)) {
                                      if (_userPassConfirmController.text
                                              .compareTo(_userPasswordController
                                                  .text) ==
                                          0) {
                                        int statusCode = await postNewUser();
                                        if ((statusCode == 200) ||
                                            (statusCode == 201)) {
                                          created = true;
                                          int statusCodeLogin = await postLoginUser();
                                          if(statusCodeLogin == 201 || statusCodeLogin == 200){
                                            showSuccess("Cadastrado com Sucesso!","/main", context);
                                          }else {
                                            showError("Erro ao logar","O Cadastro foi feito sucesso, entretando deu erro ao logar", context);
                                          }
                                              
                                        } else if (statusCode == 401) {
                                          showError(
                                              "Erro 401",
                                              "Não autorizado, favor logar novamente",
                                              context);
                                        } else if (statusCode == 404) {
                                          showError(
                                              "Erro 404",
                                              "Usuário não foi encontrado",
                                              context);
                                        } else if (statusCode == 500) {
                                          showError(
                                              "Erro 500",
                                              "Erro no servidor, favor tente novamente mais tarde",
                                              context);
                                        } else {
                                          showError(
                                              "Erro Desconhecido",
                                              "StatusCode: $statusCode",
                                              context);
                                        }
                                      } else {
                                        String msg = "Erro no Cadastro";
                                        String error =
                                            "Ocorreu um erro ao fazer o Cadastro";
                                        showError(msg, error, context);
                                      }
                                    }
                                  },
                                  padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                                  child: Text('Confirmar',
                                      //Color(0xFF295492),(0xFF8A275D)
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ),
                              )
                              //
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print(e.toString());
      return CircularProgressIndicator();
    }
  }

  Future<int> checkGrr() async {
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      //HttpHeaders.authorizationHeader: "Bearer ${globals.token}"
    };
    String grr = _userGrrController.text;

    int statusC = await http
        .get("$_url/users/$grr", headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if ((statusCode == 200) || (statusCode == 201)) {
        //Return 500 because already exist a user with this grr
        return 500;
      } else {
        return 200;
      }
    });
    print("StatusCode = $statusC");
    return statusC;
  }

  Future<int> postNewUser() async {
    User u = new User(
        grr: _userGrrController.text,
        name: _userFirstNameController.text,
        lastName: _userLastNameController.text,
        password: _userPasswordController.text,
        email: _userEmailController.text,
        birth: dateUser);

    String userJson = json.encode(u.toJson());

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

  Future<int> postLoginUser() async {
    final _save = FlutterSecureStorage();


    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    AccountCredentials l = new AccountCredentials(
      username: _userGrrController.text,
      password: _userPassConfirmController.text,
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
          _save.write(key: "user", value: _userGrrController.text);
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
        String id = _userGrrController.text;
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

  Padding userFirstName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userFirstNameController,
        autovalidate: true,
        maxLength: 25,
        decoration: InputDecoration(
            hintText: "Nome: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.person)),
        //Validations:
        validator: (value) {
          return nameValidation(value, "Nome");
        },
      ),
    );
  }

  Padding userLastName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userLastNameController,
        autovalidate: true,
        maxLength: 25,
        decoration: InputDecoration(
            hintText: "Sobrenome: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(
              Icons.navigate_next,
              color: Colors.white,
            )),
        validator: (value) {
          return nameValidation(value, "Sobrenome");
        },
      ),
    );
  }

  Padding userGrr() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userGrrController,
        autovalidate: true,
        maxLength: 11,
        decoration: InputDecoration(
          hintText: "Seu GRR:",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
          //),
          icon: Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
        ),
        validator: (value) {
          return grrValidation(value);
        },
      ),
    );
  }

  Padding userEmail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userEmailController,
        autovalidate: true,
        maxLength: 50,
        decoration: InputDecoration(
            hintText: "Email: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.email)),
        validator: (value) {
          return emailValidation(value);
        },
      ),
    );
  }

  Padding userPassword() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userPasswordController,
        autovalidate: true,
        maxLength: 18,
        decoration: InputDecoration(
            hintText: "Senha: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.lock)),
        validator: (value) {
          return passwordValidation(value, _userPassConfirmController);
        },
        obscureText: true,
      ),
    );
  }

  Padding userConfirmPassword() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userPassConfirmController,
        autovalidate: true,
        maxLength: 18,
        decoration: InputDecoration(
            hintText: "Confirme a senha:",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.lock)),
        validator: (value) {
          return passwordValidation(value, _userPasswordController);
        },
        obscureText: true,
      ),
    );
  }

  Future<DateTime> _selectedDate(BuildContext context) {
    DateTime now = DateTime.now();
    var lastDate = now.subtract(Duration(days: (12 * 365 + 3)));
    return showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1900),
        lastDate: lastDate);
  }
}
