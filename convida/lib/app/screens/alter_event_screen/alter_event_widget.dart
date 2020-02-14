import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/validations/event_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:convida/app/shared/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:convida/app/shared/models/user.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';

class AlterEventWidget extends StatefulWidget {
  final Event event;
  AlterEventWidget({Key key, @required this.event}) : super(key: key);
  @override
  _AlterEventWidgetState createState() => _AlterEventWidgetState(event);
}

class _AlterEventWidgetState extends State<AlterEventWidget> {
  Event event;
  _AlterEventWidgetState(this.event);

  String _url = globals.URL;
  final _formKey = GlobalKey<FormState>();
  bool created = false;
  final DateTime now = DateTime.now();

  //Dates:
  final DateFormat formatter = new DateFormat.yMd("pt_BR");
  final DateFormat postFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
  final DateFormat hourFormat = new DateFormat.Hm();
  final DateFormat dateAndHour = new DateFormat.yMd("pt_BR").add_Hm();

  String showHrStart = "";
  String showHrEnd = "";
  String showDateStart = "";
  String showDateEnd = "";
  String showSubStart = "";
  String showSubEnd = "";

  String postHrStart = "";
  String postHrEnd = "";
  String postDateEventStart = "";
  String postDateEventEnd = "";
  String postSubEventStart = "";
  String postSubEventEnd = "";

  DateTime selectedHrEventStart = DateTime.now();
  DateTime selectedHrEventEnd = DateTime.now();
  DateTime selectedDateEventStart = DateTime.now();
  DateTime selectedDateEventEnd = DateTime.now();
  DateTime selectedSubEventStart = DateTime.now();
  DateTime selectedSubEventEnd = DateTime.now();

  //Events Types
  var _dropDownMenuItemsTypes = [
    "Saúde e Bem-estar",
    "Esporte e Lazer",
    "Festas e Comemorações",
    "Cultura e Religião",
    "Acadêmico e Profissional",
    "Outros",
  ];

  String _currentType;
  //Switch:
  bool isSwitchedSubs = false;

  //Controllers:
  final TextEditingController _eventNameController =
      new TextEditingController();
  final TextEditingController _eventTargetController =
      new TextEditingController();
  final TextEditingController _eventDescController =
      new TextEditingController();
  final TextEditingController _eventLinkController =
      new TextEditingController();
  final TextEditingController _eventAddressController =
      new TextEditingController();
  final TextEditingController _eventComplementController =
      new TextEditingController();

  //Validators:
  RegExp _eventNameValidator =
      RegExp(r"^[a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.]{2,25}$");
  RegExp _eventTargetValidator =
      RegExp(r"^[a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.]{2,25}$");
  RegExp _eventDescValidator =
      RegExp(r"^([a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.@$%&]{2,250})$");
  //Talvez número?
  RegExp _eventAddressValidator =
      RegExp(r"^([a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.@$%&]{2,50})$");
  RegExp _eventComplementValidator =
      RegExp(r"^([a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ ,.]{2,50})$");

  RegExp _eventLinkValidator =
      RegExp(r"^([a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.@$%&]{2,35})$");

