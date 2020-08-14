import 'package:mobx/mobx.dart';

part 'report.g.dart';

class ReportModel = _ReportModelBase with _$ReportModel;

abstract class _ReportModelBase with Store {

  _ReportModelBase({this.description, this.author, this.ignored, this.id});

  @observable
  String description;

  @observable
  String author;

  @observable
  bool ignored;
  
  @observable
  String id;


  @action
  setDescription(String value) => description = value;

  @action
  setAuthor(String value) => author = value;

  @action
  setIgnored(bool value) => ignored = value;

  @action
  setId(String value) => id = value;

}