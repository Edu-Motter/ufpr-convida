library my_prj.validations.login;

String userValidation(value) {
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

String passwordValidation(value) {
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
      return null;
  } else
    return 'Possuí caracter inválido';
}
