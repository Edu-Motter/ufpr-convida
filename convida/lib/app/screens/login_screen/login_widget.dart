
import 'package:convida/app/screens/login_screen/login_controller.dart';
import 'package:convida/app/shared/util/text_field_widget.dart';import 'package:convida/app/shared/validations/user_validation.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _save = FlutterSecureStorage();
  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();

  final loginController = new LoginController();

  //Controllers
  //final TextEditingController _usernameController = new TextEditingController();
  //final TextEditingController _passwordController = new TextEditingController();
  String msg = '';

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    print(queryData.orientation);

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
          body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                (queryData.orientation == Orientation.portrait)
                    ? Image.asset(
                        //Image:
                        "assets/logo-ufprconvida-sembordas.png",
                        scale: 2,
                      )
                    : Container(
                        height: queryData.size.height / 2,
                        width: queryData.size.width / 2,
                        child: Image.asset(
                          //Image:
                          "assets/logo-ufprconvida-sembordas.png",
                          scale: 2,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("$msg",
                        style: TextStyle(
                          color: Color(0xFF295492),
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
                        labelText: "GRR:",
                        icon: Icons.person,
                        onChanged: loginController.login.setUser,
                        maxLength: 11,
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
                        maxLength: 18,
                        errorText: loginController.validatePassword);
                  }),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Color(0xFF295492),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      // If the form is valid, must authenticate
                                      int statusCode = await loginController.postLoginUser(context);
                                      if (statusCode == 200 ||
                                          statusCode == 201) {
                                        final String user =
                                            await _save.read(key: "user");
                                        final String token =
                                            await _save.read(key: "token");

                                        print("User: $user");
                                        print("Token: $token}");

                                        if ((where == "fav") ||
                                            (where == "my-events")) {
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pushReplacementNamed(
                                              context, '/main');
                                        }
                                      } else {
                                        loginController.errorStatusCode(statusCode, context);
                                      }
                                      
                                    }
                                  },
                                  padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                                  child: Text('Entrar',
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
                                  onPressed: () {
                                    //When press Signup:
                                    Navigator.of(context).pushNamed("/signup",
                                        arguments: "login");
                                  },
                                  padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                                  child: Text('Cadastrar',
                                      //Color(0xFF295492),(0xFF8A275D)
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  color: Color(0xFF295492),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  onPressed: () {
                                    print(where);
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
                                      //Color(0xFF295492),(0xFF8A275D)
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
            ),
          )),
    );
  }

}
