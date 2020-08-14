// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reported_event_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ReportedEventController on _ReportedEventControllerBase, Store {
  final _$loadingAtom = Atom(name: '_ReportedEventControllerBase.loading');

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

  final _$listReportsAtom =
      Atom(name: '_ReportedEventControllerBase.listReports');

  @override
  ObservableList<dynamic> get listReports {
    _$listReportsAtom.context.enforceReadPolicy(_$listReportsAtom);
    _$listReportsAtom.reportObserved();
    return super.listReports;
  }

  @override
  set listReports(ObservableList<dynamic> value) {
    _$listReportsAtom.context.conditionallyRunInAction(() {
      super.listReports = value;
      _$listReportsAtom.reportChanged();
    }, _$listReportsAtom, name: '${_$listReportsAtom.name}_set');
  }

  final _$_ReportedEventControllerBaseActionController =
      ActionController(name: '_ReportedEventControllerBase');

  @override
  dynamic removeReport(ReportModel report, BuildContext context) {
    final _$actionInfo =
        _$_ReportedEventControllerBaseActionController.startAction();
    try {
      return super.removeReport(report, context);
    } finally {
      _$_ReportedEventControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'loading: ${loading.toString()},listReports: ${listReports.toString()}';
    return '{$string}';
  }
}
