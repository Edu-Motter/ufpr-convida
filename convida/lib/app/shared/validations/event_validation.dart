library my_prj.validations.event;

import 'package:intl/intl.dart';

import 'date_validation.dart';

String nameValidation(value) {
  String expression =
      r"^[a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.]{2,25}$";
  RegExp _nameValidator = RegExp(expression);

  if (value == null) {
    return 'Favor entre com o nome do Evento';
  } else if (value.isEmpty) {
    return 'Favor entre com o nome do Evento';
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
  } else {
    return 'Possuí caracter inválido';
  }
}

String targetValidation(value) {
  String expression =
      r"^[a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.]{2,25}$";
  RegExp _targetValidator = RegExp(expression);

  if (value == null) {
    return 'Favor entre com o Público Alvo';
  } else if (value.isEmpty) {
    return 'Favor entre com o Público Alvo';
  } else if (value.startsWith(' ')) {
    return 'Inicia com espaço';
  } else if (value.contains('  ')) {
    return 'Contém espaços desnecessários';
  } else if (value.length < 2) {
    return 'Min. 2 caracteres';
  } else if (value.length > 25) {
    return 'Max. 25 caracteres';
  } else if (_targetValidator.hasMatch(value)) {
    return null;
  } else {
    return 'Possuí caracter inválido';
  }
}

String descriptionValidation(value) {
  String expression =
      r"^([a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.@$%&]{2,250})$";
  RegExp _descValidator = RegExp(expression);

  if (value == null) {
    return 'Favor entre com uma breve descrição';
  } else if (value.isEmpty) {
    return 'Favor entre com uma breve descrição';
  } else if (value.startsWith(' ')) {
    return 'Inicia com espaço';
  } else if (value.contains('  ')) {
    return 'Contém espaços desnecessários';
  } else if (value.length < 2) {
    return 'Min. 2 caracteres';
  } else if (value.length > 250) {
    return 'Max. 250 caracteres';
  } else if (_descValidator.hasMatch(value)) {
    return null;
  } else {
    return 'Possuí caracter inválido';
  }
}

String addressValidation(value) {
  String expression =
      r"^([a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.@$%&]{2,50})$";
  RegExp _addressValidator = RegExp(expression);

  if (value == null) {
    return 'Favor entre com um Endereço';
  } else if (value.isEmpty) {
    return 'Favor entre com um Endereço';
  } else if (value.startsWith(' ')) {
    return 'Inicia com espaço';
  } else if (value.contains('  ')) {
    return 'Contém espaços desnecessários';
  } else if (value.length < 2) {
    return 'Min. 2 caracteres';
  } else if (value.length > 50) {
    return 'Max. 50 caracteres';
  } else if (_addressValidator.hasMatch(value)) {
    return null;
  } else {
    return 'Possuí caracter inválido';
  }
}

String complementValidation(value) {
  String expression =
      r"^([a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ ,.]{0,50})$";
  RegExp _complementValidator = RegExp(expression);

  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return null;
  } else if (value.length > 50) {
    return 'Max. 50 caracteres';
  }
  if (value.startsWith(' ')) {
    return 'Inicia com espaço';
  }
  if (value.contains('  ')) {
    return 'Contém espaços desnecessários';
  }
  if (_complementValidator.hasMatch(value)) {
    return null;
  } else {
    return 'Possuí caracter inválido';
  }
}

String linkValidation(value) {
  String expression =
      r"^([a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.@$%&]{2,50})$";
  RegExp _eventLinkValidator = RegExp(expression);

  if (value == null) {
    return 'Favor entre com o Link ou E-mail';
  } else if (value.isEmpty) {
    return 'Favor entre com o Link ou E-mail';
  } else if (value.startsWith(' ')) {
    return 'Inicia com espaço';
  } else if (value.contains('  ')) {
    return 'Contém espaços desnecessários';
  } else if (value.length < 2) {
    return 'Min. 2 caracteres';
  } else if (value.length > 50) {
    return 'Max. 50 caracteres';
  } else if (_eventLinkValidator.hasMatch(value)) {
    return null;
  } else {
    return 'Possuí caracter inválido';
  }
}

String reportValidation(value) {
  String expression =
      r"^([a-zA-Z0-9áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ !?,.@$%&]{3,280})$";
  RegExp _reportValidator = RegExp(expression);

  if (value == null) {
    return 'Favor justifique sua denuncia';
  } else if (value.isEmpty) {
    return 'Favor justifique sua denuncia';
  } else if (value.startsWith(' ')) {
    return 'Inicia com espaço';
  } else if (value.contains('  ')) {
    return 'Contém espaços desnecessários';
  } else if (value.length < 3) {
    return 'Min. 3 caracteres';
  } else if (value.length > 280) {
    return 'Max. 280 caracteres';
  } else if (_reportValidator.hasMatch(value)) {
    return null;
  } else {
    return 'Possuí caracter inválido';
  }
}

String dateValidation(value, String date) {
  if (value == null) {
    return 'Favor entre com a Data $date';
  } else if (value.isEmpty) {
    return 'Favor entre com a Data $date';
  } else if (value.length < 10) {
    return 'Favor entre com a Data $date';
  } else {
    DateFormat dateFormat = new DateFormat("dd/MM/yyyy");
    DateTime parsedDate = dateFormat.parse(value);
    print(parsedDate);
    bool valid = isValidDate(value);
    if (!valid) {
      return "Data inválida";
    } else if (parsedDate.compareTo(DateTime.now()) > 0) {
      return null;
    } else if (parsedDate.year == DateTime.now().year) {
      if (parsedDate.month == DateTime.now().month) {
        if (parsedDate.day == DateTime.now().day) {
          //Today
          return null;
        }
        return "Data já passou!";
      }
      return "Data já passou!";
    } else {
      return "Data já passou!";
    }
  }
}

String hourValidation(value, String hour) {
  if (value == null) {
    return 'Favor entre com a Hora de $hour';
  } else if (value.isEmpty) {
    return 'Favor entre com a Hora de $hour';
  } else if (value.length < 5) {
    return 'Favor entre com a Hora de $hour';
  } else {
    bool valid = isValidHour(value);
    if (!valid) {
      return "Hora de $hour inválida";
    } else {
      return null;
    }
  }
}
