import 'package:convida/app/shared/global/globals.dart';
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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    try {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Sobre"),
          centerTitle: true,
        ),
        body: ListView(
          
          children: <Widget>[
            SizedBox(height: 20),
            (queryData.orientation == Orientation.portrait)
                  ? Container(
                      height: queryData.size.height / 6,
                      width: queryData.size.width / 6,
                      child: Image.asset(
                        //Image:
                        "assets/logo-ufprconvida.png",
                        scale: 2,
                      ),
                    )
                  : Container(
                      height: queryData.size.height / 4,
                      width: queryData.size.width / 4,
                      child: Image.asset(
                        //Image:
                        "assets/logo-ufprconvida.png",
                        scale: 2,
                      ),
                    ),
            SizedBox(height: 10),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  "O Aplicativo UFPRConVIDA foi desenvolvido por Eduardo Zen Motter e Erick Rampim Garcia, ambos estudantes de Tecnologia em Análise e Desenvolvimento de Sistemas - SEPT - UFPR.", style: TextStyle(
                    fontSize: 16,
                    
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  "Todas as imagens utilizadas foram produzidas pelos seguintes autores, \"Freepik\", \"Nikita Golubev\", \"Eucalyp\" e \"pongsakornRed\". Todos eles podem ser encontrados no site \"www.flaticon.com\"",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Versão: ",
                  style: TextStyle(fontSize: 16),
                ),
                Text("$appVersion",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        ))
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
