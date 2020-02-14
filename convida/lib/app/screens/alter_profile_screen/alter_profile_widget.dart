import 'dart:io';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/validations/user_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:convida/app/shared/models/login.dart';
import 'package:convida/app/shared/models/user.dart';

class AlterProfileWidget extends StatefulWidget {
  final User user;

  AlterProfileWidget({Key key, @required this.user}) : super(key: key);

  @override
  _AlterProfileWidgetState createState() => _AlterProfileWidgetState(user);
}

class _AlterProfileWidgetState extends State<AlterProfileWidget> {
  User user;

  _AlterProfileWidgetState(this.user);

  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();
  bool created = false;

  final DateFormat formatter = new DateFormat.yMMMMd("pt_BR");
  final DateFormat postFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
  String showDateUser = "";
  String dateUser;
  String oldDateUser;

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
  final TextEditingController _userNewPasswordController =
      new TextEditingController();
  final TextEditingController _userPassConfirmController =
      new TextEditingController();

  RegExp _userFirstNameValidator =
      RegExp(r"^[A-Za-zá àâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]{2,25}$");
  RegExp _userLastNameValidator =
      RegExp(r"^[A-Za-zá àâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]{2,25}$");
  RegExp _userEmailValidator =
      RegExp(r"^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$");
  RegExp _userPasswordValidator = RegExp(r"^[a-zA-Z0-9_@$!%&-]{4,18}$");

  bool isSwitchedPassword = false;

