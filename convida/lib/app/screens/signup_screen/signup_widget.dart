
import 'package:convida/app/screens/signup_screen/signup_controller.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/util/text_field_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final signupController = SignupController();

  bool created = false;

  final DateFormat formatter = new DateFormat.yMMMMd("pt_BR");
  final DateFormat dateFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
  String showDateUser = "";
  String dateUser;

  DateTime selectedDateUser = DateTime.now();

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
          body: Column(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Observer(builder: (_) {
                        return textField(
                            labelText: "Nome:",
                            icon: Icons.person,
                            onChanged: signupController.signup.changeName,
                            maxLength: 25,
                            errorText: signupController.validateName);
                      }),
                    ),

                    //User last name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Observer(builder: (_) {
                        return textField(
                            labelText: "Sobrenome:",
                            icon: Icons.navigate_next,
                            onChanged: signupController.signup.changeLastName,
                            maxLength: 25,
                            errorText: signupController.validadeLastName);
                      }),
                    ),

                    //User GRR:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Observer(builder: (_) {
                        return textField(
                            labelText: "GRR:",
                            icon: Icons.navigate_next,
                            onChanged: signupController.signup.changeGrr,
                            maxLength: 11,
                            errorText: signupController.validadeGrr);
                      }),
                    ),

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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Observer(builder: (_) {
                        return textField(
                            labelText: "E-mail:",
                            icon: Icons.email,
                            onChanged: signupController.signup.changeEmail,
                            maxLength: 50,
                            errorText: signupController.validadeEmail);
                      }),
                    ),

                    //User password
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Observer(builder: (_) {
                        return textFieldObscure(
                            labelText: "Senha:",
                            icon: Icons.lock,
                            onChanged: signupController.signup.changePassword,
                            maxLength: 18,
                            errorText: signupController.validadePassword);
                      }),
                    ),

                    //Confirm password:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Observer(builder: (_) {
                        return textFieldObscure(
                            labelText: "Confirme sua senha:",
                            icon: Icons.lock,
                            onChanged:
                                signupController.signup.changeConfirmPassword,
                            maxLength: 18,
                            errorText: signupController.validadePassword);
                      }),
                    ),

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
                              child: Observer(
                                builder: (_) {
                                  return RaisedButton(
                                    color: Color(0xFF8A275D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    onPressed: signupController.isValid ? () async {
                                      if (signupController.signup.grr
                                          .startsWith("GRR")) {
                                        signupController.signup.grr =
                                            signupController.signup.grr
                                                .toLowerCase();
                                      }

                                      int ok = await signupController.checkGrr();

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
                                      } else if ((created == false) &&
                                          (ok == 200)) {
                                        if (signupController.signup.password
                                                .compareTo(signupController
                                                    .signup
                                                    .confirmPassword) ==
                                            0) {
                                          int statusCode =
                                              await signupController.postNewUser(dateUser: dateUser, context: context);
                                          if ((statusCode == 200) ||
                                              (statusCode == 201)) {
                                            created = true;
                                            int statusCodeLogin =
                                                await signupController.postLoginUser(context: context);
                                            if (statusCodeLogin == 201 ||
                                                statusCodeLogin == 200) {
                                              showSuccess(
                                                  "Cadastrado com Sucesso!",
                                                  "/main",
                                                  context);
                                            } else {
                                              showError(
                                                  "Erro ao logar",
                                                  "O Cadastro foi feito sucesso, entretando deu erro ao logar",
                                                  context);
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
                                    } : null,
                                    padding:
                                        EdgeInsets.fromLTRB(43, 12, 43, 12),
                                    child: Text('Confirmar',
                                        //Color(0xFF295492),(0xFF8A275D)
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18)),
                                  );
                                },
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
      );
    } catch (e) {
      print(e.toString());
      return CircularProgressIndicator();
    }
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
