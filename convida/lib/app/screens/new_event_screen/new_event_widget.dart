import 'package:convida/app/screens/new_event_screen/new_event_controller.dart';
import 'package:convida/app/shared/util/text_field_widget.dart';
import 'package:convida/app/shared/validations/event_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:convida/app/shared/util/dialogs_widget.dart';

class NewEventWidget extends StatefulWidget {
  @override
  _NewEventWidgetState createState() => _NewEventWidgetState();
}

class _NewEventWidgetState extends State<NewEventWidget> {
  final _formKey = GlobalKey<FormState>();
  bool created = false;
  final newEventController = NewEventController();

  //Date now
  var now = DateTime.now();

  //Event's Coords
  LatLng coords;

  //Dates:
  final DateFormat formatter = new DateFormat.yMd("pt_BR");
  final DateFormat dateFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
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

  String _currentType = "Outros";

  //Switch:
  bool isSwitchedSubs = false;

  @override
  Widget build(BuildContext context) {
    coords = ModalRoute.of(context).settings.arguments as LatLng;

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed("/main");
        return null;
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: ListView(
                children: <Widget>[
                  //Tittle
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Criando Novo Evento",
                        style: TextStyle(
                            color: Color(0xFF295492), //Color(0xFF8A275D),
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  //Event Name:
                  //eventNameInput(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldInitialValue(
                          initialValue: newEventController.newEvent.name,
                          labelText: "Nome do Evento:",
                          icon: Icons.event_note,
                          onChanged: newEventController.newEvent.setName,
                          maxLength: 25,
                          errorText: newEventController.validateName);
                    }),
                  ),

