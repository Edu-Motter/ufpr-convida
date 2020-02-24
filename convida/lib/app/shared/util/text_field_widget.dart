library my_prj.util.textfields;

import 'package:flutter/material.dart';

textField({String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextField(
    onChanged: onChanged,
    maxLength: maxLength,
    decoration: InputDecoration(
      labelText: labelText,
      errorText: errorText == null ? null : errorText(),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
      icon: Icon(icon),
    ),
  );
}

textFieldObscure({String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextField(
    obscureText: true,
    onChanged: onChanged,
    maxLength: maxLength,
    decoration: InputDecoration(
      labelText: labelText,
      errorText: errorText == null ? null : errorText(),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
      icon: Icon(icon),
    ),
  );
}

textFieldController({TextEditingController controller, String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    maxLength: maxLength,
    decoration: InputDecoration(
      labelText: labelText,
      errorText: errorText == null ? null : errorText(),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
      icon: Icon(icon),
    ),
  );
}

textFieldLines({int maxLines, String initalValue, String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextFormField(
    maxLines: maxLines,
    initialValue: initalValue,
    onChanged: onChanged,
    maxLength: maxLength,
    decoration: InputDecoration(
      labelText: labelText,
      errorText: errorText == null ? null : errorText(),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
      icon: Icon(icon),
    ),
  );
}

textFieldInitalValue({String initialValue, String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextFormField(
    initialValue: initialValue,
    onChanged: onChanged,
    maxLength: maxLength,
    decoration: InputDecoration(
      labelText: labelText,
      errorText: errorText == null ? null : errorText(),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
      icon: Icon(icon),
    ),
  );
}
