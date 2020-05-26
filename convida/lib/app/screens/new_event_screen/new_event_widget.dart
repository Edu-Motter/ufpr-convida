import 'package:convida/app/screens/new_event_screen/new_event_controller.dart';
import 'package:convida/app/shared/DAO/util_requisitions.dart';
import 'package:convida/app/shared/util/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:convida/app/shared/global/globals.dart';
class NewEventWidget extends StatefulWidget {
  @override
  _NewEventWidgetState createState() => _NewEventWidgetState();
}

class _NewEventWidgetState extends State<NewEventWidget> {
  bool created = false;
  final newEventController = NewEventController();

  //Date now
  var now = DateTime.now();

  var hrStartMask = new MaskTextInputFormatter(
      mask: '##:##', filter: {"#": RegExp(r'[0-9]')});
  var hrEndMask = new MaskTextInputFormatter(
      mask: '##:##', filter: {"#": RegExp(r'[0-9]')});
  var dateStartMask = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var dateEndMask = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var subStartMask = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var subEndMask = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  //Event's Coords
  LatLng coords;

  //Dates:
  final DateFormat hour = new DateFormat("HH:mm");
  final DateFormat date = new DateFormat("dd/MM/yyyy");
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
    //"Online",
    "Arte e Cultura",
    "Fé e Espiritualidade",
    "Acadêmico e Profissional",
    "Outros",
  ];

  String _currentType = "Outros";

  //Switch:
  bool isSwitchedSubs = false;
  bool isOnline = false;

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
                  //Title
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Criando Novo Evento",
                        style: TextStyle(
                            color: Color(primaryColor), //Color(secondaryColor),
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  //Event Name:
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldInitialValue(
                          initialValue: newEventController.newEvent.target,
                          labelText: "Público alvo:",
                          icon: Icons.person_pin_circle,
                          onChanged: newEventController.newEvent.setTarget,
                          maxLength: 50,
                          errorText: newEventController.validateTarget);
                    }),
                  ),

                  //Event Description:
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


                  //Online Event
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: eventSwitchOnline()),
                  
                  //Event Address:
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

                  //Event Address Complement:
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldInitialValue(
                          initialValue: newEventController.newEvent.link,
                          labelText: "Link ou Email:",
                          icon: Icons.link,
                          onChanged: newEventController.newEvent.setLink,
                          maxLength: 100,
                          errorText: newEventController.validateLink);
                    }),
                  ),

                  //Event Hour Start:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldMask(
                          maskFormatter: hrStartMask,
                          keyboardType: TextInputType.datetime,
                          labelText: "Hora de Início:",
                          icon: Icons.watch_later,
                          initialValue: newEventController.newEvent.hrStart,
                          onChanged: newEventController.newEvent.setHrStart,
                          maxLength: 5,
                          errorText: newEventController.validadeHourStart);
                    }),
                  ),

                  //Event Hour End:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldMask(
                          maskFormatter: hrEndMask,
                          keyboardType: TextInputType.datetime,
                          labelText: "Hora de Fim:",
                          icon: Icons.watch_later,
                          initialValue: newEventController.newEvent.hrEnd,
                          onChanged: newEventController.newEvent.setHrEnd,
                          maxLength: 5,
                          errorText: newEventController.validadeHourEnd);
                    }),
                  ),

                  //Event Date Start:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldMask(
                          maskFormatter: dateStartMask,
                          keyboardType: TextInputType.datetime,
                          labelText: "Data de Início:",
                          icon: Icons.calendar_today,
                          initialValue: newEventController.newEvent.dateStart,
                          onChanged: newEventController.newEvent.setDateStart,
                          maxLength: 10,
                          errorText: newEventController.validadeDateStart);
                    }),
                  ),

                  //Date End Event:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Observer(builder: (_) {
                      return textFieldMask(
                          maskFormatter: dateEndMask,
                          keyboardType: TextInputType.datetime,
                          labelText: "Data de Fim:",
                          icon: Icons.calendar_today,
                          initialValue: newEventController.newEvent.dateEnd,
                          onChanged: newEventController.newEvent.setDateEnd,
                          maxLength: 10,
                          errorText: newEventController.validadeDateEnd);
                    }),
                  ),

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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Observer(builder: (_) {
                                      return textFieldMask(
                                          maskFormatter: subStartMask,
                                          keyboardType: TextInputType.datetime,
                                          labelText: "Data de Início:",
                                          icon: Icons.calendar_today,
                                          initialValue: newEventController
                                              .newEvent.subStart,
                                          onChanged: newEventController
                                              .newEvent.setSubStart,
                                          maxLength: 10,
                                          errorText: newEventController
                                              .validadeSubStart);
                                    }),
                                  ),

                                  //Subscriptions End:
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Observer(builder: (_) {
                                      return textFieldMask(
                                          maskFormatter: subEndMask,
                                          keyboardType: TextInputType.datetime,
                                          labelText: "Data de Fim:",
                                          icon: Icons.calendar_today,
                                          initialValue: newEventController
                                              .newEvent.subEnd,
                                          onChanged: newEventController
                                              .newEvent.setSubEnd,
                                          maxLength: 10,
                                          errorText: newEventController
                                              .validadeSubEnd);
                                    }),
                                  ),
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
                              color: Color(primaryColor),
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
                              onPressed: newEventController.loading ? null : () async {
                                //If pressed after creation, just redirect
                                if (created) {
                                  //Navigator.pop(context);
                                  Navigator.of(context)
                                      .pushReplacementNamed("/main");
                                }

                                if (created == false) {
                                  String error = "";
                                  //* Check all Inputs
                                  bool ok = newEventController.checkAll(
                                      context, isSwitchedSubs);

                                  if (ok) {
                                    //* Check all Dates
                                    error = newEventController
                                        .datesValidations(isSwitchedSubs);
                                    if (error != "") {
                                      showError(
                                          "Data Incorreta", "$error", context);
                                    } else {
                                      int statusCode =
                                          await newEventController.postNewEvent(
                                              _currentType,
                                              isSwitchedSubs,
                                              coords,
                                              isOnline,
                                              context);
                                      if ((statusCode == 200) ||
                                          (statusCode == 201)) {
                                        created = true;
                                        showSuccess(
                                            "Evento criado com Sucesso!",
                                            "/main",
                                            context);
                                      } else {
                                        errorStatusCode(statusCode, context, "Erro ao Criar evento");
                                      }
                                    }
                                  }
                                }
                              },
                              color: Color(secondaryColor),
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
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Observer(builder: (_) {
                          return newEventController.loading ? LinearProgressIndicator() : SizedBox();
                        }),
                      ),
                    )
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0,12.0,24.0,12.0),
                        child: Image.asset(
                          //Image:
                          "assets/logo-ufprconvida.png",
                          width: 400.0,
                          height: 400.0,
                          //color: Colors.white70,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Color(primaryColor),
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
                          color: Color(secondaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: () {
                            //When press Signup:
                            Navigator.of(context).pushNamed("/signup");
                          },
                          padding: EdgeInsets.fromLTRB(43, 12, 43, 12),
                          child: Text('Fazer Cadastro',
                              //Color(primaryColor),(secondaryColor)
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
                        color: Color(primaryColor),
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

  // Column eventHourStartOutput() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
  //         child: new Text(
  //           "Horário do início: ",
  //           style: TextStyle(fontSize: 16, color: Colors.black54),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: new Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             //Dia
  //             Text(
  //               "$showHrStart",
  //               style: TextStyle(fontSize: 16, color: Colors.black54),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Column eventHourEndOutput() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
  //         child: new Text(
  //           "Horário de fim: ",
  //           style: TextStyle(fontSize: 16, color: Colors.black54),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: new Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             //Dia
  //             Text(
  //               "$showHrEnd",
  //               style: TextStyle(fontSize: 16, color: Colors.black54),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Column eventDateStartOutput() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
  //         child: new Text(
  //           "Data de início: ",
  //           style: TextStyle(fontSize: 16, color: Colors.black54),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: new Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             //Dia
  //             Text(
  //               "$showDateStart",
  //               style: TextStyle(fontSize: 16, color: Colors.black54),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Column eventDateEndOutput() {
  //   return new Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
  //         child: new Text(
  //           "Data de fim: ",
  //           style: TextStyle(fontSize: 16, color: Colors.black54),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: new Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             //Dia
  //             Text(
  //               "$showDateEnd",
  //               style: TextStyle(fontSize: 16, color: Colors.black54),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

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

  Padding eventSwitchOnline() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(47, 8.0, 8.0, 8.0),
      child: Row(
        children: <Widget>[
          Text("Seu evento é Online ?",
              style: TextStyle(fontSize: 16, color: Colors.black54)),
          Switch(
              value: isOnline,
              onChanged: (value) {
                setState(() {
                  print("Executou um setState");
                  isOnline = value;
                });
              }),
        ],
      ),
    );
  }

  // Column eventSubsStartOutput() {
  //   return new Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
  //         child: new Text(
  //           "Inicio das Inscrições: ",
  //           style: TextStyle(fontSize: 16, color: Colors.black54),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: new Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             //Dia
  //             Text(
  //               "$showSubStart",
  //               style: TextStyle(fontSize: 16, color: Colors.black54),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Column eventSubsEndOutput() {
  //   return new Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
  //         child: new Text(
  //           "Fim das inscrições: ",
  //           style: TextStyle(fontSize: 16, color: Colors.black54),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: new Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             //Dia
  //             Text(
  //               "$showSubEnd",
  //               style: TextStyle(fontSize: 16, color: Colors.black54),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

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

  // Future<DateTime> _selectedDate(BuildContext context) => showDatePicker(
  //     context: context,
  //     initialDate: now,
  //     firstDate: now,
  //     lastDate: DateTime(2100));

  // Future<TimeOfDay> _selectedTime(BuildContext context) {
  //   final now = DateTime.now();
  //   return showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
  //   );
  // }
}
