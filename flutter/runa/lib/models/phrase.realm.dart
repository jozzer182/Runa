// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phrase.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Phrase extends _Phrase with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Phrase(
    int id,
    String text,
    String source, {
    DateTime? createdAt,
    bool isShown = false,
    DateTime? lastShownAt,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Phrase>({'isShown': false});
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'text', text);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'source', source);
    RealmObjectBase.set(this, 'isShown', isShown);
    RealmObjectBase.set(this, 'lastShownAt', lastShownAt);
  }

  Phrase._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get text => RealmObjectBase.get<String>(this, 'text') as String;
  @override
  set text(String value) => RealmObjectBase.set(this, 'text', value);

  @override
  DateTime? get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
  @override
  set createdAt(DateTime? value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  String get source => RealmObjectBase.get<String>(this, 'source') as String;
  @override
  set source(String value) => RealmObjectBase.set(this, 'source', value);

  @override
  bool get isShown => RealmObjectBase.get<bool>(this, 'isShown') as bool;
  @override
  set isShown(bool value) => RealmObjectBase.set(this, 'isShown', value);

  @override
  DateTime? get lastShownAt =>
      RealmObjectBase.get<DateTime>(this, 'lastShownAt') as DateTime?;
  @override
  set lastShownAt(DateTime? value) =>
      RealmObjectBase.set(this, 'lastShownAt', value);

  @override
  Stream<RealmObjectChanges<Phrase>> get changes =>
      RealmObjectBase.getChanges<Phrase>(this);

  @override
  Stream<RealmObjectChanges<Phrase>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Phrase>(this, keyPaths);

  @override
  Phrase freeze() => RealmObjectBase.freezeObject<Phrase>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'text': text.toEJson(),
      'createdAt': createdAt.toEJson(),
      'source': source.toEJson(),
      'isShown': isShown.toEJson(),
      'lastShownAt': lastShownAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Phrase value) => value.toEJson();
  static Phrase _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'text': EJsonValue text,
        'source': EJsonValue source,
      } =>
        Phrase(
          fromEJson(id),
          fromEJson(text),
          fromEJson(source),
          createdAt: fromEJson(ejson['createdAt']),
          isShown: fromEJson(ejson['isShown'], defaultValue: false),
          lastShownAt: fromEJson(ejson['lastShownAt']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Phrase._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Phrase, 'Phrase', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('text', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('source', RealmPropertyType.string),
      SchemaProperty('isShown', RealmPropertyType.bool),
      SchemaProperty(
        'lastShownAt',
        RealmPropertyType.timestamp,
        optional: true,
      ),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
