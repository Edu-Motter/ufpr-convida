import 'dart:async';
import 'dart:convert';

import 'package:convida/app/screens/organization_screen/organization_widget.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class MapWidget extends StatefulWidget {
  final String healthType;
  final String sportType;
  final String partyType;
  final String onlineType;
  final String artType;
  final String faithType;
  final String studyType;
  final String othersType;
  final String dataType;

  MapWidget(
      {Key key,
      this.healthType,
      this.sportType,
      this.partyType,
      this.onlineType,
      this.artType,
      this.faithType,
      this.studyType,
      this.othersType,
      this.dataType})
      : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState(healthType, sportType,
      partyType, onlineType, artType, faithType, studyType, othersType, dataType);
}

class _MapWidgetState extends State<MapWidget> {
  String healthType;
  String sportType;
  String partyType;
  String onlineType;
  String artType;
  String faithType;
  String studyType;
  String othersType;
  String dataType;

  _MapWidgetState(this.healthType, this.sportType, this.partyType, this.onlineType, this.artType,
      this.faithType, this.studyType, this.othersType, this.dataType);

  MapType _mapType;
  // Completer<GoogleMapController> _controller = Completer();
  //GoogleMapController mapController;
  Map<MarkerId, Marker> markersMaps = <MarkerId, Marker>{};
  String _url = globals.URL;
  var randID = Uuid();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  void initState() {
    super.initState();
    _mapType = MapType.normal;
    //print("Building Map");
  }

