
import 'package:flutter/material.dart';

class AboutWidget extends StatefulWidget {
  @override
  _AboutWidgetState createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  @override
  Widget build(BuildContext context) {
    try {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar:
          AppBar(
            title: const Text("Sobre"),
            centerTitle: true,
          ),
          body: Column(
            children: <Widget>[
              Image.asset(
                "assets/logo-ufprconvida-sembordas.png",
                scale: 2,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: const Text(
                      "O Aplicativo UFPRConVIDA possui todas as imagens produzidas pelos seguintes autores, \"Freepik\", \"Nikita Golubev\" e \"pongsakornRed\". Todos eles podem ser encontrados no site \"www.flaticon.com\""),
                ),
              ),
            ],
          ),
        );
      // );
    } catch (e) {
      print(e.toString());
      return CircularProgressIndicator();
    }
  }
}