  @override
  void initState() {
    _eventNameController.text = event.name;
    _eventTargetController.text = event.target;
    _eventDescController.text = event.desc;
    _eventLinkController.text = event.link;
    _eventAddressController.text = event.address;
    _eventComplementController.text = event.complement;
    _currentType = event.type;

    DateTime parsedHrStart;
    DateTime parsedHrEnd;
    DateTime parsedDateStart;
    DateTime parsedDateEnd;
    DateTime parsedSubStart;
    DateTime parsedSubEnd;

    if (event.hrStart != null) {
      parsedHrStart = DateTime.parse(event.hrStart);
      selectedHrEventStart = parsedHrStart;
      postHrStart = postFormat.format(parsedHrStart);
      showHrStart = hourFormat.format(parsedHrStart);
    }
    if (event.hrEnd != null) {
      parsedHrEnd = DateTime.parse(event.hrEnd);
      selectedHrEventEnd = parsedHrEnd;
      postHrEnd = postFormat.format(parsedHrEnd);
      showHrEnd = hourFormat.format(parsedHrEnd);
    }
    if (event.dateStart != null) {
      parsedDateStart = DateTime.parse(event.dateStart);
      selectedHrEventStart = parsedDateStart;
      postDateEventStart = postFormat.format(parsedDateStart);
      showDateStart = formatter.format(parsedDateStart);
    }
    if (event.dateEnd != null) {
      parsedDateEnd = DateTime.parse(event.dateEnd);
      selectedDateEventEnd = parsedDateEnd;
      postDateEventEnd = postFormat.format(parsedDateEnd);
      showDateEnd = formatter.format(parsedDateEnd);
    }
    if (event.startSub != null) {
      parsedSubStart = DateTime.parse(event.startSub);
      selectedSubEventStart = parsedSubStart;
      postSubEventStart = postFormat.format(parsedSubStart);
      showSubStart = formatter.format(parsedSubStart);
    }
    if (event.endSub != null) {
      parsedSubEnd = DateTime.parse(event.endSub);
      selectedSubEventEnd = parsedSubEnd;
      postSubEventEnd = postFormat.format(parsedSubEnd);
      showSubEnd = formatter.format(parsedSubEnd);
    }

    if (event.startSub == null) {
      isSwitchedSubs = false;
    } else
      isSwitchedSubs = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).popAndPushNamed("/main");
        return null;
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              //Tittle
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Alterando Evento",
                    style: TextStyle(
                        color: Color(0xFF295492), //Color(0xFF8A275D),
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              //Event Name:
              eventNameInput(),

              //Event Target
              eventTargetInput(),

              //Event Description
              eventDescInput(),

              eventAddressInput(),

              eventComplementInput(),

              //Event Link or Email:
              eventLinkInput(),

              //Event Hour Start:
              Padding(
                  padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                  child: Container(
                    decoration: containerDecoration(),
                    child: InkWell(
                      onTap: () async {
                        final selectedTime =
                            await _selectedTime(context, selectedHrEventStart);
                        if (selectedTime == null) return 0;

                        setState(() {
                          print(
                              "${selectedTime.hour} : ${selectedTime.minute}");

                          this.selectedHrEventStart = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              selectedTime.hour,
                              selectedTime.minute);
                          postHrStart = postFormat.format(selectedHrEventStart);
                          showHrStart = hourFormat.format(selectedHrEventStart);
                          print("Formato data post: $postHrStart");
                        });
                        return 0;
                      },
                      child: eventHourStartOutput(),
                    ),
                  )),

