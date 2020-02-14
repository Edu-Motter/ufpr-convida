library my_prj.util.dialogs;

import 'package:flutter/material.dart';

void showSuccess(String s, String route, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(s),
        content: new Text("Prescione 'Ok' para continar"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Ok"),
            onPressed: () {
              Navigator.pop(context);
              if (route == "pop") {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed(route);
              }
            },
          ),
        ],
      );
    },
  );
}

void showError(String title, String content, BuildContext context) {
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
