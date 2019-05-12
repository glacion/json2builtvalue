import 'package:json2builtvalue/json2builtvalue.dart';

const _result = '''library todo;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'todo.g.dart';

abstract class Todo implements Built<Todo, TodoBuilder> {
  Todo._();

  factory Todo([updates(TodoBuilder b)]) = _\$Todo;

  @BuiltValueField(wireName: 'userId')
  int get userId;
  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'title')
  String get title;
  @BuiltValueField(wireName: 'completed')
  bool get completed;
  String toJson() {
    return json.encode(serializers.serializeWith(Todo.serializer, this));
  }

  static Todo fromJson(String jsonString) {
    return serializers.deserializeWith(
        Todo.serializer, json.decode(jsonString));
  }

  static Serializer<Todo> get serializer => _\$todoSerializer;
}
''';

const _input = '''
[
  {
    "userId": 1,
    "id": 1,
    "title": "delectus aut autem",
    "completed": false
  },
  {
    "userId": 1,
    "id": 2,
    "title": "quis ut nam facilis et officia qui",
    "completed": false
  }
]''';

bool testList() => Parser().parse(_input, 'todo') == _result;
