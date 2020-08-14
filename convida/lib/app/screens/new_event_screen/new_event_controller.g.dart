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

  final _$loadingAtom = Atom(name: '_NewEventControllerBase.loading');

  @override
  bool get loading {
    _$loadingAtom.context.enforceReadPolicy(_$loadingAtom);
    _$loadingAtom.reportObserved();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.context.conditionallyRunInAction(() {
      super.loading = value;
      _$loadingAtom.reportChanged();
    }, _$loadingAtom, name: '${_$loadingAtom.name}_set');
  }

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
    final string =
        'loading: ${loading.toString()},isValid: ${isValid.toString()}';
    return '{$string}';
  }
}
