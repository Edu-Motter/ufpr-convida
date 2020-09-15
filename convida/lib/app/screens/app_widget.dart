import 'package:flutter/material.dart';
import 'package:convida/app/shared/theme/blue_theme.dart';
import 'package:convida/app/shared/routes/routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: function(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 0) {
              return MaterialApp(
                  //Make the app without "Debug warning" on screen
                  debugShowCheckedModeBanner: false,
                  title: "UFPRConVIDA",
                  theme: blueTheme,
                  initialRoute: '/main',
                  routes: routes);
            }
            else {
              return Container(color: Colors.blue);
            }
          } else
            return Container(color: Colors.blue);
        });
  }

  Future<int> function() async {
    try {
      final _save = FlutterSecureStorage();
      final String userLogin = await _save.read(key: "user"); 
      final String userId  = await _save.read(key: "userId");
      final String userToken = await _save.read(key: "token");
      print("userLogin: $userLogin");
      print("userId: $userId");
      print("userToken $userToken");

    } catch (e) {
      return 1;
    }
    return 0;
  }
}
