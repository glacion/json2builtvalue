import 'package:json2builtvalue/json2builtvalue.dart';

const _result = '''library result;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'result.g.dart';

abstract class Result implements Built<Result, ResultBuilder> {
  Result._();

  factory Result([updates(ResultBuilder b)]) = _\$Result;

  @BuiltValueField(wireName: 'size')
  int get size;
  @BuiltValueField(wireName: 'items')
  BuiltList<Items> get items;
  String toJson() {
    return json.encode(serializers.serializeWith(Result.serializer, this));
  }

  static Result fromJson(String jsonString) {
    return serializers.deserializeWith(
        Result.serializer, json.decode(jsonString));
  }

  static Serializer<Result> get serializer => _\$resultSerializer;
}
library items;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'items.g.dart';

abstract class Items implements Built<Items, ItemsBuilder> {
  Items._();

  factory Items([updates(ItemsBuilder b)]) = _\$Items;

  @BuiltValueField(wireName: 'userId')
  int get userId;
  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'title')
  String get title;
  @BuiltValueField(wireName: 'completed')
  bool get completed;
  String toJson() {
    return json.encode(serializers.serializeWith(Items.serializer, this));
  }

  static Items fromJson(String jsonString) {
    return serializers.deserializeWith(
        Items.serializer, json.decode(jsonString));
  }

  static Serializer<Items> get serializer => _\$itemsSerializer;
}
''';

const _input = '''{
  "size": 10,
  "items": [
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
  ]
}
''';

bool testMultiDepthWithInnerList() => Parser().parse(_input, 'Result') == _result;