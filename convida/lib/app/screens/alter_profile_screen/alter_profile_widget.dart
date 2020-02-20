import 'package:convida/app/screens/alter_profile_screen/alter_profile_controller.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/util/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:convida/app/shared/models/user.dart';

class AlterProfileWidget extends StatefulWidget {
  final User user;

  AlterProfileWidget({Key key, @required this.user}) : super(key: key);

  @override
  _AlterProfileWidgetState createState() => _AlterProfileWidgetState(user);
}

class _AlterProfileWidgetState extends State<AlterProfileWidget> {
  final profileController = AlterProfileController();
  User user;

  _AlterProfileWidgetState(this.user);

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

  bool isSwitchedPassword = false;

  @override
  void initState() {
    //Future Builder!
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
    return FutureBuilder(
      future: profileController.getProfile(user: user, context: context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.data == true) {
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
              body: Column(
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
                                  color:
                                      Color(0xFF295492), //Color(0xFF8A275D),
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        //User first name:

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Observer(builder: (_) {
                            return textFieldController(
                                controller: _userFirstNameController,
                                labelText: "Nome:",
                                icon: Icons.person,
                                onChanged:
                                    profileController.profile.changeName,
                                maxLength: 25,
                                errorText: profileController.validateName);
                          }),
                        ),

                        //userFirstName(),

                        //User last name
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Observer(builder: (_) {
                            return textFieldController(
                                controller: _userLastNameController,
                                labelText: "Sobrenome:",
                                icon: Icons.navigate_next,
                                onChanged:
                                    profileController.profile.changeLastName,
                                maxLength: 25,
                                errorText:
                                    profileController.validadeLastName);
                          }),
                        ),
                        //userLastName(),

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
                                        postFormat.format(selectedDateUser);
                                    showDateUser =
                                        formatter.format(selectedDateUser);
                                    print("Formato data post: $dateUser");
                                  });
                                  return 0;
                                },
                                child: new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 180, 0),
                                      child: new Text(
                                        "Data de Nasc.: ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54),
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
                            return textFieldController(
                                controller: _userEmailController,
                                labelText: "E-mail:",
                                icon: Icons.email,
                                onChanged:
                                    profileController.profile.changeEmail,
                                maxLength: 50,
                                errorText: profileController.validadeEmail);
                          }),
                        ),
                        //userEmail(),

                        //Switch
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(47, 8.0, 8.0, 8.0),
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
                              //Switch on:
                              ? Container(
                                  child: Column(
                                    children: <Widget>[
                                      //Old Password:
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Observer(builder: (_) {
                                          return textFieldObscure(
                                              labelText: "Senha:",
                                              icon: Icons.lock,
                                              onChanged: profileController
                                                  .profile.changePassword,
                                              maxLength: 18,
                                              errorText: profileController
                                                  .validadePassword);
                                        }),
                                      ),

                                      //New Password:
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Observer(builder: (_) {
                                          return textFieldObscure(
                                              labelText: "Nova senha:",
                                              icon: Icons.lock,
                                              onChanged: profileController
                                                  .profile.changeNewPassword,
                                              maxLength: 18,
                                              errorText: profileController
                                                  .validadeNewPassword);
                                        }),
                                      ),

                                      //Confirm New Password:
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Observer(builder: (_) {
                                          return textFieldObscure(
                                              labelText: "Confirmar senha:",
                                              icon: Icons.lock,
                                              onChanged: profileController
                                                  .profile
                                                  .changeConfirmPassword,
                                              maxLength: 18,
                                              errorText: profileController
                                                  .validadeNewPassword);
                                        }),
                                      ),
                                    ],
                                  ),
                                )

                              //Switch off:
                              //Just the Password:
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Observer(builder: (_) {
                                    return textFieldObscure(
                                        labelText: "Senha:",
                                        icon: Icons.lock,
                                        onChanged: profileController
                                            .profile.changePassword,
                                        maxLength: 18,
                                        errorText: profileController
                                            .validadePassword);
                                  }),
                                ),
                        ),

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
                                    padding:
                                        EdgeInsets.fromLTRB(45, 12, 45, 12),
                                    child: Text('Cancelar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18)),
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
                                      if (created) {
                                        Navigator.of(context)
                                            .pushReplacementNamed("/main");
                                      } else if ((user.name ==
                                              profileController
                                                  .profile.name) &&
                                          (user.lastName ==
                                              profileController
                                                  .profile.lastName) &&
                                          (user.email ==
                                              profileController
                                                  .profile.email) &&
                                          (oldDateUser == dateUser) &&
                                          (isSwitchedPassword == false)) {
                                        String error = "Sem Alterações";
                                        String desc =
                                            "Não existe nada alterado";
                                        showError(error, desc, context);
                                      } else if (profileController
                                              .profile.password ==
                                          profileController
                                              .profile.newPassword) {
                                        String error = "Senhas iguais";
                                        String desc =
                                            "A senha nova é igual a antiga";
                                        showError(error, desc, context);
                                      } else if (created == false) {
                                        bool correct =
                                            await profileController.passCheck(
                                                user: user, context: context);

                                        if (correct) {
                                          int statusCode =
                                              await profileController.putUser(
                                                  isSwitch:
                                                      isSwitchedPassword,
                                                  user: user,
                                                  dateUser: dateUser,
                                                  context: context);
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
                                            showError(
                                                "Erro Desconhecido",
                                                "StatusCode: $statusCode",
                                                context);
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
                                    padding:
                                        EdgeInsets.fromLTRB(43, 12, 43, 12),
                                    child: Text('Alterar',
                                        //Color(0xFF295492),(0xFF8A275D)
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18)),
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
          );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
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