              //Event Hour End
              Padding(
                  padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                  child: Container(
                    decoration: containerDecoration(),
                    child: InkWell(
                      onTap: () async {
                        final selectedTime =
                            await _selectedTime(context, selectedHrEventEnd);
                        if (selectedTime == null) return 0;

                        setState(() {
                          this.selectedHrEventEnd = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              selectedTime.hour,
                              selectedTime.minute);
                          postHrEnd = postFormat.format(selectedHrEventEnd);
                          showHrEnd = hourFormat.format(selectedHrEventEnd);
                          print("Formato hora post: $postHrEnd");
                        });
                        return 0;
                      },
                      child: eventHourEndOutput(),
                    ),
                  )),

              //Event Date Start:
              Padding(
                  padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                  child: Container(
                    decoration: containerDecoration(),
                    child: InkWell(
                      onTap: () async {
                        final selectedDate = await _selectedDate(
                            context, selectedDateEventStart);
                        if (selectedDate == null) return 0;

                        setState(() {
                          this.selectedDateEventStart = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              now.hour,
                              now.minute);
                          postDateEventStart =
                              postFormat.format(selectedDateEventStart);
                          showDateStart =
                              formatter.format(selectedDateEventStart);
                          print("Formato data post: $postDateEventStart");
                        });
                        return 0;
                      },
                      child: eventDateStartOutput(),
                    ),
                  )),

              //Date End Event:
              Padding(
                  padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                  child: Container(
                    decoration: containerDecoration(),
                    child: InkWell(
                      onTap: () async {
                        final selectedDate =
                            await _selectedDate(context, selectedDateEventEnd);
                        if (selectedDate == null) return 0;

                        setState(() {
                          selectedDateEventEnd = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              now.hour,
                              now.minute);
                          //Format's:
                          postDateEventEnd =
                              postFormat.format(selectedDateEventEnd);
                          showDateEnd = formatter.format(selectedDateEventEnd);
                          print("Formato data post: $postDateEventEnd");
                        });
                        return 0;
                      },
                      child: eventDateEndOutput(),
                    ),
                  )),

              //Event Category
              Padding(
                padding: const EdgeInsets.fromLTRB(47, 8.0, 8.0, 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          decoration: containerDecorationCategory(),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: new Text(
                                  "Tipo do evento: ",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 5, 20, 5),
                                child: DropdownButton<String>(
                                  items: _dropDownMenuItemsTypes
                                      .map((String dropDownStringIten) {
                                    return DropdownMenuItem<String>(
                                        value: dropDownStringIten,
                                        child: Text(dropDownStringIten));
                                  }).toList(),
                                  onChanged: (String newType) {
                                    setState(() {
                                      print("Executou um setState $newType");
                                      _currentType = newType;
                                    });
                                  },
                                  value: _currentType,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //Event Switch Subscriptions:
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal, child: eventSwitchSubs()),

              Container(
                  child: isSwitchedSubs == true
                      ? Container(
                          child: Column(
                            children: <Widget>[
                              //Subscriptions Start:
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(47, 8, 8, 8),
                                  child: Container(
                                    decoration: containerDecoration(),
                                    child: InkWell(
                                      onTap: () async {
                                        final selectedDate =
                                            await _selectedDate(
                                                context, selectedSubEventStart);
                                        if (selectedDate == null) return 0;

                                        setState(() {
                                          this.selectedSubEventStart = DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                          );
                                          //Format's:
                                          postSubEventStart = postFormat
                                              .format(selectedSubEventStart);
                                          showSubStart = formatter
                                              .format(selectedSubEventStart);
                                          print(
                                              "Formato data post: $postSubEventStart");
                                        });
                                        return 0;
                                      },
                                      child: eventSubsStartOutput(),
                                    ),
                                  )),

                              //Subscriptions End:
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(47, 8, 8, 8),
                                  child: Container(
                                    decoration: containerDecoration(),
                                    child: InkWell(
                                      onTap: () async {
                                        final selectedDate =
                                            await _selectedDate(
                                                context, selectedSubEventEnd);
                                        if (selectedDate == null) return 0;

                                        setState(() {
                                          this.selectedSubEventEnd = DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                          );
                                          //Format's:
                                          postSubEventEnd = postFormat
                                              .format(selectedSubEventEnd);
                                          showSubEnd = formatter
                                              .format(selectedSubEventEnd);
                                          print(
                                              "Formato data post: $postSubEventEnd");
                                        });
                                        return 0;
                                      },
                                      child: eventSubsEndOutput(),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : nothingToShow()),

              //Buttons:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.all(12),
                        onPressed: () {
                          Navigator.pop(context);
                          //Navigator.of(context).pushNamed("/main");
                        },
                        color: Color(0xFF295492),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                      ),
                      SizedBox(width: 30),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.all(12),
                        onPressed: () async {
                          if (created) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            // Navigator.of(context).popAndPushNamed("/main");
                          }
                          if ((_formKey.currentState.validate()) &&
                              (created == false)) {
                            bool ok = true;

                            //Data Validations:

                            if (showHrStart.isEmpty) {
                              showError("Hora início não informada",
                                  "Favor informar hora de início do evento", context);
                              ok = false;
                            }
                            if (showHrEnd.isEmpty) {
                              showError("Hora fim não informada",
                                  "Favor informar hora de fim do evento", context);
                              ok = false;
                            }
                            if (showDateStart.isEmpty) {
                              showError("Data início não informada",
                                  "Favor informar data de início do evento", context);
                              ok = false;
                            }
                            if (showDateEnd.isEmpty) {
                              showError("Data fim não informada",
                                  "Favor informar data de fim do evento", context);
                              ok = false;
                            }

                            if (selectedDateEventStart
                                    .compareTo(selectedDateEventEnd) >
                                0) {
                              ok = false;
                              showError("Data Incorreta",
                                  "A Data de Início do Evento está inválida!", context);
                            }

                            //Subscritions Validations:
                            if (isSwitchedSubs == true) {
                              if (selectedSubEventStart
                                      .compareTo(selectedSubEventEnd) >
                                  0) {
                                ok = false;
                                showError("Data Incorreta",
                                    "A Data de Início das Incrições está inválida!", context);
                              }

                              if (selectedSubEventStart
                                      .compareTo(selectedDateEventEnd) >
                                  0) {
                                ok = false;
                                showError("Data Incorreta",
                                    "A Data de Início das Incrições está inválida!", context);
                              }
                              if (selectedSubEventEnd
                                      .compareTo(selectedDateEventEnd) >
                                  0) {
                                ok = false;
                                showError("Data Incorreta",
                                    "Data de Fim das Incrições acabam depois do Evento finalizar!", context);
                              }
                            }

                            if (ok == true) {
                              int statusCode = await putEvent();
                              if ((statusCode == 200) || (statusCode == 201)) {
                                showSuccess("Evento Alterado com sucesso!","pop",context);
                              } else if (statusCode == 401) {
                                showError("Erro 401",
                                    "Não autorizado, favor logar novamente", context);
                              } else if (statusCode == 404) {
                                showError("Erro 404",
                                    "Evento ou usuário não foi encontrado", context);
                              } else if (statusCode == 500) {
                                showError("Erro 500",
                                    "Erro no servidor, favor tente novamente mais tarde", context);
                              } else {
                                showError("Erro Desconhecido",
                                    "StatusCode: $statusCode", context);
                              }
                              created = true;
                            }
                          }
                        },
                        color: Color(0xFF8A275D),
                        child: Text(
                          "Alterar",
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Scaffold withoutLogin(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Botao Entrar
            Container(
                margin: const EdgeInsets.all(4.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset(
                      //Image:
                      "assets/logo-ufprconvida-sembordas.png",
                      width: 400.0,
                      height: 400.0,
                      //color: Colors.white70,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Color(0xFF295492),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/login");
                        },
                        padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                        child: Text('Fazer Login',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
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
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/signup");
                        },
                        padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                        child: Text('Fazer Cadastro',
                            //Color(0xFF295492),(0xFF8A275D)
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 50),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.all(12),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed("/main");
                      },
                      color: Color(0xFF295492),
                      child: Text(
                        "Voltar",
                        style: TextStyle(color: Colors.white, fontSize: 17.0),
                      ),
                    ),
                    SizedBox(height: 30)
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<int> putEvent() async {
    final _save = FlutterSecureStorage();
    final _id = await _save.read(key: "user");
    final _token = await _save.read(key: "token");
    User user;
    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    try {
      user = await http
          .get("$_url/users/$_id", headers: mapHeaders)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        if ((statusCode == 200) || (statusCode == 201)) {
          return User.fromJson(jsonDecode(response.body));
        } else {
          showError("Erro no servidor", "Erro: $statusCode", context);
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }

    if (isSwitchedSubs == false) {
      postSubEventStart = "";
      postSubEventEnd = "";
    }

    Event p = new Event(
        id: event.id,
        name: _eventNameController.text,
        target: _eventTargetController.text,
        desc: _eventDescController.text,
        hrStart: postHrStart,
        hrEnd: postHrEnd,
        dateStart: postDateEventStart,
        dateEnd: postDateEventEnd,
        link: _eventLinkController.text,
        type: _currentType,
        address: _eventAddressController.text,
        complement: _eventComplementController.text,
        startSub: postSubEventStart,
        endSub: postSubEventEnd,
        author: user.grr,
        lat: event.lat,
        lng: event.lng);

    String eventJson = json.encode(p.toJson());

    int code;
    try {
      code = await http
          .put("$_url/events/${event.id}", body: eventJson, headers: mapHeaders)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        if ((statusCode == 200) || (statusCode == 201)) {
          print("Put Event Success!");
          return statusCode;
        } else {
          print("Put Evento Error: $statusCode");
          return statusCode;
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }

    return code;
  }

  Padding eventNameInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidate: true,
        maxLength: 25,
        controller: _eventNameController,
        decoration: InputDecoration(
            hintText: "Nome do evento: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.event_note)),
        //Validations:
        validator: (value) {
          return nameValidation(value);
        },
      ),
    );
  }

  Padding eventTargetInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidate: true,
        maxLength: 25,
        controller: _eventTargetController,
        decoration: InputDecoration(
            hintText: "Público alvo: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.person_pin_circle)),
        //Validations:
        validator: (value) {
          return targetValidation(value);
        },
      ),
    );
  }

  Padding eventDescInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidate: true,
        maxLength: 250,
        controller: _eventDescController,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: "Descrição: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.note)),
        //Validations:
        validator: (value) {
          return descriptionValidation(value);
        },
      ),
    );
  }

  Padding eventAddressInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidate: true,
        maxLength: 50,
        controller: _eventAddressController,
        decoration: InputDecoration(
            hintText: "Endereço: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.location_on)),
        //Validations:
        validator: (value) {
          return addressValidation(value);
        },
      ),
    );
  }

  Padding eventComplementInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidate: true,
        maxLength: 50,
        controller: _eventComplementController,
        decoration: InputDecoration(
            hintText: "Complemento: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.location_city)),
        //Validations:
        validator: (value) {
          return complementValidation(value);
        },
      ),
    );
  }

  Padding eventLinkInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _eventLinkController,
        autovalidate: true,
        maxLength: 50,
        decoration: InputDecoration(
            hintText: "Link ou Email: ",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
            icon: Icon(Icons.link)),
        //Validations:
        validator: (value) {
          return linkValidation(value);
        },
      ),
    );
  }

  Column eventHourStartOutput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Horário do início: ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Dia
              Text(
                "$showHrStart",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column eventHourEndOutput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Horário de fim: ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Dia
              Text(
                "$showHrEnd",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column eventDateStartOutput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Data de início: ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Dia
              Text(
                "$showDateStart",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column eventDateEndOutput() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Data de fim: ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Dia
              Text(
                "$showDateEnd",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Padding eventSwitchSubs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(47, 8.0, 8.0, 8.0),
      child: Row(
        children: <Widget>[
          Text("Seu evento tem datas de inscrições?",
              style: TextStyle(fontSize: 16, color: Colors.black54)),
          Switch(
              value: isSwitchedSubs,
              onChanged: (value) {
                setState(() {
                  print("Executou um setState");
                  isSwitchedSubs = value;
                });
              }),
        ],
      ),
    );
  }

  Column eventSubsStartOutput() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Inicio das Inscrições: ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Dia
              Text(
                "$showSubStart",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column eventSubsEndOutput() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
          child: new Text(
            "Fim das inscrições: ",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Dia
              Text(
                "$showSubEnd",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<DateTime> _selectedDate(BuildContext context, DateTime date) {
    if (date.compareTo(now) > 0) {
      return showDatePicker(
          context: context,
          initialDate: date,
          firstDate: now,
          lastDate: DateTime(2100));
    } else {
      return showDatePicker(
          context: context,
          initialDate: date,
          firstDate: date,
          lastDate: DateTime(2100));
    }
  }

  Container nothingToShow() {
    return Container(
      child: SizedBox(width: 0),
    );
  }

  BoxDecoration containerDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(4.5),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ));
  }

  BoxDecoration containerDecorationCategory() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(4.5),
        border: Border.all(
          color: Colors.white,
          width: 1.0,
        ));
  }

  Future<TimeOfDay> _selectedTime(BuildContext context, DateTime date) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
    );
  }
}
