// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailed_event_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DetailedEventController on _DetailedEventControllerBase, Store {
  final _$reportAtom = Atom(name: '_DetailedEventControllerBase.report');

  @override
  String get report {
    _$reportAtom.context.enforceReadPolicy(_$reportAtom);
    _$reportAtom.reportObserved();
    return super.report;
  }

  @override
  set report(String value) {
    _$reportAtom.context.conditionallyRunInAction(() {
      super.report = value;
      _$reportAtom.reportChanged();
    }, _$reportAtom, name: '${_$reportAtom.name}_set');
  }

  final _$favoriteAtom = Atom(name: '_DetailedEventControllerBase.favorite');

  @override
  bool get favorite {
    _$favoriteAtom.context.enforceReadPolicy(_$favoriteAtom);
    _$favoriteAtom.reportObserved();
    return super.favorite;
  }

  @override
  set favorite(bool value) {
    _$favoriteAtom.context.conditionallyRunInAction(() {
      super.favorite = value;
      _$favoriteAtom.reportChanged();
    }, _$favoriteAtom, name: '${_$favoriteAtom.name}_set');
  }

  final _$authorAtom = Atom(name: '_DetailedEventControllerBase.author');

  @override
  User get author {
    _$authorAtom.context.enforceReadPolicy(_$authorAtom);
    _$authorAtom.reportObserved();
    return super.author;
  }

  @override
  set author(User value) {
    _$authorAtom.context.conditionallyRunInAction(() {
      super.author = value;
      _$authorAtom.reportChanged();
    }, _$authorAtom, name: '${_$authorAtom.name}_set');
  }

  final _$_DetailedEventControllerBaseActionController =
      ActionController(name: '_DetailedEventControllerBase');

  @override
  dynamic setReport(dynamic value) {
    final _$actionInfo =
        _$_DetailedEventControllerBaseActionController.startAction();
    try {
      return super.setReport(value);
    } finally {
      _$_DetailedEventControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFavorite(bool value) {
    final _$actionInfo =
        _$_DetailedEventControllerBaseActionController.startAction();
    try {
      return super.setFavorite(value);
    } finally {
      _$_DetailedEventControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'report: ${report.toString()},favorite: ${favorite.toString()},author: ${author.toString()}';
    return '{$string}';
  }
}
