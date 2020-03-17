// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ReportController on _ReportControllerBase, Store {
  final _$listItemsAtom = Atom(name: '_ReportControllerBase.listItems');

  @override
  List<Event> get listItems {
    _$listItemsAtom.context.enforceReadPolicy(_$listItemsAtom);
    _$listItemsAtom.reportObserved();
    return super.listItems;
  }

  @override
  set listItems(List<Event> value) {
    _$listItemsAtom.context.conditionallyRunInAction(() {
      super.listItems = value;
      _$listItemsAtom.reportChanged();
    }, _$listItemsAtom, name: '${_$listItemsAtom.name}_set');
  }

  final _$_ReportControllerBaseActionController =
      ActionController(name: '_ReportControllerBase');

  @override
  dynamic setListItems(List<Event> value) {
    final _$actionInfo = _$_ReportControllerBaseActionController.startAction();
    try {
      return super.setListItems(value);
    } finally {
      _$_ReportControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'listItems: ${listItems.toString()}';
    return '{$string}';
  }
}