  @override
  void initState() {
    _userGrrController.text = user.grr;
    _userFirstNameController.text = user.name;
    _userLastNameController.text = user.lastName;
    _userEmailController.text = user.email;

    DateTime parsedBirth;

    if (user.birth != null) {
      parsedBirth = DateTime.parse(user.birth);
      selectedDateUser = parsedBirth;
      dateUser = postFormat.format(parsedBirth);
      oldDateUser = postFormat.format(parsedBirth);
      showDateUser = formatter.format(parsedBirth);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (created) {
          Navigator.of(context).pushReplacementNamed("/login");
          return null;
        } else {
          Navigator.of(context).pushReplacementNamed("/main");
          return null;
        }
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
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Perfil",
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
                              final selectedDate = await _selectedDate(context);
                              if (selectedDate == null) return 0;

                              setState(() {
                                this.selectedDateUser = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day);
                                dateUser = postFormat.format(selectedDateUser);
                                showDateUser =
                                    formatter.format(selectedDateUser);
                                print("Formato data post: $dateUser");
                              });
                              return 0;
                            },
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 180, 0),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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

                    //Switch
                    Padding(
                      padding: const EdgeInsets.fromLTRB(47, 8.0, 8.0, 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Text("Deseja alterar sua senha?",
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54)),
                            Switch(
                                value: isSwitchedPassword,
                                onChanged: (value) {
                                  setState(() {
                                    print("Executou um setState");
                                    isSwitchedPassword = value;
                                  });
                                }),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      child: isSwitchedPassword == true
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  userPassword(),
                                  userNewPassword("Nova senha:"),
                                  userConfirmPassword("Confirme nova senha:"),
                                ],
                              ),
                            )
                          : userPassword(),
                    ),
                    //User password
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                color: Color(0xFF295492),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("/main");
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
                                  print(oldDateUser);
                                  print(dateUser);
                                  // int ok = 0;
                                  if (created) {
                                    Navigator.of(context)
                                        .pushReplacementNamed("/main");
                                  } else if ((user.name ==
                                          _userFirstNameController.text) &&
                                      (user.lastName ==
                                          _userLastNameController.text) &&
                                      (user.email ==
                                          _userEmailController.text) &&
                                      (oldDateUser == dateUser) &&
                                      (isSwitchedPassword == false)) {
                                    String error = "Sem Alterações";
                                    String desc = "Não existe nada alterado";
                                    showError(error, desc, context);
                                  } else if (_userPasswordController.text ==
                                      _userNewPasswordController.text) {
                                    String error = "Senhas iguais";
                                    String desc =
                                        "A senha nova é igual a antiga";
                                    showError(error, desc, context);
                                  } else if ((_formKey.currentState
                                          .validate()) &&
                                      (created == false)) {
                                    bool correct = await passCheck();

                                    if (correct) {
                                      int statusCode = await putUser();
                                      if ((statusCode == 200) ||
                                          (statusCode == 204)) {
                                        showSuccess(
                                            "Usuário Alterado com sucesso!",
                                            "/main",
                                            context);
                                      } else if (statusCode == 401) {
                                        showError(
                                            "Erro 401",
                                            "Não autorizado, favor logar novamente",
                                            context);
                                      } else if (statusCode == 404) {
                                        showError(
                                            "Erro 404",
                                            "Usuário não foi encontrado, favor logar novamente",
                                            context);
                                      } else if (statusCode == 500) {
                                        showError(
                                            "Erro 500",
                                            "Erro no servidor, favor tente novamente mais tarde",
                                            context);
                                      } else {
                                        showError("Erro Desconhecido",
                                            "StatusCode: $statusCode", context);
                                      }
                                      created = true;
                                    } else {
                                      String error = "Senha incorreta";
                                      String desc =
                                          "Pressione 'Ok' e tente novamente";
                                      showError(error, desc, context);
                                    }
                                  }
                                },
                                padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                                child: Text('Alterar',
                                    //Color(0xFF295492),(0xFF8A275D)
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ),
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
  }

  Future<bool> passCheck() async {
    final _save = FlutterSecureStorage();
    final _token = await _save.read(key: "token");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    AccountCredentials ac = new AccountCredentials(
        password: _userPasswordController.text, username: user.grr);
    String acJson = jsonEncode(ac);
    bool correct;

    try {
      correct = await http
          .put("$_url/users/checkpass", body: acJson, headers: mapHeaders)
          .then((http.Response response) {
        // final int statusCode = response.statusCode;

        print("-------------------------------------------------------");
        print("Request on: $_url/users/checkpass");
        print("Status Code: ${response.statusCode}");
        print("Checking User Password...");
        print("-------------------------------------------------------");

        if ((response.statusCode == 200) || (response.statusCode == 201)) {
          if (response.body == "true")
            return true;
          else
            return false;
        } else if (response.statusCode == 401) {
          showError(
              "Erro 401", "Não autorizado, favor logar novamente", context);
        } else if (response.statusCode == 404) {
          showError(
              "Erro 404", "Evento ou usuário não foi encontrado", context);
        } else if (response.statusCode == 500) {
          showError("Erro 500",
              "Erro no servidor, favor tente novamente mais tarde", context);
        } else {
          showError("Erro Desconhecido", "StatusCode: ${response.statusCode}",
              context);
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }

    return correct;
  }

  Future<int> putUser() async {
    final _save = FlutterSecureStorage();
    final _token = await _save.read(key: "token");

    User u;

    if (isSwitchedPassword) {
      u = new User(
          grr: user.grr,
          name: _userFirstNameController.text,
          lastName: _userLastNameController.text,
          password: _userNewPasswordController.text,
          email: _userEmailController.text,
          birth: dateUser);
    } else {
      u = new User(
          grr: user.grr,
          name: _userFirstNameController.text,
          lastName: _userLastNameController.text,
          password: _userPasswordController.text,
          email: _userEmailController.text,
          birth: dateUser);
    }

    String userJson = json.encode(u.toJson());

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    int code;

    try {
      code = await http
          .put("$_url/users/${user.grr}", body: userJson, headers: mapHeaders)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        print("-------------------------------------------------------");
        print("Request on: $_url/users/${user.grr}");
        print("Status Code: ${response.statusCode}");
        print("Putting User Alteration...");
        print("-------------------------------------------------------");

        if (statusCode == 204) {
          print("Usuário Alterado com sucesso!");
          _save.write(key: "user", value: user.grr);
          _save.write(key: "name", value: _userFirstNameController.text);
          _save.write(key: "email", value: _userEmailController.text);
          _save.write(key: "lastName", value: _userLastNameController.text);
          return statusCode;
        } else {
          return statusCode;
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }

    return code;
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.5)),
                icon: Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                )),
            validator: (value) {
              return nameValidation(value, "Sobrenome");
            }));
  }

  Padding userGrr() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        readOnly: true,
        enabled: false,
        controller: _userGrrController,
        autovalidate: true,
        maxLength: 11,
        decoration: InputDecoration(
          hintText: "Seu GRR:",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
          icon: Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
        ),
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
          }),
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
          return passwordValidation(value, null);
        },
        obscureText: true,
      ),
    );
  }

  Padding userNewPassword(String hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userNewPasswordController,
        autovalidate: true,
        maxLength: 18,
        decoration: InputDecoration(
            hintText: hint,
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

  Padding userConfirmPassword(String hint) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _userPassConfirmController,
        autovalidate: true,
        maxLength: 18,
        decoration: InputDecoration(
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.lock)),
        validator: (value) {
          return passwordValidation(value, _userNewPasswordController);
        },
        obscureText: true,
      ),
    );
  }

  Future<DateTime> _selectedDate(BuildContext context) {
    DateTime now = DateTime.now();
    var lastDate = now.subtract(Duration(days: (12 * 365 + 3)));
    showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1900),
        lastDate: lastDate);
    return null;
  }
}