                  //Event Target:
                  //eventTargetInput(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldInitialValue(
                          initialValue: newEventController.newEvent.target,
                          labelText: "Público alvo:",
                          icon: Icons.person_pin_circle,
                          onChanged: newEventController.newEvent.setTarget,
                          maxLength: 25,
                          errorText: newEventController.validateTarget);
                    }),
                  ),

                  //Event Description:
                  //eventDescInput(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldLines(
                          maxLines: 3,
                          initialValue: newEventController.newEvent.desc,
                          labelText: "Descrição:",
                          icon: Icons.person_pin_circle,
                          onChanged: newEventController.newEvent.setDesc,
                          maxLength: 250,
                          errorText: newEventController.validateDesc);
                    }),
                  ),

                  //Event Address:
                  //eventAddressInput(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldInitialValue(
                          initialValue: newEventController.newEvent.address,
                          labelText: "Endereço:",
                          icon: Icons.location_on,
                          onChanged: newEventController.newEvent.setAddress,
                          maxLength: 50,
                          errorText: newEventController.validateAddress);
                    }),
                  ),

                  //Event Addres Complement:
                  //eventComplementInput(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldInitialValue(
                          initialValue: newEventController.newEvent.complement,
                          labelText: "Complemento:",
                          icon: Icons.location_city,
                          onChanged: newEventController.newEvent.setComplement,
                          maxLength: 50,
                          errorText: newEventController.validateComplement);
                    }),
                  ),

                  //Event Link or Email:
                  //eventLinkInput(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldInitialValue(
                          initialValue: newEventController.newEvent.link,
                          labelText: "Link ou Email:",
                          icon: Icons.link,
                          onChanged: newEventController.newEvent.setLink,
                          maxLength: 50,
                          errorText: newEventController.validateLink);
                    }),
                  ),

                  //Event Hour Start:
                  Padding(
                      padding: const EdgeInsets.fromLTRB(47, 8, 8, 8),
                      child: Container(
                        decoration: containerDecoration(),
                        child: InkWell(
                          onTap: () async {
                            final selectedTime = await _selectedTime(context);
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
                              newEventController.newEvent.hrStart =
                                  dateFormat.format(selectedHrEventStart);
                              showHrStart =
                                  hourFormat.format(selectedHrEventStart);
                              print(
                                  "Formato data post: ${newEventController.newEvent.hrStart}");
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
                            final selectedTime = await _selectedTime(context);
                            if (selectedTime == null) return 0;

                            setState(() {
                              this.selectedHrEventEnd = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  selectedTime.hour,
                                  selectedTime.minute);
                              newEventController.newEvent.hrEnd =
                                  dateFormat.format(selectedHrEventEnd);
                              showHrEnd = hourFormat.format(selectedHrEventEnd);
                              print(
                                  "Formato hora post: ${newEventController.newEvent.hrEnd}");
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
                            final selectedDate = await _selectedDate(context);
                            if (selectedDate == null) return 0;

                            setState(() {
                              this.selectedDateEventStart = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  now.hour,
                                  now.minute);
                              newEventController.newEvent.dateStart =
                                  dateFormat.format(selectedDateEventStart);
                              showDateStart =
                                  formatter.format(selectedDateEventStart);
                              print(
                                  "Formato data post: ${newEventController.newEvent.dateStart}");
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
                            final selectedDate = await _selectedDate(context);
                            if (selectedDate == null) return 0;

                            setState(() {
                              this.selectedDateEventEnd = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  now.hour,
                                  now.minute);
                              //Format's:
                              newEventController.newEvent.dateEnd =
                                  dateFormat.format(selectedDateEventEnd);
                              showDateEnd =
                                  formatter.format(selectedDateEventEnd);
                              print("Formato data post: ${newEventController.newEvent.dateEnd}");
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                    child: new Text(
                                      "Tipo do evento: ",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    ),
                                  ),
                                  Observer(
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            3, 5, 20, 5),
                                        child: DropdownButton<String>(
                                            items: _dropDownMenuItemsTypes.map(
                                                (String dropDownStringIten) {
                                              return DropdownMenuItem<String>(
                                                  value: dropDownStringIten,
                                                  child:
                                                      Text(dropDownStringIten));
                                            }).toList(),
                                            onChanged: (String newType) {
                                              setState(() {
                                                _currentType = newType; 
                                              });
                                            },
                                            value: _currentType),
                                      );
                                    },
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
                      scrollDirection: Axis.horizontal,
                      child: eventSwitchSubs()),

                  Container(
                      child: isSwitchedSubs == true
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  //Subscriptions Start:
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          47, 8, 8, 8),
                                      child: Container(
                                        decoration: containerDecoration(),
                                        child: InkWell(
                                          onTap: () async {
                                            final selectedDate =
                                                await _selectedDate(context);
                                            if (selectedDate == null) return 0;

                                            final selectedTime =
                                                await _selectedTime(context);
                                            if (selectedDate == null) return 0;

                                            setState(() {
                                              this.selectedSubEventStart =
                                                  DateTime(
                                                      selectedDate.year,
                                                      selectedDate.month,
                                                      selectedDate.day,
                                                      selectedTime.hour,
                                                      selectedTime.minute);
                                              //Format's:
                                              newEventController
                                                      .newEvent.subStart =
                                                  dateFormat.format(
                                                      selectedSubEventStart);
                                              showSubStart = dateAndHour.format(
                                                  selectedSubEventStart);
                                              print(
                                                  "Formato data post: ${newEventController.newEvent.subStart}");
                                            });
                                            return 0;
                                          },
                                          child: eventSubsStartOutput(),
                                        ),
                                      )),

                                  //Subscriptions End:
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          47, 8, 8, 8),
                                      child: Container(
                                        decoration: containerDecoration(),
                                        child: InkWell(
                                          onTap: () async {
                                            final selectedDate =
                                                await _selectedDate(context);
                                            if (selectedDate == null) return 0;

                                            final selectedTime =
                                                await _selectedTime(context);
                                            if (selectedDate == null) return 0;

                                            setState(() {
                                              this.selectedSubEventEnd =
                                                  DateTime(
                                                      selectedDate.year,
                                                      selectedDate.month,
                                                      selectedDate.day,
                                                      selectedTime.hour,
                                                      selectedTime.minute);
                                              //Format's:
                                              newEventController
                                                      .newEvent.subEnd =
                                                  dateFormat.format(
                                                      selectedSubEventEnd);
                                              showSubEnd = dateAndHour
                                                  .format(selectedSubEventEnd);
                                              print(
                                                  "Formato data post: ${newEventController.newEvent.subEnd}");
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
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: EdgeInsets.all(12),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, "/main");
                              },
                              color: Color(0xFF295492),
                              child: Text(
                                "Cancelar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                              ),
                            ),
                            SizedBox(width: 30),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: EdgeInsets.all(12),
                              onPressed: () async {
                                //If pressed after creation, just redirect
                                if (created) {
                                  //Navigator.pop(context);
                                  Navigator.of(context)
                                      .pushReplacementNamed("/main");
                                }

                                //Validations
                                print("-------------Validations-------------");
                                if (created == false) {
                                  print("\tPassed the form validations");
                                  bool ok = true;

                                  //Data Validations:
                                  if (showHrStart.isEmpty) {
                                    showError(
                                        "Hora início não informada",
                                        "Favor informar hora de início do evento",
                                        context);
                                    ok = false;
                                  }
                                  if ((showHrEnd.isEmpty) && (ok == true)) {
                                    showError(
                                        "Hora fim não informada",
                                        "Favor informar hora de fim do evento",
                                        context);
                                    ok = false;
                                  }
                                  if ((showDateStart.isEmpty) && (ok == true)) {
                                    showError(
                                        "Data início não informada",
                                        "Favor informar data de início do evento",
                                        context);
                                    ok = false;
                                  }
                                  if ((showDateEnd.isEmpty) && (ok == true)) {
                                    showError(
                                        "Data fim não informada",
                                        "Favor informar data de fim do evento",
                                        context);
                                    ok = false;
                                  }

                                  if ((selectedDateEventStart
                                              .compareTo(selectedDateEventEnd) >
                                          0) &&
                                      (ok == true)) {
                                    ok = false;
                                    showError(
                                        "Data Incorreta",
                                        "A Data de Fim do Evento está inválida!",
                                        context);
                                  }

                                  //Subscritions Validations:
                                  if (isSwitchedSubs == true) {
                                    if ((selectedSubEventStart.compareTo(
                                                selectedSubEventEnd) >
                                            0) &&
                                        (ok == true)) {
                                      ok = false;
                                      showError(
                                          "Data Incorreta",
                                          "A Data de Fim das Incrições está inválida!",
                                          context);
                                    }

                                    if ((selectedSubEventStart.compareTo(
                                                selectedDateEventEnd) >
                                            0) &&
                                        (ok == true)) {
                                      ok = false;
                                      showError(
                                          "Data Incorreta",
                                          "A Data de Fim das Incrições está inválida!",
                                          context);
                                    }
                                    if ((selectedSubEventEnd.compareTo(
                                                selectedDateEventEnd) >
                                            0) &&
                                        (ok == true)) {
                                      ok = false;
                                      showError(
                                          "Data Incorreta",
                                          "Data de Fim das Incrições acabam depois do Evento finalizar!",
                                          context);
                                    }
                                  }

                                  if (ok == true) {
                                    int statusCode =
                                        await newEventController.postNewEvent(
                                            _currentType,
                                            isSwitchedSubs,
                                            coords,
                                            context);
                                    if ((statusCode == 200) ||
                                        (statusCode == 201)) {
                                      created = true;
                                      showSuccess("Evento criado com Sucesso!",
                                          "/main", context);
                                    } else if (statusCode == 401) {
                                      showError(
                                          "Erro 401",
                                          "Não autorizado, favor logar novamente",
                                          context);
                                    } else if (statusCode == 404) {
                                      showError(
                                          "Erro 404",
                                          "Evento ou usuário não foi encontrado",
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
                                }
                              },
                              color: Color(0xFF8A275D),
                              child: Text(
                                "Criar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                              ),
                            ),
                          ],
                        ),
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
  }

  Scaffold withoutLogin(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Botao Entrar
            Expanded(
              child: Container(
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
            ),
          ],
        ),
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
          width: 0.0,
        ));
  }

  Future<DateTime> _selectedDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100));

  Future<TimeOfDay> _selectedTime(BuildContext context) {
    final now = DateTime.now();
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }
}
