// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ReportModel on _ReportModelBase, Store {
  final _$descriptionAtom = Atom(name: '_ReportModelBase.description');

  @override
  String get description {
    _$descriptionAtom.context.enforceReadPolicy(_$descriptionAtom);
    _$descriptionAtom.reportObserved();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.context.conditionallyRunInAction(() {
      super.description = value;
      _$descriptionAtom.reportChanged();
    }, _$descriptionAtom, name: '${_$descriptionAtom.name}_set');
  }

  final _$authorAtom = Atom(name: '_ReportModelBase.author');

  @override
  String get author {
    _$authorAtom.context.enforceReadPolicy(_$authorAtom);
    _$authorAtom.reportObserved();
    return super.author;
  }

  @override
  set author(String value) {
    _$authorAtom.context.conditionallyRunInAction(() {
      super.author = value;
      _$authorAtom.reportChanged();
    }, _$authorAtom, name: '${_$authorAtom.name}_set');
  }

  final _$ignoredAtom = Atom(name: '_ReportModelBase.ignored');

  @override
  bool get ignored {
    _$ignoredAtom.context.enforceReadPolicy(_$ignoredAtom);
    _$ignoredAtom.reportObserved();
    return super.ignored;
  }

  @override
  set ignored(bool value) {
    _$ignoredAtom.context.conditionallyRunInAction(() {
      super.ignored = value;
      _$ignoredAtom.reportChanged();
    }, _$ignoredAtom, name: '${_$ignoredAtom.name}_set');
  }

  final _$idAtom = Atom(name: '_ReportModelBase.id');

  @override
  String get id {
    _$idAtom.context.enforceReadPolicy(_$idAtom);
    _$idAtom.reportObserved();
    return super.id;
  }

  @override
  set id(String value) {
    _$idAtom.context.conditionallyRunInAction(() {
      super.id = value;
      _$idAtom.reportChanged();
    }, _$idAtom, name: '${_$idAtom.name}_set');
  }

  final _$_ReportModelBaseActionController =
      ActionController(name: '_ReportModelBase');

  @override
  dynamic setDescription(String value) {
    final _$actionInfo = _$_ReportModelBaseActionController.startAction();
    try {
      return super.setDescription(value);
    } finally {
      _$_ReportModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAuthor(String value) {
    final _$actionInfo = _$_ReportModelBaseActionController.startAction();
    try {
      return super.setAuthor(value);
    } finally {
      _$_ReportModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIgnored(bool value) {
    final _$actionInfo = _$_ReportModelBaseActionController.startAction();
    try {
      return super.setIgnored(value);
    } finally {
      _$_ReportModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setId(String value) {
    final _$actionInfo = _$_ReportModelBaseActionController.startAction();
    try {
      return super.setId(value);
    } finally {
      _$_ReportModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'description: ${description.toString()},author: ${author.toString()},ignored: ${ignored.toString()},id: ${id.toString()}';
    return '{$string}';
  }
}
