import 'dart:async';
import 'package:flutter/material.dart';

//import '../map_screen/map_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () => Navigator.popAndPushNamed(context, '/main'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomImage(),
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: 10.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: new CustomLoading(),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomLoading extends StatelessWidget {
  const CustomLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(padding: EdgeInsetsDirectional.only(top: 10.0),),
        Text("Carregando", style: TextStyle(
            color: Color(0xFF295492),
            fontSize: 18.0,
            fontWeight: FontWeight.bold),)
      ],
    );
  }
}

class CustomImage extends StatelessWidget {
  const CustomImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      //Imagem LOGO da UFPR
      "assets/logo-ufprconvida-sembordas.png",
      width: 400.0,
      height: 400.0,
    );
  }
}