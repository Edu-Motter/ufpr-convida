import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:convida/app/screens/app_widget.dart';

void main() {
  initializeDateFormatting("pt_BR",null);
  runApp(AppWidget());
}
