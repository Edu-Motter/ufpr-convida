import 'dart:convert';
import 'dart:io';
import 'package:convida/app/screens/reported_event_screen/reported_event_controller.dart';
import 'package:convida/app/shared/DAO/util_requisitions.dart';
import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/models/report.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RerportedEventWidget extends StatefulWidget {
  final Event event;
  RerportedEventWidget({Key key, @required this.event}) : super(key: key);

  @override
  _RerportedEventWidgetState createState() => _RerportedEventWidgetState(event);
}

//! CLASSE COM NOME ERRADO !
class _RerportedEventWidgetState extends State<RerportedEventWidget> {
  Event event;
  _RerportedEventWidgetState(this.event);

  final controller = ReportedEventController();

  String _token;
  final _save = FlutterSecureStorage();
  String _url = globals.URL;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Denúncias do Evento"),
        ),
        body: FutureBuilder(
            future: controller.updateList(event.id, context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.connectionState);
              if (snapshot.data != null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: <Widget>[
                    Observer(builder: (_) {
                      return Expanded(
                        flex: 10,
                        child: ListView.builder(
                            itemCount: controller.listReports.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Observer(builder: (_) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 120,
                                  child: Card(
                                    child: ListTile(
                                      title: Text(
                                        controller
                                            .listReports[index].description,
                                        maxLines: 4,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "Reportado por: ${controller.listReports[index].author}",
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      trailing: InkWell(
                                        child: Icon(Icons.check_box,
                                            color: Colors.green, size: 32),
                                        onTap: () {
                                          showConfirm(
                                              title: "Remover denúncia",
                                              content:
                                                  "Deseja realmente remover esta denúncia?",
                                              onPressed: () {
                                                controller.removeReport(
                                                  controller.listReports[index],
                                                  context);
                                                Navigator.pop(context);
                                              },
                                              context: context);
                                        },
                                      ),
                                      onLongPress: () {
                                        showConfirm(
                                              title: "Remover denúncia",
                                              content:
                                                  "Deseja realmente remover esta denúncia?",
                                              onPressed: () {
                                                controller.removeReport(
                                                  controller.listReports[index],
                                                  context);
                                                Navigator.pop(context);
                                              },
                                              context: context);
                                      },
                                    ),
                                  ),
                                );
                              });
                            }),
                      );
                    }),
                    Expanded(
                      flex: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? 1
                          : 2,
                      child: Container(
                        color: Colors.white,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              // Expanded(
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(2.0),
                              //     child: InkWell(
                              //       onTap: () {
                              //         Navigator.of(context).pop();
                              //       },
                              //       child: Column(
                              //         children: <Widget>[
                              //           Padding(
                              //             padding:
                              //                 const EdgeInsets.only(top: 0.0),
                              //             child: Icon(
                              //               Icons.report_off,
                              //               size: 26,
                              //               color: Color(0xFF295492),
                              //             ),
                              //           ),
                              //           Text("Ignorar Denúncias")
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              event.active == true
                                  //Deactivate Event
                                  ? Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: InkWell(
                                          onTap: () async {
                                            bool success =
                                                await controller.getDeactivate(
                                                    event.id, context);
                                            if (success) {
                                              showSuccess("Evento Desativado",
                                                  "pop", context);
                                            }
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Icon(Icons.cancel,
                                                  size: 26, color: Colors.red),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0),
                                                child: Text("Desativar Evento"),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )

                                  //Ativate Event
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: InkWell(
                                          onTap: () async {
                                            bool success = await controller
                                                .getActivate(event.id, context);
                                            if (success) {
                                              showSuccess("Evento Ativado",
                                                  "pop", context);
                                            }
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Icon(Icons.check_circle,
                                                  size: 26,
                                                  color: Colors.green),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0),
                                                child: Text("Ativar Evento"),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                            ]),
                      ),
                    )
                  ],
                );
              }
            }),
      ),
      onWillPop: null,
    );
  }
}
