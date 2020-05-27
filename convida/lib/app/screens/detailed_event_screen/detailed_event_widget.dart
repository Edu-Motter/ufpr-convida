import 'package:convida/app/screens/detailed_event_screen/detailed_event_controller.dart';
import 'package:convida/app/shared/models/report.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:convida/app/shared/util/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:convida/app/screens/map_event_screen/map_event_screen_widget.dart';
import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:convida/app/shared/models/bfav.dart';
import 'package:convida/app/shared/models/event.dart';
import 'package:convida/app/shared/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailedEventWidget extends StatefulWidget {
  @override
  _DetailedEventWidgetState createState() => _DetailedEventWidgetState();
}

class _DetailedEventWidgetState extends State<DetailedEventWidget> {
  final _save = FlutterSecureStorage();

  final DetailedEventController detailedEventController =
      DetailedEventController();

  final TextEditingController reportController = new TextEditingController();
  String _url = globals.URL;
  final DateFormat formatter = new DateFormat.yMd("pt_BR").add_Hm();
  final DateFormat hour = new DateFormat.Hm();
  final DateFormat date = new DateFormat("EEE, d MMM", "pt_BR");
  final DateFormat dateSub = new DateFormat.MMMMEEEEd("pt_BR");
  final DateFormat test = new DateFormat.MMMM("pt_BR");
  String address =
      "";

  // bool fav;
  User eventAuthor;

  String token;

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final eventId = routeArgs['id'];
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    double containerHeight;
    if (queryData.size.height < 500){
      if (queryData.orientation == Orientation.portrait){
        containerHeight = queryData.size.height / 7.5;
      } else {
        containerHeight = queryData.size.height / 4.5;
      }
    } else {
      containerHeight = queryData.size.height / 10;
    }

