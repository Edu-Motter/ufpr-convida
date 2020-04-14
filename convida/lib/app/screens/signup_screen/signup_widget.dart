import 'package:convida/app/screens/signup_screen/signup_controller.dart';
import 'package:convida/app/shared/DAO/util_requisitions.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/util/text_field_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final signupController = SignupController();
  var dateMask = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

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
                            initialValue: signupController.signup.name,
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
                            initialValue: signupController.signup.lastName,
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
                            initialValue: signupController.signup.grr,
                            onChanged: signupController.signup.changeGrr,
                            maxLength: 11,
                            errorText: signupController.validadeGrr);
                      }),
                    ),

                    //User Birthday
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Observer(builder: (_) {
                        return textFieldMask(
                            maskFormatter: dateMask,
                            labelText: "Data de Nascimento:",
                            keyboardType: TextInputType.datetime,
                            icon: Icons.calendar_today,
                            initialValue: signupController.signup.birth,
                            onChanged: signupController.signup.changeBirth,
                            maxLength: 10,
                            errorText: signupController.validadeBirth);
                      }),
                    ),

                    //User email:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Observer(builder: (_) {
                        return textField(
                            labelText: "E-mail:",
                            icon: Icons.email,
                            initialValue: signupController.signup.email,
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
                            initialValue: signupController.signup.password,
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
                            initialValue:
                                signupController.signup.confirmPassword,
                            onChanged:
                                signupController.signup.changeConfirmPassword,
                            maxLength: 18,
                            errorText:
                                signupController.validadeConfirmPassword);
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
                                    onPressed: signupController.isValid
                                        ? () async {
                                            //*Check if created
                                            if (created) {
                                              Navigator.pushReplacementNamed(
                                                  context, '/main');
                                            } else {
                                              //*Check ALL inputs:
                                              bool ok = signupController
                                                  .checkAll(context);
                                              //If all inputs are OK:
                                              if (ok) {
                                                //*Check GRR
                                                int ok = await signupController
                                                    .checkGrr();

                                                //If error:
                                                if (ok == 500) {
                                                  String msg = "GRR Inválido!";
                                                  String error =
                                                      "O GRR informado já foi cadastrado";
                                                  showError(
                                                      msg, error, context);
                                                } else {
                                                  //*GRR to LowCase
                                                  if (signupController
                                                      .signup.grr
                                                      .startsWith("GRR")) {
                                                    signupController
                                                            .signup.grr =
                                                        signupController
                                                            .signup.grr
                                                            .toLowerCase();
                                                  }
                                                  // // Check pass
                                                  // if (signupController
                                                  //         .signup.password
                                                  //         .compareTo(signupController
                                                  //             .signup
                                                  //             .confirmPassword) ==
                                                  //     0) {
                                                  //*Arrumar data:
                                                  DateTime dateUser =
                                                      DateFormat("dd/MM/yyyy")
                                                          .parse(
                                                              signupController
                                                                  .signup
                                                                  .birth);
                                                  String datePost = dateFormat
                                                      .format(dateUser);

                                                  //*Post Event
                                                  int statusCode =
                                                      await signupController
                                                          .postNewUser(
                                                              dateUser:
                                                                  datePost,
                                                              context: context);

                                                  //*Check status Code
                                                  //*Sucesso
                                                  if ((statusCode == 200) ||
                                                      (statusCode == 201)) {
                                                    created = true;
                                                    int statusCodeLogin =
                                                        await signupController
                                                            .postLoginUser(
                                                                context:
                                                                    context);
                                                    if (statusCodeLogin ==
                                                            201 ||
                                                        statusCodeLogin ==
                                                            200) {
                                                      showSuccess(
                                                          "Cadastrado com Sucesso!",
                                                          "/main",
                                                          context);
                                                    } else {
                                                      errorStatusCode(
                                                          statusCodeLogin,
                                                          context,
                                                          "Erro ao se Cadastrar");
                                                    }
                                                  }                                                 
                                                }
                                              }
                                            }
                                          }
                                        : null,
                                    padding:
                                        EdgeInsets.fromLTRB(43, 12, 43, 12),
                                    child: Text('Confirmar',
                                        //Color(0xFF295492),(0xFF8A275D)
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
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

  // Future<DateTime> _selectedDate(BuildContext context) {
  //   DateTime now = DateTime.now();
  //   var lastDate = now.subtract(Duration(days: (12 * 365 + 3)));
  //   return showDatePicker(
  //       context: context,
  //       initialDate: DateTime(2000),
  //       firstDate: DateTime(1900),
  //       lastDate: lastDate);
  // }
}
