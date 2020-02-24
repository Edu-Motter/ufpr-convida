// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_event_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NewEventController on _NewEventControllerBase, Store {
  Computed<bool> _$isValidComputed;

  @override
  bool get isValid =>
      (_$isValidComputed ??= Computed<bool>(() => super.isValid)).value;

  final _$_NewEventControllerBaseActionController =
      ActionController(name: '_NewEventControllerBase');

  @override
  String setNewType() {
    final _$actionInfo =
        _$_NewEventControllerBaseActionController.startAction();
    try {
      return super.setNewType();
    } finally {
      _$_NewEventControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'isValid: ${isValid.toString()}';
    return '{$string}';
  }
}
