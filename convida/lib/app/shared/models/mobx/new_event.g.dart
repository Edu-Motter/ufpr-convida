// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_event.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NewEvent on _NewEventBase, Store {
  final _$nameAtom = Atom(name: '_NewEventBase.name');

  @override
  String get name {
    _$nameAtom.context.enforceReadPolicy(_$nameAtom);
    _$nameAtom.reportObserved();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.context.conditionallyRunInAction(() {
      super.name = value;
      _$nameAtom.reportChanged();
    }, _$nameAtom, name: '${_$nameAtom.name}_set');
  }

  final _$targetAtom = Atom(name: '_NewEventBase.target');

  @override
  String get target {
    _$targetAtom.context.enforceReadPolicy(_$targetAtom);
    _$targetAtom.reportObserved();
    return super.target;
  }

  @override
  set target(String value) {
    _$targetAtom.context.conditionallyRunInAction(() {
      super.target = value;
      _$targetAtom.reportChanged();
    }, _$targetAtom, name: '${_$targetAtom.name}_set');
  }

  final _$descAtom = Atom(name: '_NewEventBase.desc');

  @override
  String get desc {
    _$descAtom.context.enforceReadPolicy(_$descAtom);
    _$descAtom.reportObserved();
    return super.desc;
  }

  @override
  set desc(String value) {
    _$descAtom.context.conditionallyRunInAction(() {
      super.desc = value;
      _$descAtom.reportChanged();
    }, _$descAtom, name: '${_$descAtom.name}_set');
  }

  final _$addressAtom = Atom(name: '_NewEventBase.address');

  @override
  String get address {
    _$addressAtom.context.enforceReadPolicy(_$addressAtom);
    _$addressAtom.reportObserved();
    return super.address;
  }

  @override
  set address(String value) {
    _$addressAtom.context.conditionallyRunInAction(() {
      super.address = value;
      _$addressAtom.reportChanged();
    }, _$addressAtom, name: '${_$addressAtom.name}_set');
  }

  final _$complementAtom = Atom(name: '_NewEventBase.complement');

  @override
  String get complement {
    _$complementAtom.context.enforceReadPolicy(_$complementAtom);
    _$complementAtom.reportObserved();
    return super.complement;
  }

  @override
  set complement(String value) {
    _$complementAtom.context.conditionallyRunInAction(() {
      super.complement = value;
      _$complementAtom.reportChanged();
    }, _$complementAtom, name: '${_$complementAtom.name}_set');
  }

  final _$linkAtom = Atom(name: '_NewEventBase.link');

  @override
  String get link {
    _$linkAtom.context.enforceReadPolicy(_$linkAtom);
    _$linkAtom.reportObserved();
    return super.link;
  }

  @override
  set link(String value) {
    _$linkAtom.context.conditionallyRunInAction(() {
      super.link = value;
      _$linkAtom.reportChanged();
    }, _$linkAtom, name: '${_$linkAtom.name}_set');
  }

  final _$_NewEventBaseActionController =
      ActionController(name: '_NewEventBase');

  @override
  dynamic setName(String value) {
    final _$actionInfo = _$_NewEventBaseActionController.startAction();
    try {
      return super.setName(value);
    } finally {
      _$_NewEventBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTarget(String value) {
    final _$actionInfo = _$_NewEventBaseActionController.startAction();
    try {
      return super.setTarget(value);
    } finally {
      _$_NewEventBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDesc(String value) {
    final _$actionInfo = _$_NewEventBaseActionController.startAction();
    try {
      return super.setDesc(value);
    } finally {
      _$_NewEventBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAddress(String value) {
    final _$actionInfo = _$_NewEventBaseActionController.startAction();
    try {
      return super.setAddress(value);
    } finally {
      _$_NewEventBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setComplement(String value) {
    final _$actionInfo = _$_NewEventBaseActionController.startAction();
    try {
      return super.setComplement(value);
    } finally {
      _$_NewEventBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLink(String value) {
    final _$actionInfo = _$_NewEventBaseActionController.startAction();
    try {
      return super.setLink(value);
    } finally {
      _$_NewEventBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'name: ${name.toString()},target: ${target.toString()},desc: ${desc.toString()},address: ${address.toString()},complement: ${complement.toString()},link: ${link.toString()}';
    return '{$string}';
  }
}
