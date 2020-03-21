import 'package:convida/app/shared/models/bfav.dart';
import 'package:convida/app/shared/models/report.dart';
import 'package:convida/app/shared/models/user.dart';
import 'package:convida/app/shared/validations/event_validation.dart';
import 'package:mobx/mobx.dart';
import 'package:convida/app/shared/models/event.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

part 'detailed_event_controller.g.dart';

class DetailedEventController = _DetailedEventControllerBase
    with _$DetailedEventController;

abstract class _DetailedEventControllerBase with Store {
  String _url = globals.URL;

  Event event;

  @observable
  String report;

  @action
  setReport(value) => report = value;

  String validateReport() {
    return reportValidation(report);
  }

  @observable
  bool favorite = false;

  @action
  setFavorite(bool value) => favorite = value;
    
  
  
  @observable
  User author;


  Future<Event> getEvent(String eventId, BuildContext context) async {
    final _save = FlutterSecureStorage();
    String token = await _save.read(key: "token");
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
      author = await getAuthor(e.author, context);
      if (author != null) {
        var idEvent = e.id;
        String idUser = _id;
        Bfav fv = new Bfav(grr: idUser, id: idEvent);

        String body = json.encode(fv.toJson());

        try {
          var r = await http.post("$_url/users/isfav",
              body: body, headers: mapHeaders);

          if (r.statusCode == 200) {
            favorite = true;
          } else if ((r.statusCode == 401) || (r.statusCode == 404)) {
            favorite = false;
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

  Future<User> getAuthor(String a, BuildContext context) async {
    int statusCodeUser;

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    User a;
    try {
      a = await http
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
    
    return a;
  }

  Future<String> getPlaceAddress(
      double lat, double lng, BuildContext context) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDExnKlMmmFCZMh1okr26-JFz1anYRr9HE";
    final response = await http.get(url);

    print("Geocoding: ${response.statusCode}");
    print("Body: ${jsonDecode(response.body)}");
    return jsonDecode(response.body)['result'][0]['formatterd_address'];
  }

  openLink(String link, BuildContext context) async {
    String url = 'http://$link';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showError("Impossível abrir o link",
          "Não foi possível abrir esse link: $link", context);
    }
  }

  Future putEventFav(String eventId, BuildContext context) async {
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
        
            favorite = true;
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

  Future deleteEventFav(String eventId, BuildContext context) async {
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
      r = await http.post("$_url/users/rfav", body: body, headers: mapHeaders);
      if (r.statusCode == 204) {
        
            favorite = false;
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

  // void showDialog(String title, String content, BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: new Text(title),
  //         content: new Text(content),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: new Text("Ok"),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           new FlatButton(
  //             child: new Text("Login"),
  //             onPressed: () {
  //               //Pop the Dialog
  //               Navigator.pop(context);
  //               //Push login screen
  //               Navigator.of(context)
  //                   .pushReplacementNamed("/login", arguments: "fav");
  //             },
  //           ),
  //           new FlatButton(
  //             child: new Text("Criar conta"),
  //             onPressed: () {
  //               //Push sign up screen
  //               Navigator.of(context)
  //                   .pushReplacementNamed("/signup", arguments: "fav");
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  putRerport(String idEvent, String report, BuildContext context) async {
    final _save = FlutterSecureStorage();
    final _id = await _save.read(key: "user");
    final _token = await _save.read(key: "token");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    String idUser = _id;
    Report newReport = new Report(grr: idUser, report: report);
    String body = json.encode(newReport.toJson());
    var r;

    try {
      r = await http.put("$_url/events/report/$idEvent",
          body: body, headers: mapHeaders);
      if (r.statusCode == 200) {
        showSuccess("Evento Denunciado com Sucesso!", "pop", context);
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