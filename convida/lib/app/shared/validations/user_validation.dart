library my_prj.validations.event;

import 'package:convida/app/shared/validations/date_validation.dart';

String nameValidation(value, name) {
  String expression = r"^[A-Za-zá àâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]{2,25}$";
  RegExp _nameValidator = RegExp(expression);

  if (value == null) {
    return 'Favor entre com seu $name';
  } else if (value.isEmpty) {
    return 'Favor entre com seu $name';
  } else if (value.startsWith(' ')) {
    return 'Inicia com espaço';
  } else if (value.contains('  ')) {
    return 'Contém espaços desnecessários';
  } else if (value.length < 2) {
    return 'Min. 2 caracteres';
  } else if (value.length > 25) {
    return 'Max. 25 caracteres';
  } else if (_nameValidator.hasMatch(value)) {
    return null;
  } else
    return 'Possuí caracter inválido';
}

String grrValidation(value) {
  String expression = r"^[gG]{1}[rR]{2}[0-9]{8}";
  RegExp _grrValidator = RegExp(expression);

  if (value == null) {
    return 'Favor entre com seu GRR';
  } else if (value.isEmpty) {
    return 'Favor entre com seu GRR';
  } else if (value.startsWith(' ')) {
    return 'Inicia com espaço';
  } else if (value.contains('  ')) {
    return 'Contém espaços desnecessários';
  } else if (value.length < 11) {
    return "Favor entre com seu GRR";
  } else if (_grrValidator.hasMatch(value)) {
    return null;
  } else {
    return 'Possuí caracter inválido';
  }
}

String birthValidation(value) {
  if (value == null) {
    return 'Favor entre com a Data de Nascimento';
  } else if (value.isEmpty) {
    return 'Favor entre com a Data de Nascimento';
  } else if (value.length < 10) {
    return 'Favor entre com a Data de Nascimento';
  } else {
    bool valid = isValidDate(value);
    if (!valid) {
      return "Data inválida";
    } else {
      return null;
    }
  }
}

String emailValidation(value) {
  String expression = r"^([a-zA-Z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$";
  RegExp _emailValidator = RegExp(expression);

  if (value == null) {
    return 'Favor entre com seu E-mail';
  } else if (value.isEmpty) {
    return 'Favor entre com seu E-mail';
  } else if (value.startsWith(' ')) {
    return 'Inicia com espaço';
  } else if (value.contains('  ')) {
    return 'Contém espaços desnecessários';
  } else if (value.length > 50) {
    return 'Max. 50 caracteres';
  } else if (!value.contains("@")) {
    return 'Está faltando "@"';
  } else if (!value.contains(".")) {
    return 'Está faltando "."';
  } else if (_emailValidator.hasMatch(value)) {
    return null;
  } else
    return 'E-mail inválido';
}

String passwordValidation(value, password) {
  String expression = r"^[a-zA-Z0-9_@$!%&-]{4,18}$";
  RegExp _userPasswordValidator = RegExp(expression);

  if (value == null) {
    return 'Favor entre com sua Senha';
  } else if (value.isEmpty) {
    return 'Favor entre com sua Senha';
  } else if (value.startsWith(' ')) {
    return 'Inicia com espaço';
  } else if (value.contains('  ')) {
    return 'Contém espaços desnecessários';
  } else if (value.length < 4) {
    return 'Min. 4 caracteres';
  } else if (value.length > 18) {
    return 'Max. 18 caracteres';
  } else if (_userPasswordValidator.hasMatch(value)) {
    if (password != null) {
      if (password.isNotEmpty) {
        if (password == value) {
          return null;
        } else {
          return 'Senhas estão diferentes';
        }
      } else {
        return null;
      }
    } else
      return null;
  } else
    return 'Possuí caracter inválido';
}
