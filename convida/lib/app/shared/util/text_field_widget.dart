library my_prj.util.textfields;

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

textField({String initialValue, String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
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

textFieldObscure({String initialValue, String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextFormField(
    initialValue: initialValue,
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

textFieldController({String initialValue, TextEditingController controller, String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextFormField(
    initialValue: initialValue,
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

textFieldLines({int maxLines, String initialValue, String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextFormField(
    maxLines: maxLines,
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

textFieldInitialValue({String initialValue, String labelText, IconData icon, onChanged, int maxLength,String Function() errorText, String initalValue}) {
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

textFieldMask({String initialValue, MaskTextInputFormatter maskFormatter, TextInputType keyboardType,String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextFormField(
    initialValue: initialValue,
    inputFormatters: [maskFormatter],
    keyboardType: keyboardType,
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

textFieldKeyboard({String initialValue, TextInputType keyboardType, String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextFormField(
    initialValue: initialValue,
    keyboardType: keyboardType,
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


  textFieldWithoutIcon({int maxLines, String initialValue, String labelText, IconData icon, onChanged, int maxLength,String Function() errorText}) {
  return TextFormField(
    maxLines: maxLines,
    initialValue: initialValue,
    onChanged: onChanged,
    maxLength: maxLength,
    decoration: InputDecoration(
      labelText: labelText,
      errorText: errorText == null ? null : errorText(),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.5)),
    ),
  );
}