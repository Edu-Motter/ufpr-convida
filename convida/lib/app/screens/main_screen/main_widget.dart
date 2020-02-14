import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:convida/app/screens/alter_profile_screen/alter_profile_widget.dart';
import 'package:convida/app/screens/events_screen/events_widget.dart';
import 'package:convida/app/screens/favorites_screen/favorites_widget.dart';
import 'package:convida/app/screens/map_screen/map_widget.dart';
import 'package:convida/app/screens/my_events_screen/my_events_widget.dart';
import 'package:convida/app/shared/global/globals.dart' as globals;
import 'package:convida/app/shared/models/user.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  final _save = FlutterSecureStorage();
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String healthType;
  String sportType;
  String partyType;
  String artType;
  String studyType;
  String othersType;
  String dataType;

  User user;
  String _url = globals.URL;

  String _name;
  String _lastName;
  String _email;
  String _token;
  String _avatar;

  Widget _switchScreen(int index) {
    switch (index) {
      case 0:
        currentIndex = 0;
        return new Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //Google's Map:
            MapWidget(
                healthType: healthType,
                sportType: sportType,
                partyType: partyType,
                artType: artType,
                studyType: studyType,
                othersType: othersType,
                dataType: dataType),

            //Drawer:
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                //Not good:
                //top: 110

                padding: const EdgeInsets.fromLTRB(5, 35, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getDrawer(),
                  ],
                ),
              ),
            ),
          ],
        );
        break;

      case 1:
        currentIndex = 1;
        return EventsWidget();
        break;

      case 2:
        currentIndex = 2;
        return FavoritesWidget();
        break;

      case 3:
        currentIndex = 3;
        return MyEventsWidget();
        break;

      default:
        return MapWidget(
            healthType: healthType,
            sportType: sportType,
            partyType: partyType,
            artType: artType,
            studyType: studyType,
            othersType: othersType,
            dataType: dataType);
    }
  }

  FloatingActionButton getDrawer() {
    return FloatingActionButton(
      heroTag: 0,
      backgroundColor: Color(0xFF295492),
      mini: true,
      onPressed: () async {
        final save = FlutterSecureStorage();
        final t = await save.read(key: "token");

        print("New Token: $t");
        if (t != null) {
          String success = await getUserProfile();
          print(success);
        }
        _scaffoldKey.currentState.openDrawer();
      },
      child: Icon(Icons.format_list_bulleted),
    );
  }

  void _showDialog(String s, String desc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(s),
          content: Text(desc),
          actions: <Widget>[
            FlatButton(
              child: Text("Sim"),
              onPressed: () {
                Navigator.pop(context);
                exit(0);
              },
            ),
            FlatButton(
              child: Text("Não"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final types =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    if (types == null) {
      healthType = "Saúde e Bem-estar";
      sportType = "Esporte e Lazer";
      partyType = "Festas e Comemorações";
      artType =  "Cultura e Religião";
      studyType = "Acadêmico e Profissional";
      othersType = "Outros";
      dataType = "all";
    } else {
      healthType = types['healthType'];
      sportType = types['sportType'];
      partyType = types['partyType'];
      artType = types['artType'];
      studyType = types['studyType'];
      othersType = types['othersType'];
      dataType = types['dataType'];
    }

    return WillPopScope(
      //Ends the app
      onWillPop: () {
        if (currentIndex == 0) {
          _showDialog("Saindo", "Deseja realmente sair do UFPR ConVIDA?");
          return null;
        } else {
          setState(() {
            currentIndex = 0;
            healthType = "";
            sportType = "";
            partyType = "";
            artType =  "";
            studyType = "";
            othersType = "";
            dataType = "all";
          });
          return null;
        }
      },
      child: FutureBuilder(
        future: checkToken(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator(),),
            );
          } else if (snapshot.data != null) { 
            return Scaffold(
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              drawer: _token == null
                  //Drawer without user:
                  ? drawerNoUser()
                  //Drawer of the user:
                  : drawerUser(context),
              body: _switchScreen(currentIndex),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentIndex,
                type: BottomNavigationBarType.fixed,
                onTap: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.map), title: Text("Mapa")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list), title: Text("Eventos")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.star), title: Text("Favoritos")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.event_note), title: Text("Meus Eventos"))
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Drawer drawerNoUser() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("UFPR ConVIDA"),
            accountEmail: Text("Favor fazer Login!"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("UFPR"),
            ),
          ),
          drawerLogin(),
          drawerSignup(),
          Divider(),
          drawerAbout(),
          ListTile(
            title: Text("Fechar"),
            trailing: Icon(Icons.close),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  ListTile drawerAbout() {
    return ListTile(
        title: Text("Sobre"),
        trailing: Icon(Icons.info),
        onTap: () {
          //Pop Drawer:
          Navigator.of(context).pop();
          //Push Login Screen:
          Navigator.of(context).pushReplacementNamed("/about");
        });
  }

  Drawer drawerUser(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("$_name $_lastName"),
            accountEmail: Text("$_email"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("$_avatar"),
            ),
          ),

          ListTile(
            title: Text("Perfil"),
            trailing: Icon(Icons.person),
            onTap: () async {
              if (_token != null) {
                String success = await getUserProfile();
                print(success);
              }
              //Pop Drawer:
              Navigator.of(context).pop();
              
              //Push Alter Profile Screen
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlterProfileWidget(
                      user: user,
                    ),
                  ));
            },
          ),
          //new DrawerSettings(),
          new DrawerLogout(),
          new Divider(),
          drawerAbout(),

          //O Fechar somente fecha a barra de ferramentas
          new ListTile(
            title: Text("Fechar"),
            trailing: Icon(Icons.close),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  ListTile drawerLogin() {
    return ListTile(
        title: Text("Login"),
        trailing: Icon(Icons.person),
        onTap: () {
          _save.deleteAll();
          //Pop Drawer:
          Navigator.of(context).pop();

          //Push Login Screen:
          Navigator.of(context).pushReplacementNamed("/login", arguments: "map");
        });
  }

  ListTile drawerSignup() {
    return ListTile(
        title: Text("Cadastro"),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          //Pop Drawer:
          Navigator.of(context).pop();
          //Push SignUp Screen:
          Navigator.of(context).pushReplacementNamed("/signup", arguments: "map");
        });
  }

  Future<String> getUserProfile() async {
    String id = await _save.read(key: "user");

    Map<String, String> mapHeaders = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    user = await http
        .get("$_url/users/$id", headers: mapHeaders)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if ((statusCode == 200) || (statusCode == 201)) {
        print("Success loading user profile!");
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw new Exception(
            "Error while fetching data, status code: $statusCode");
      }
    });

    return "Success";
  }

  Future<bool> checkToken() async {
    _token = await _save.read(key: "token");
    
    
    if (_token == null) {
      return false;
    } else {
      _name = await _save.read(key: "name");
      _email = await _save.read(key: "email");
      _lastName = await _save.read(key: "lastName");
      _avatar = _name[0].toUpperCase();
      return true;
    }
  }
}

class DrawerLogout extends StatelessWidget {
  const DrawerLogout({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _save = FlutterSecureStorage();

    return new ListTile(
        title: Text("Logout"),
        trailing: Icon(Icons.chevron_left),
        onTap: () async {
          _save.deleteAll();

          Navigator.pop(context);

          Navigator.pushReplacementNamed(context, '/main');
        });
  }
}