  @override
  Widget build(BuildContext context) {
    //setState(() {});
    return FutureBuilder(
        future: _getCurrentUserLocation(),
        builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else {
            //*Snapshot.Data == User Location --> Future Builder
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                //Google's Map:
                _googleMap(
                    context, snapshot.data.latitude, snapshot.data.longitude),

                //Search Text Field:
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Row(
                //     children: <Widget>[
                //       Expanded(
                //         child: Padding(
                //           padding: const EdgeInsets.fromLTRB(8.0, 40, 8, 8),
                //           child: RaisedButton(
                //             padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                //             child: Text(
                //               "Pesquisar Endereço",
                //               maxLines: 1,
                //               style: TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 20.0,
                //                   fontWeight: FontWeight.w500),
                //             ),
                //             onPressed: () {
                //               showDialog(
                //                   context: context,
                //                   builder: (BuildContext context) {
                //                     return AlertDialog(
                //                       title: new Text(
                //                           "Função em desenvolvimento!"),
                //                       content: new Text(
                //                           "Infelizmente ainda não conseguimos desenvolver totalmente essa funcionalidade."),
                //                       actions: <Widget>[
                //                         // usually buttons at the bottom of the dialog
                //                         new FlatButton(
                //                           child: new Text("Ok"),
                //                           onPressed: () {
                //                             Navigator.pop(context);
                //                           },
                //                         ),
                //                       ],
                //                     );
                //                   });
                //             },
                //             color: Color(0xFF295492),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Color(0xFF8A275D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrganizationWidget(
                                healthType: healthType,
                                sportType: sportType,
                                partyType: partyType,
                                onlineType: onlineType,
                                artType: artType,
                                faithType: faithType,
                                studyType: studyType,
                                othersType: othersType,
                                dataType: dataType,
                              ),
                            ));
                      },
                      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Text('Filtrar e Organizar',
                          maxLines: 1,
                          //Color(0xFF295492),(0xFF8A275D)
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ),
              ],
            );
          }
        });
  }

  Widget _googleMap(BuildContext context, double lat, double lng) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: _mapType,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: true,
          initialCameraPosition:
              CameraPosition(target: LatLng(lat, lng), zoom: 14),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onLongPress: (latlng) async {
            print("Verificando Token..");

            final _save = FlutterSecureStorage();
            String _token = await _save.read(key: "token");
            if (_token == null) {
              _showDialog("Necessário estar logado!",
                  "Somente se você estiver logado será possível criar eventos, para isso, crie uma conta ou entre com seu login!");
            } else {
              mapController = await _controller.future;
              mapController?.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(latlng.latitude, latlng.longitude),
                      zoom: 21.0)));
              //Max zoom is 21!
              //String id = _markerConfirm(latlng);
              String id = "";
              _confirmEvent(latlng, id, context);
            }
          },
          markers: Set<Marker>.of(markersMaps.values),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            //top: 110
            padding: const EdgeInsets.fromLTRB(0, 35, 5, 0),
            child: FloatingActionButton(
              heroTag: 1,
              onPressed: () async {
                print("teste!");
                mapController = await _controller.future;
                LocationData currentLocation;
                var location = new Location();
                try {
                  currentLocation = await location.getLocation();
                } on Exception {
                  currentLocation = null;
                }

                print(currentLocation);

                if (currentLocation != null) {
                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                      bearing: 0,
                      target: LatLng(
                          currentLocation.latitude, currentLocation.longitude),
                      zoom: 16.0,
                    ),
                  ));
                } else {
                  LatLng ufprLocation = new LatLng(-25.4269032, -49.2639545);

                  mapController.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                      bearing: 0,
                      target:
                          LatLng(ufprLocation.latitude, ufprLocation.longitude),
                      zoom: 16.0,
                    ),
                  ));
                }
              },
              mini: true,
              child: Icon(Icons.my_location),
              backgroundColor: Color(0xFF295492),
            ),
          ),
        ),
      ],
    );
  }

  Future<LatLng> _getCurrentUserLocation() async {
    print("Executou!!");
    markersMaps = await getMarkers(context);
    try {
      LocationData userLocation = await Location().getLocation();
      LatLng data = new LatLng(userLocation.latitude, userLocation.longitude);
      return data;
    } catch (e) {
      final String errorLocation =
          "Como não permitiu o acesso a sua localização, algumas funcionalidades do aplicativo serão comprometidas.";
      showError("Localização indisponível.", "$errorLocation", context);
      //This need to be final and global
      final LatLng ufprLocation = new LatLng(-25.4269032, -49.2639545);
      return ufprLocation;
    }
  }

  Future<Map<MarkerId, Marker>> getMarkers(BuildContext context) async {
    // print(
    //     "Type: |$healthType|\nType: |$sportType|\nType: |$partyType|\nType: |$artType|\nType: |$studyType|\nType: |$othersType|");

    String parsedHealthType = Uri.encodeFull(healthType);
    String parsedSportType = Uri.encodeFull(sportType);
    String parsedPartyType = Uri.encodeFull(partyType);
    String parsedOnlineType = Uri.encodeFull(onlineType);
    String parsedArtType = Uri.encodeFull(artType);
    String parsedFaithType = Uri.encodeFull(faithType);
    String parsedStudyType = Uri.encodeFull(studyType);
    String parsedOthersType = Uri.encodeFull(othersType);

    String requisition;

    //!Arrumar as requisições:

    if (dataType == 'week') {
      requisition =
          "$_url/events/weektype?text=$parsedHealthType&text1=$parsedSportType&text2=$parsedPartyType&text3=$parsedArtType&text4=$parsedFaithType&text5=$parsedStudyType&text6=$parsedOthersType&text7=$parsedOnlineType";
    } else if (dataType == 'day') {
      requisition =
          "$_url/events/todaytype?text=$parsedHealthType&text1=$parsedSportType&text2=$parsedPartyType&text3=$parsedArtType&text4=$parsedFaithType&text5=$parsedStudyType&text6=$parsedOthersType&text7=$parsedOnlineType";
    } else
      requisition =
          "$_url/events/multtype?text=$parsedHealthType&text1=$parsedSportType&text2=$parsedPartyType&text3=$parsedArtType&text4=$parsedFaithType&text5=$parsedStudyType&text6=$parsedOthersType&text7=$parsedOnlineType";

    var response;
    Map<MarkerId, Marker> mrks = <MarkerId, Marker>{};

    //*Create a marker because if something went wrong this marker returns
    var idZero = randID.v1();
    MarkerId markerZeroId = MarkerId("$idZero");
    Marker markerZero = Marker(
              markerId: markerZeroId,
              draggable: false,
              position: LatLng(-25.4202491,-49.2645976),
              infoWindow: InfoWindow(title: "UFPR Convida", snippet: "Não existem eventos"),
              icon: BitmapDescriptor.defaultMarker, 
      );

    try {
      response = await http.get(requisition);

      print("-------------------------------------------------------");
      print("$requisition");
      print("Status Code: ${response.statusCode}");
      print("Loading Event's Markers...");
      print("-------------------------------------------------------");

      var jsonEvents;

      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        jsonEvents = json.decode(response.body);

        MarkerId markerId;
        LatLng location;
        print("Loading event's markers..");
        for (var e in jsonEvents) {
          var id = randID.v1();
          //print("markedID: $id");
          markerId = MarkerId("$id");

          location = LatLng(e["lat"], e["lng"]);
          double color;
          String type = e["type"];

          //Marker color:
          if (type == "Saúde e Bem-estar") {
            color = 0.0; //Vermelho
          } else if (type == "Esporte e Lazer") {
            color = 120.0; //Verde
          } else if (type == "Festas e Comemorações") {
            color = 270.0; //Roxo
          } else if (type == "Online") {
            color = 170.0; //Ciano
          } else if (type == "Arte e Cultura") {
            color = 300.0; //Rosa
          } else if (type == "Fé e Espiritualidade") {
            color = 60.0; //Amarelo
          } else if (type == "Acadêmico e Profissional") {
            color = 225.0; //Azul
          } else {
            color = 30.0; //Laranja
          }

          Marker marker = Marker(
              markerId: markerId,
              draggable: false,
              position: location,
              infoWindow: InfoWindow(title: e["name"], snippet: e["link"]),
              icon: BitmapDescriptor.defaultMarkerWithHue(color),
              onTap: () {
                _showSnackBar(e["name"], e["id"], context);
              });

          mrks[markerId] = marker;
        }
      } else if (response.statusCode == 401) {
        showError("Erro 401", "Não autorizado, favor logar novamente", context);
        mrks[markerZeroId] = markerZero;
      } else if (response.statusCode == 404) {
        showError("Erro 404", "Evento não foi encontrado", context);
        mrks[markerZeroId] = markerZero;
      } else if (response.statusCode == 500) {
        showError(
            "Erro 500",
            "Erro no servidor, favor tente novamente mais tarde (Map)",
            context);
        mrks[markerZeroId] = markerZero;
      } else {
        showError(
            "Erro Desconhecido", "StatusCode: ${response.statusCode}", context);
        mrks[markerZeroId] = markerZero;
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
      mrks[markerZeroId] = markerZero;
    }
    return mrks;
  }

  void _showSnackBar(String eventName, String eventId, BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.fromLTRB(10, 16, 10, 0),
      borderRadius: 8,
      backgroundColor: Colors.white,

      boxShadows: [
        BoxShadow(color: Colors.black45, offset: Offset(3, 3), blurRadius: 3)
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      messageText: Text("Evento: $eventName",
          style: TextStyle(
              color: Color(0xFF295492),
              fontSize: 18,
              fontWeight: FontWeight.bold)),
      //message: "E",
      mainButton: FlatButton(
        child: Text("Visualizar"),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/event',
              arguments: {'id': eventId});
        },
      ),
      duration: Duration(seconds: 5),
    )..show(context);
  }

  void _confirmEvent(LatLng latLng, String id, BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.fromLTRB(10, 16, 10, 0),
      borderRadius: 8,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(color: Colors.black45, offset: Offset(3, 3), blurRadius: 3)
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      messageText: Text("Deseja criar um evento aqui?",
          style: TextStyle(
              color: Color(0xFF295492),
              fontSize: 18,
              fontWeight: FontWeight.bold)),
      mainButton: FlatButton(
        child: Text("Sim"),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, "/new-event",
              arguments: latLng);
          //print("Removendo marker: $id");
          //markers.remove(id);
        },
      ),
      duration: Duration(seconds: 8),
    )..show(context);
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Login"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),
            new FlatButton(
              child: new Text("Criar conta"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/signup");
              },
            ),
          ],
        );
      },
    );
  }
}
