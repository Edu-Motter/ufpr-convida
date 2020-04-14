import 'package:convida/app/screens/report_screen/report_controller.dart';
import 'package:convida/app/screens/reported_event_screen/reported_widget.dart';
import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/models/mobx/event_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ReportWidget extends StatefulWidget {
  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  final controller = ReportController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Denuncias"),
      ),
      body: FutureBuilder(
        future: controller.getReportedEvents(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  "Não há eventos denunciados",
                  style: TextStyle(
                      color: Color(0xFF8A275D),
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else {
            controller.setListItems(snapshot.data);
            return ListView.builder(
                itemCount: controller.listItems.length,
                itemBuilder: (_, index) {
                  var event = controller.listItems[index];
                  return EventReportWidget(event: event);
                });
          }
        },
      ),
      // bottomNavigationBar: RaisedButton(
      //   color: Color(0xFF295492),
      //   // shape: RoundedRectangleBorder(
      //   //   borderRadius: BorderRadius.circular(24),
      //   // ),
      //   onPressed: () async {
      //     Navigator.of(context).pushReplacementNamed("/main");
      //   },
      //   padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
      //   child: Text('Voltar',
      //       style: TextStyle(color: Colors.white, fontSize: 18)),
      // ),
    );
  }
}

class EventReportWidget extends StatelessWidget {
  final Event event;

  const EventReportWidget({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventReportModel eventReport =
        EventReportModel(name: event.name, type: event.type, check: true);

    String _imageAsset;

    if (eventReport.type == 'Saúde e Bem-estar') {
      _imageAsset = 'type-health.png';
    } else if (eventReport.type == 'Esporte e Lazer') {
      _imageAsset = 'type-sport.png';
    } else if (eventReport.type == 'Festas e Comemorações') {
      _imageAsset = 'type-party.png';
    } else if (eventReport.type == 'Online') {
      _imageAsset = 'type-online.png';
    } else if (eventReport.type == 'Arte e Cultura') {
      _imageAsset = 'type-art.png';
    } else if (eventReport.type == 'Fé e Espiritualidade') {
      _imageAsset = 'type-faith.png';
    } else if (eventReport.type == 'Acadêmico e Profissional') {
      _imageAsset = 'type-graduation.png';
    } else {
      _imageAsset = 'type-others.png';
    }

    return Observer(
      builder: (_) {
        return ListTile(
          title: Text(eventReport.name),
          leading: Icon(Icons.event),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RerportedEventWidget(
                    event: event,
                  ),
                ));
          },
          // trailing: IconButton(
          //   color: Colors.green,
          //   icon: Icon(Icons.check),
          //   onPressed: () {},
          // ),
        );
      },
    );
  }
}
