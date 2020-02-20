import 'package:mobx/mobx.dart';
part 'new_event.g.dart';

class NewEvent = _NewEventBase with _$NewEvent;

abstract class _NewEventBase with Store {
  @observable
  String name;
  @action
  setName(String value) => name = value;

  @observable
  String target;
  @action
  setTarget(String value) => target = value;

  @observable
  String desc;
  @action
  setDesc(String value) => desc = value;

  @observable
  String address;
  @action
  setAddress(String value) => address = value;

  @observable
  String complement;
  @action
  setComplement(String value) => complement = value;

  @observable
  String link;
  @action
  setLink(String value) => link = value;
}