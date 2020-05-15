import 'package:convida/app/shared/models/user.dart';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:convida/app/screens/alter_event_screen/alter_event_widget.dart';
import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:convida/app/shared/models/event.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDetailedEventWidget extends StatefulWidget {
  @override
  _MyDetailedEventWidgetState createState() => _MyDetailedEventWidgetState();
}

class _MyDetailedEventWidgetState extends State<MyDetailedEventWidget> {
  String _url = globals.URL;
  final DateFormat formatter = new DateFormat.yMd("pt_BR").add_Hm();
  final DateFormat hour = new DateFormat.Hm();
  final DateFormat date = new DateFormat("EEE, d MMM", "pt_BR");
  final DateFormat dateSub = new DateFormat.MMMMEEEEd("pt_BR");
  final DateFormat test = new DateFormat.MMMM("pt_BR");
  String address =
      "R. Dr. Alcides Vieira Arcoverde, 1225 - Jardim das Américas, Curitiba - PR, 81520-260";

  bool fav = false;
  User eventAuthor;

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
        future: getMyEvent(eventId),
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.data == null) {
            return Container(
              color: Colors.white,
              child: Center(
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

            return Scaffold(
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
                            itemExtent: 150.0,
                            delegate: SliverChildListDelegate(
                              [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child:
                                            Image.asset("assets/$_imageAsset"),
                                      )),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    color: Colors.white,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 3, 8, 3),
                                            child: Text("${snapshot.data.name}",
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                                    style: TextStyle(
                                                        fontSize: 16.0),
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
                                                      Icon(Icons.wifi,
                                                          size: 24),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    color: Colors.white,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 8, 0),
                                            child: Text("Descrição do evento",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    color: Colors.white,
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        14, 4, 4, 4),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Tipo de Evento: ",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "${snapshot.data.type}",
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                            SizedBox(height: 3),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        14, 4, 4, 4),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Público alvo: ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                      Text(
                                                          "${snapshot.data.target}",
                                                          style: TextStyle(
                                                              fontSize: 15))
                                                    ],
                                                  ),
                                                )),
                                            SizedBox(height: 3),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        14, 4, 4, 4),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Link: ",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      InkWell(
                                                          child: Text(
                                                              "${snapshot.data.link}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontSize:
                                                                      15)),
                                                          onTap: () => openLink(
                                                              snapshot
                                                                  .data.link))
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        )),
                                  ),
                                ),

                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 6, 0, 6),
                                  alignment: Alignment.topLeft,
                                  color: Colors.white,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 6, 8, 2),
                                          child: Text("Contato",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.person, size: 28),
                                              SizedBox(width: 7),
                                              Text(
                                                  "${eventAuthor.name} ${eventAuthor.lastName}",
                                                  maxLines: 1,
                                                  style:
                                                      TextStyle(fontSize: 15))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 6),
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
                                                    padding: const EdgeInsets
                                                        .fromLTRB(14, 4, 4, 4),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  3, 3, 3, 3),
                                                          child: Icon(
                                                              Icons.timer,
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
                                                                  fontSize:
                                                                      16.0)),
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(14, 4, 4, 4),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  3, 3, 3, 3),
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
                                                                  fontSize:
                                                                      16.0)),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 6),
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
                                                  child: Text(
                                                      "Não há inscrições",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Center(
                                                  child: SizedBox(
                                                    width: 360,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          14, 14, 4, 4),
                                                      child: Text(
                                                          "Infelizmente o organizador não informou datas de inscrições",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.grey)),
                                                    ),
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
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: InkWell(
                                  onTap: () {
                                    DateTime yesterday = DateTime.now()
                                        .subtract(Duration(hours: 24));

                                    if ((yesterday.compareTo(dateEnd)) > 0) {
                                      //If the event ended:
                                      _showError("Evento Finalizado",
                                          "Não é possível alterar mais esse evento, pois ele já foi encerrado!");
                                    } else {
                                      //If doesn't end, User can edit:
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AlterEventWidget(
                                              event: snapshot.data,
                                            ),
                                          ));
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child:
                                            Icon(Icons.event_note, size: 26),
                                      ),
                                      Text("Alterar")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: InkWell(
                                  onTap: () async {
                                    int delete = _confirmDelete(
                                        snapshot.data.id, snapshot.data.name);
                                    if (delete == 1) {
                                      int status = await deleteMyEvent(
                                          snapshot.data.id);
                                      if (status == 200) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        // Navigator.popAndPushNamed(
                                        //     context, '/main');
                                      } else
                                        _showWarning();
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.delete_forever, size: 26),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 0.0),
                                        child: Text("Deletar"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    )
                  ],
                ));
          }
        });
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

  Future<Event> getMyEvent(eventId) async {
    var response;
    try {
      response = await http.get("$_url/events/$eventId");
      var jsonEvent;
      if ((response.statusCode == 200) || (response.statusCode == 201)) {
        jsonEvent = json.decode(response.body);
        Event e = Event.fromJson(jsonEvent);
        eventAuthor = await getAuthor(e.author);
        if (eventAuthor != null) {
          return e;
        } else {
          showError(
              "Erro ao carregar evento",
              "Infelizmente não foi possível carregar esse evento, tente novamente mais tarde",
              context);
          return e;
        }
      } else if (response.statusCode == 401) {
        showError("Erro 401", "Não autorizado, favor logar novamente", context);
        return null;
      } else if (response.statusCode == 404) {
        showError("Erro 404", "Autor não foi encontrado", context);
        return null;
      } else if (response.statusCode == 500) {
        // showError("Erro 500",
        //     "Erro no servidor, favor tente novamente mais tarde (AQUI)", context);
        return null;
      } else {
        showError(
            "Erro Desconhecido", "StatusCode: ${response.statusCode}", context);
        return null;
      }
    } catch (e) {
      if (e.toString().contains("at character 1")) {
        return null;
      } else {
        showError("Erro desconhecido ao deletar!", "Erro: $e", context);
        return null;
      }
    }
  }

  Future<int> deleteMyEvent(eventId) async {
    final _save = FlutterSecureStorage();
    String _token = await _save.read(key: "token");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };
    var response;
    try {
      response =
          await http.delete("$_url/events/$eventId", headers: mapHeaders);
      print("Deletando: $_url/events/$eventId");
      int statusCode = response.statusCode;
      print("StatusCode DEL:$statusCode");
      return response.statusCode;
    } catch (e) {
      showError("Erro desconhecido", "Erro: $e", context);
      return 500;
    }
  }

  void _showError(String title, String content) {
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
          ],
        );
      },
    );
  }

  int _confirmDelete(String eventId, String eventName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Deletar Evento"),
          content:
              new Text("Deseja realmente deletear o evento \"$eventName\"?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Sim"),
              onPressed: () async {
                int statusCode = await deleteMyEvent(eventId);
                if (statusCode == 200) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //Mudei aqui
                  //Navigator.pushReplacementNamed(context, "/main");

                  // Navigator.pushNamed(context, '/main');
                } else if (statusCode == 401) {
                  showError("Erro 401", "Não autorizado, favor logar novamente",
                      context);
                } else if (statusCode == 404) {
                  showError("Erro 404", "Evento ou usuário não foi encontrado",
                      context);
                } else if (statusCode == 500) {
                  showError(
                      "Erro 500",
                      "Erro no servidor, favor tente novamente mais tarde (Delete)",
                      context);
                } else {
                  showError(
                      "Erro Desconhecido", "StatusCode: $statusCode", context);
                }
              },
            ),
            new FlatButton(
              child: new Text("Não"),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    return 0;
  }

  void _showWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Erro ao deletar Evento"),
          content: new Text(
              "Não foi possível deletar esse evento, por favor, tente mais tarde."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/main");
              },
            ),
          ],
        );
      },
    );
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
}
