import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/validations/user_validation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:convida/app/shared/models/login.dart';
import 'package:convida/app/shared/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _save = FlutterSecureStorage();
  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();

  //Controllers
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
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
                        height: queryData.size.height/2,
                        width: queryData.size.width/2,
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
                usernameInput(),

                //Password
                passwordInput(),

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
                                      int statusCode = await postLoginUser();
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
                                      } else if (statusCode == 401) {
                                        setState(() {
                                          msg = "Usuário ou senha inválido!";
                                        });
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
                                        showError("Erro Desconhecido",
                                            "StatusCode: $statusCode", context);
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

  Future<int> postLoginUser() async {
    AccountCredentials l = new AccountCredentials(
      username: _usernameController.text,
      password: _passwordController.text,
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
          _save.write(key: "user", value: _usernameController.text);
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
        //Get user:
        String id = _usernameController.text;
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

        _save.write(key: "name", value: "${user.name}");
        _save.write(key: "email", value: "${user.email}");
        _save.write(key: "lastName", value: "${user.lastName}");
      } catch (e) {
        showError("Erro desconhecido", "Erro: $e", context);
      }
    }
    return s;
  }

  Padding usernameInput() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _usernameController,
        autovalidate: true,
        maxLength: 11,
        decoration: InputDecoration(
            hintText: "Email ou GRR: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.person)),

        //Validations:
        validator: (value) {
          return grrValidation(value);
        },
      ),
    );
  }

  Padding passwordInput() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _passwordController,
        autovalidate: true,
        maxLength: 18,
        decoration: InputDecoration(
            hintText: "Senha: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.lock)),
        //Validations:
        validator: (value) {
          return passwordValidation(value, null);
        },
        obscureText: true,
      ),
    );
  }
}
