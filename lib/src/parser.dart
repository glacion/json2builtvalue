import 'dart:convert';

import 'package:json2builtvalue/src/root.dart';
import 'package:json2builtvalue/src/string_class.dart';
import 'package:tuple/tuple.dart';

class Parser {

  String parse(String jsonString, String topLevelName) {
    final hasInner = (Subtype s) =>
        (s.type == JsonType.LIST && s.listType == JsonType.MAP) ||
        s.type == JsonType.MAP;

    List<Subtype> topLevel = _getTypedClassFields(json.decode(jsonString));

    final allClasses = <Tuple2<String, List<Subtype>>>[
      Tuple2(topLevelName, topLevel)
    ];

    topLevel.forEach(
      (Subtype s) => (hasInner(s))
          ? allClasses.add(Tuple2(s.name, _getTypedClassFields(s.value)))
          : null,
    );
    return allClasses
        .map((tuple) => StringClass(tuple.item2, tuple.item1).toString())
        .reduce((s1, s2) => s1 + s2);
  }

  List<Subtype> _getTypedClassFields(decode) {
    final topLevelClass = <Subtype>[];
    final toDecode = (decode is List) ? decode[0] : decode;
    toDecode.forEach((key, val) => topLevelClass.add(_returnType(key, val)));
    return topLevelClass;
  }

  Subtype _returnType(String key, val) {
    if (val is String) {
      return Subtype(key, JsonType.STRING, val);
    } else if (val is int) {
      return Subtype(key, JsonType.INT, val);
    } else if (val is num) {
      return Subtype(key, JsonType.DOUBLE, val);
    } else if (val is bool) {
      return Subtype(key, JsonType.BOOL, val);
    } else if (val is List) {
      return Subtype(key, JsonType.LIST, val, listType: _returnJsonType(val));
    } else if (val is Map) {
      return Subtype(key, JsonType.MAP, val);
    } else {
      throw ArgumentError('Cannot resolve JSON-encodable type for $val.');
    }
  }

  JsonType _returnJsonType(List list) {
    final item = list[0];
    if (item is String) {
      return JsonType.STRING;
    } else if (item is int) {
      return JsonType.INT;
    } else if (item is num) {
      return JsonType.DOUBLE;
    } else if (item is bool) {
      return JsonType.BOOL;
    } else if (item is Map) {
      return JsonType.MAP;
    } else {
      throw ArgumentError('Cannot resolve JSON-encodable type for $item.');
    }
  }
}
