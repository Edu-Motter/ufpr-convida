import 'package:convida/app/shared/util/dialogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatefulWidget {
  @override
  _AboutWidgetState createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  final String linkUfpr = "www.ufpr.br";

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                  "O Aplicativo UFPRConVIDA possui todas as imagens produzidas pelos seguintes autores, \"Freepik\", \"Nikita Golubev\", \"Eucalyp\" e \"pongsakornRed\". Todos eles podem ser encontrados no site \"www.flaticon.com\"",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Mais informações em: ",
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                    child: Text("$linkUfpr",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline)),
                    onTap: () => openLink(linkUfpr))
              ],
            )
          ],
        ),
      );
      // );
    } catch (e) {
      print(e.toString());
      return CircularProgressIndicator();
    }
  }

  openLink(String link) async {
    String url = "https://link";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showError("Impossível abrir o link",
          "Não foi possível abrir esse link: $link", context);
    }
  }
}
