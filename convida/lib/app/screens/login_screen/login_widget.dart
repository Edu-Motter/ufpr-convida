import 'package:convida/app/screens/alter_profile_screen/alter_profile_widget.dart';
import 'package:convida/app/screens/login_screen/login_controller.dart';
import 'package:convida/app/shared/DAO/util_requisitions.dart';
import 'package:convida/app/shared/models/user.dart';
import 'package:convida/app/shared/util/text_field_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:convida/app/shared/global/globals.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final loginController = new LoginController();
  String msg = '';

  

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    String where = "";
    try {
      where = ModalRoute.of(context).settings.arguments as String;
    } catch (e) {
      print(e.toString());
    }

    return WillPopScope(
      onWillPop: () {
        if (where == "map") {
          Navigator.pushReplacementNamed(context, '/main');
          return null;
        } else if ((where == "fav") || (where == "my-events")) {
          Navigator.pop(context);
          return null;
        } else {
          return null;
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          //appBar: AppBar(title: Text("Configurações")),
          body: ListView(
            children: <Widget>[
              (queryData.orientation == Orientation.portrait)
                  ? Container(
                      height: queryData.size.height / 6,
                      width: queryData.size.width / 6,
                      child: Image.asset(
                        //Image:
                        "assets/logo-ufprconvida.png",
                        scale: 2,
                      ),
                    )
                  : Container(
                      height: queryData.size.height / 4,
                      width: queryData.size.width / 4,
                      child: Image.asset(
                        //Image:
                        "assets/logo-ufprconvida.png",
                        scale: 2,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  alignment: Alignment.center,
                  child: Text("$msg",
                      style: TextStyle(
                        color: Color(primaryColor),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),

              //Login
              // usernameInput(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Observer(builder: (_) {
                  return textFieldInitialValue(
                      initialValue: loginController.login.user,
                      labelText: "CPF ou Passaporte (@ufpr caso servidor):",
                      icon: Icons.person,
                      onChanged: loginController.login.setUser,
                      maxLength: 50,
                      errorText: loginController.validateUser);
                }),
              ),

              //Password
              //passwordInput(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Observer(builder: (_) {
                  return textFieldObscure(
                      initialValue: loginController.login.password,
                      labelText: "Senha:",
                      icon: Icons.lock,
                      onChanged: loginController.login.setPassword,
                      maxLength: 30,
                      errorText: loginController.validatePassword);
                }),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(62.0, 0, 62.0, 0),
                  child: Observer(builder: (_) {
                    return loginController.loading
                        ? LinearProgressIndicator()
                        : SizedBox();
                  }),
                ),
              ),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //Botao Entrar
                    Container(
                        margin: const EdgeInsets.all(4.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Observer(builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Color(primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  onPressed: loginController.loading
                                      ? null
                                      : () async {
                                          bool valid = loginController
                                              .validadeLogin(context);
                                          // If the form is valid, must authenticate
                                          if (valid) {
                                            int statusCode =
                                                await loginController
                                                    .postLoginUser(context);
                                            if (statusCode == 200 ||
                                                statusCode == 201) {
                                              if ((where == "fav") ||
                                                  (where == "my-events")) {
                                                Navigator.pop(context);
                                              } else {
                                                Navigator.pushReplacementNamed(
                                                    context, '/main');
                                              }
                                            } else if (statusCode == 0) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AlterProfileWidget(
                                                      user: User(
                                                          name: null,
                                                          lastName: null,
                                                          login: loginController
                                                              .login.user,
                                                          birth: null,
                                                          email: null),
                                                    ),
                                                  ));
                                            } else {
                                              errorStatusCode(
                                                  statusCode,
                                                  context,
                                                  "Login ou Senha incorreto");
                                            }
                                          }
                                        },
                                  padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                                  child: Text('Entrar',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ),
                              );
                            }),
                            /* Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                color: Color(secondaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: () {
                                  
                                },
                                padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                                child: Text('Cadastrar',
                                    //Color(primaryColor),(secondaryColor)
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                color: Color(secondaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: () {
                                  //Navigator.pushNamed(context, "/recovery");
                                },
                                padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                                child: Text('Recuperar Senha',
                                    //Color(primaryColor),(secondaryColor)
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ), */
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                color: Color(primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: () {
                                  if (where == "map") {
                                    Navigator.pushReplacementNamed(
                                        context, '/main');
                                  } else if ((where == "fav") ||
                                      (where == "my-events")) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pushReplacementNamed(
                                        context, '/main');
                                  }
                                },
                                padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                                child: Text('Voltar',
                                    //Color(primaryColor),(secondaryColor)
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