    return FutureBuilder(
      future: getEvent(eventId),
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.data == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          DateTime dateStart = DateTime.parse(snapshot.data.dateStart);
          DateTime dateEnd = DateTime.parse(snapshot.data.dateEnd);
          DateTime hourStart = DateTime.parse(snapshot.data.hrStart);
          DateTime hourEnd = DateTime.parse(snapshot.data.hrEnd);
          DateTime subStart;
          DateTime subEnd;
          if (snapshot.data.startSub != null) {
            subStart = DateTime.parse(snapshot.data.startSub);
            subEnd = DateTime.parse(snapshot.data.endSub);
          }

          String _imageAsset = "";

          if (snapshot.data.type == 'Saúde e Bem-estar') {
            _imageAsset = 'type-health.png';
          } else if (snapshot.data.type == 'Esporte e Lazer') {
            _imageAsset = 'type-sport.png';
          } else if (snapshot.data.type == 'Festas e Comemorações') {
            _imageAsset = 'type-party.png';
          } else if (snapshot.data.type == 'Online') {
            _imageAsset = 'type-online.png';
          } else if (snapshot.data.type == 'Arte e Cultura') {
            _imageAsset = 'type-art.png';
          } else if (snapshot.data.type == 'Fé e Espiritualidade') {
            _imageAsset = 'type-faith.png';
          } else if (snapshot.data.type == 'Acadêmico e Profissional') {
            _imageAsset = 'type-graduation.png';
          } else {
            _imageAsset = 'type-others.png';
          }

          var column = Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12),
              Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Tipo de Evento: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${snapshot.data.type}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 3),
              Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Público alvo: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text("${snapshot.data.target}",
                            style: TextStyle(fontSize: 15))
                      ],
                    ),
                  )),
              SizedBox(height: 3),
              Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Link: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        InkWell(
                            child: Text("${snapshot.data.link}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.blueAccent)),
                            onTap: () => openLink(snapshot.data.link))
                      ],
                    ),
                  )),
            ],
          );

          return Scaffold(
            //It makes the page Fixed avoiding overflow when the keybord Appears
            resizeToAvoidBottomPadding: false,

            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                          centerTitle: true,
                          title: Text("${snapshot.data.name}"),
                          pinned: true,
                          floating: true),
                      SliverFixedExtentList(
                        itemExtent: 165.0,
                        delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset("assets/$_imageAsset"),
                                  )),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                              child: Container(
                                alignment: Alignment.topLeft,
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Text("${snapshot.data.name}",
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold)),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 0, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      3, 3, 3, 3),
                                              child: Icon(Icons.access_time,
                                                  size: 24),
                                            ),
                                            SizedBox(width: 3),
                                            Expanded(
                                              child: Text(
                                                "${date.format(dateStart)} - ${date.format(dateEnd)}",
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            42, 0, 0, 0),
                                        child: Text(
                                            "${hour.format(hourStart)} - ${hour.format(hourEnd)}",
                                            style: TextStyle(fontSize: 14)),
                                      ),

                                      //Endereço:
                                      snapshot.data.online
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      11, 8, 0, 0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.wifi, size: 24),
                                                  SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                        "Este evento é Online"),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 0, 0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.location_on,
                                                      size: 28),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    child: Text(
                                                        "${snapshot.data.address} - ${snapshot.data.complement}"),
                                                  )
                                                ],
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            //Description
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
                                        child: Text("Descrição do evento",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: SizedBox(
                                            width: 360,
                                            child: Text(
                                              "${snapshot.data.desc}",
                                              style: TextStyle(fontSize: 15),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                              child: Container(
                                alignment: Alignment.topLeft,
                                color: Colors.white,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: column),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                              alignment: Alignment.topLeft,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 6, 8, 2),
                                      child: Text("Contato",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.person, size: 28),
                                          SizedBox(width: 7),
                                          Text(
                                              "${eventAuthor.name} ${eventAuthor.lastName}",
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 15))
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.email, size: 28),
                                          SizedBox(width: 7),
                                          Text(
                                            "${eventAuthor.email}",
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            snapshot.data.startSub != null
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 8, 0),
                                              child: Text("Inscrições:",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 4, 4, 4),
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(3, 3, 3, 3),
                                                      child: Icon(Icons.timer,
                                                          size: 24),
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text("Início: ",
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(width: 3),
                                                    Expanded(
                                                      child: Text(
                                                          "${dateSub.format(subStart)}",
                                                          style: TextStyle(
                                                              fontSize: 16.0)),
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 4, 4, 4),
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(3, 3, 3, 3),
                                                      child: Icon(
                                                          Icons.timer_off,
                                                          size: 24),
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text("Fim: ",
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(width: 3),
                                                    Expanded(
                                                      child: Text(
                                                          "${dateSub.format(subEnd)}",
                                                          style: TextStyle(
                                                              fontSize: 16.0)),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        color: Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 8, 8, 0),
                                              child: Text("Não há inscrições",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            SizedBox(
                                              width: 360,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 14, 4, 4),
                                                child: Text(
                                                    "Infelizmente o organizador não informou datas de inscrições",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey)),
                                              ),
                                            )
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
                Container(
                  height: containerHeight,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          //*Link Buttom
                          // Expanded(
                          //   child: InkWell(
                          //     onTap: () async {
                          //       openLink(snapshot.data.link);
                          //     },
                          //     child: Column(
                          //       children: <Widget>[
                          //         Icon(
                          //           Icons.link,
                          //           size: 26,
                          //         ),
                          //         Text(
                          //           "Link",
                          //           maxLines: 1,
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                //Test:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapEventWidget(
                                        lat: snapshot.data.lat,
                                        lng: snapshot.data.lng,
                                      ),
                                    ));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.map, size: 26),
                                  Text("Ver no mapa", maxLines: 1)
                                ],
                              ),
                            ),
                          ),

                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (token != null) {
                                  if (detailedEventController.favorite ==
                                      true)
                                    _deleteEventFav(snapshot.data.id);
                                  else
                                    _putEventFav(snapshot.data.id);
                                } else {
                                  _showDialog("Necessário estar logado!",
                                      "Somente se você estiver logado será possível favoritar eventos, para isso, crie uma conta ou entre com seu login!");
                                }
                              },
                              child:
                                  Observer(builder: (BuildContext context) {
                                print(detailedEventController.favorite);
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    detailedEventController.favorite == true
                                        ? Icon(
                                            Icons.star,
                                            size: 26,
                                            color: Colors.amberAccent,
                                          )
                                        : Icon(Icons.star_border, size: 26),
                                    Text(
                                      "Favoritar",
                                      maxLines: 1,
                                    )
                                  ],
                                );
                              }),
                            ),
                          ),

                          snapshot.data.active == true
                              ? Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (token != null) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Observer(builder:
                                                (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Justificativa:"),
                                                content: textFieldWithoutIcon(
                                                    maxLines: 4,
                                                    onChanged:
                                                        detailedEventController
                                                            .setReport,
                                                    maxLength: 280,
                                                    labelText:
                                                        "Justifique sua Denúncia",
                                                    errorText:
                                                        detailedEventController
                                                            .validateReport),
                                                actions: <Widget>[
                                                  new FlatButton(
                                                    child:
                                                        new Text("Denúnciar"),
                                                    onPressed: () {
                                                      if (token != null) {
                                                        _putRerport(
                                                            snapshot.data.id,
                                                            detailedEventController
                                                                .report);
                                                        Navigator.pop(
                                                            context);
                                                      } else {
                                                        _showDialog(
                                                            "Necessário estar logado!",
                                                            "Somente se você estiver logado será possível Denúnciar eventos, para isso, crie uma conta ou entre com seu login!");
                                                      }
                                                    },
                                                  ),
                                                  new FlatButton(
                                                    child:
                                                        new Text("Cancelar"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                          },
                                        );
                                      } else {
                                        _showDialog(
                                            "Necessário estar logado!",
                                            "Somente se você estiver logado será possível Denúnciar eventos, para isso, crie uma conta ou entre com seu login!");
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.assignment_late, size: 26),
                                        Text("Denúnciar", maxLines: 1)
                                      ],
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.block, size: 26),
                                      Text("Desativado", maxLines: 1)
                                    ],
                                  ),
                                )
                        ]),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<Event> getEvent(String eventId) async {
    token = await _save.read(key: "token");
    final _id = await _save.read(key: "user");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    var jsonEvent;
    Event e;
    try {
      e = await http
          .get("$_url/events/$eventId")
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        if ((statusCode == 200) || (statusCode == 201)) {
          jsonEvent = json.decode(response.body);
          return Event.fromJson(jsonEvent);
        } else if (statusCode == 401) {
          showError(
              "Erro 401", "Não autorizado, favor logar novamente", context);
          return null;
        } else if (statusCode == 404) {
          showError("Erro 404", "Usuário não foi encontrado", context);
          return null;
        } else if (statusCode == 500) {
          showError("Erro 500",
              "Erro no servidor, favor tente novamente mais tarde", context);
          return null;
        } else {
          showError("Erro Desconhecido", "StatusCode: $statusCode", context);
          return null;
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }

    if (e != null) {
      eventAuthor = await getAuthor(e.author);
      if (eventAuthor != null) {
        var idEvent = e.id;
        String idUser = _id;
        Bfav fv = new Bfav(grr: idUser, id: idEvent);

        String body = json.encode(fv.toJson());

        try {
          var r = await http.post("$_url/users/isfav",
              body: body, headers: mapHeaders);

          if (r.statusCode == 200) {
            detailedEventController.setFavorite(true);
          } else if ((r.statusCode == 401) || (r.statusCode == 404)) {
            detailedEventController.setFavorite(false);
          } else if (r.statusCode == 500) {
            showError("Erro 500",
                "Erro no servidor, favor tente novamente mais tarde", context);
          }
        } catch (e) {
          showError("Erro desconhecido", "Erro: $e", context);
        }

        return e;
      } else {
        showError(
            "Erro ao carregar evento",
            "Infelizmente não foi possível carregar esse evento, tente novamente mais tarde",
            context);
        return e;
      }
    } else {
      showError(
          "Erro ao carregar evento",
          "Infelizmente não foi possível carregar esse evento, tente novamente mais tarde",
          context);
      return e;
    }
  }

  Future<User> getAuthor(String a) async {
    int statusCodeUser;

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    User author;
    try {
      author = await http
          .get("$_url/users/$a", headers: mapHeaders)
          .then((http.Response response) {
        statusCodeUser = response.statusCode;
        if (statusCodeUser == 200 || statusCodeUser == 201) {
          print("Author Sucess!");
          return User.fromJson(jsonDecode(response.body));
        } else if (statusCodeUser == 401) {
          showError(
              "Erro 401", "Não autorizado, favor logar novamente", context);
          return null;
        } else if (statusCodeUser == 404) {
          showError("Erro 404", "Autor não foi encontrado", context);
          return null;
        } else if (statusCodeUser == 500) {
          showError("Erro 500",
              "Erro no servidor, favor tente novamente mais tarde", context);
          return null;
        } else {
          showError(
              "Erro Desconhecido", "StatusCode: $statusCodeUser", context);
          return null;
        }
      });
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
      return null;
    }

    return author;
  }

  Future<String> getPlaceAddress(double lat, double lng) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDExnKlMmmFCZMh1okr26-JFz1anYRr9HE";
    final response = await http.get(url);

    print("Geocoding: ${response.statusCode}");
    print("Body: ${jsonDecode(response.body)}");
    return jsonDecode(response.body)['result'][0]['formatterd_address'];
  }

  openLink(String link) async {
    String url = 'http://$link';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showError("Impossível abrir o link",
          "Não foi possível abrir esse link: $link", context);
    }
  }

  Future _putEventFav(String eventId) async {
    final _save = FlutterSecureStorage();
    final _id = await _save.read(key: "user");
    final _token = await _save.read(key: "token");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    String idUser = _id;
    Bfav fv = new Bfav(grr: idUser, id: eventId);
    String body = json.encode(fv.toJson());

    var r;

    try {
      r = await http.post("$_url/users/fav", body: body, headers: mapHeaders);
      if (r.statusCode == 204) {
        detailedEventController.setFavorite(true);
      } else if (r.statusCode == 401) {
        showError("Erro 401", "Não autorizado, favor logar novamente", context);
      } else if (r.statusCode == 404) {
        showError("Erro 404", "Autor não foi encontrado", context);
      } else if (r.statusCode == 500) {
        showError("Erro 500",
            "Erro no servidor, favor tente novamente mais tarde", context);
      } else {
        showError("Erro Desconhecido", "StatusCode: ${r.statusCode}", context);
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }
  }

  Future _deleteEventFav(String eventId) async {
    final _id = await _save.read(key: "user");
    final _token = await _save.read(key: "token");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    String idUser = _id;
    Bfav fv = new Bfav(grr: idUser, id: eventId);
    String body = json.encode(fv.toJson());
    var r;

    try {
      r = await http.post("$_url/users/rfav", body: body, headers: mapHeaders);
      if (r.statusCode == 204) {
        detailedEventController.setFavorite(false);
      } else if (r.statusCode == 401) {
        showError("Erro 401", "Não autorizado, favor logar novamente", context);
      } else if (r.statusCode == 404) {
        showError("Erro 404", "Autor não foi encontrado", context);
      } else if (r.statusCode == 500) {
        showError("Erro 500",
            "Erro no servidor, favor tente novamente mais tarde", context);
      } else {
        showError("Erro Desconhecido", "StatusCode: ${r.statusCode}", context);
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }
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
                //Pop the Dialog
                Navigator.pop(context);
                //Push login screen
                Navigator.of(context)
                    .pushReplacementNamed("/login", arguments: "fav");
              },
            ),
            new FlatButton(
              child: new Text("Criar conta"),
              onPressed: () {
                //Push sign up screen
                Navigator.of(context)
                    .pushReplacementNamed("/signup", arguments: "fav");
              },
            ),
          ],
        );
      },
    );
  }

  _putRerport(String idEvent, String report) async {
    final _id = await _save.read(key: "user");
    final _token = await _save.read(key: "token");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    String idUser = _id;
    Report newReport = new Report(grr: idUser, report: report, ignored: false);
    String body = json.encode(newReport.toJson());
    var r;

    try {
      r = await http.put("$_url/events/report/$idEvent",
          body: body, headers: mapHeaders);
      if (r.statusCode == 200) {
        showSuccess("Evento Denúnciado com Sucesso!", "null", context);
      } else if (r.statusCode == 401) {
        showError("Erro 401", "Não autorizado, favor logar novamente", context);
      } else if (r.statusCode == 404) {
        showError("Erro 404", "Autor não foi encontrado", context);
      } else if (r.statusCode == 500) {
        showError("Erro 500",
            "Erro no servidor, favor tente novamente mais tarde", context);
      } else {
        showError("Erro Desconhecido", "StatusCode: ${r.statusCode}", context);
      }
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
    }
  }
}
