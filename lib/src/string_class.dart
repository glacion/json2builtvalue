import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:json2builtvalue/src/root.dart';
import 'package:recase/recase.dart';
import 'package:dart_style/dart_style.dart';

class StringClass {
  final List<Subtype> fields;
  final String name;
  final String pascalName;
  final String snakeName;

  StringClass(this.fields, this.name)
      : pascalName = ReCase(name).pascalCase,
        snakeName = ReCase(name).snakeCase;

  Reference get interfaces => Reference(
        'Built<${pascalName}, ${pascalName}Builder>',
      );

  Method get toJson => Method(
        (b) => b
          ..name = 'toJson'
          ..returns = Reference('String')
          ..body = Code(
            'return json.encode(serializers.serializeWith(${pascalName}.serializer, this));',
          ),
      );

  Method get fromJson => Method(
        (b) => b
          ..name = 'fromJson'
          ..static = true
          ..requiredParameters.add(Parameter((b) => b
            ..name = 'jsonString'
            ..type = Reference('String')))
          ..returns = Reference(ReCase(name).pascalCase)
          ..body = Code(
              'return serializers.deserializeWith(${pascalName}.serializer, json.decode(jsonString));'),
      );

  Method get serializer => Method(
        (b) => b
          ..type = MethodType.getter
          ..name = 'serializer'
          ..static = true
          ..lambda = true
          ..returns = Reference('Serializer<${pascalName}>')
          ..body = Code('_\$${ReCase(name).camelCase}Serializer'),
      );

  Constructor get factoryConstructor => Constructor(
        (b) => b
          ..factory = true
          ..redirect = refer(' _\$${pascalName}')
          ..requiredParameters.add(
            Parameter((b) => b
              ..defaultTo = Code('= _\$${pascalName}')
              ..name = '[updates(${pascalName}Builder b)]'),
          ),
      );

  Constructor get defaultConstructor => Constructor(
        (b) => b..name = '_',
      );

  String _generateStringClass() {
    final topLevelClass = Class(
      (b) => b
        ..abstract = true
        ..constructors.add(defaultConstructor)
        ..implements.add(interfaces)
        ..name = ReCase(name).pascalCase
        ..methods = _buildMethods()
        ..methods.add(toJson)
        ..methods.add(fromJson)
        ..methods.add(serializer)
        ..constructors.add(factoryConstructor),
    );

    String classString = topLevelClass.accept(DartEmitter()).toString();

    String _classHeader = """
      library ${snakeName};
      import 'dart:convert';
      
      import 'package:built_collection/built_collection.dart';
      import 'package:built_value/built_value.dart';
      import 'package:built_value/serializer.dart';
      
      part '${snakeName}.g.dart';
    
    """;

    return DartFormatter().format(_classHeader + classString);
  }

  Reference _getDartType(Subtype subtype) {
    final type = subtype.type;
    switch (type) {
      case JsonType.INT:
        return Reference('int');
      case JsonType.DOUBLE:
        return Reference('double');
      case JsonType.BOOL:
        return Reference('bool');
      case JsonType.STRING:
        return Reference('String');
      case JsonType.MAP:
        return Reference(ReCase(subtype.name).pascalCase);
      case JsonType.LIST:
        return Reference('BuiltList<${_getDartTypeFromJsonType(subtype)}>');
      default:
        return Reference('dynamic');
    }
  }

  String _getDartTypeFromJsonType(Subtype subtype) {
    final type = subtype.listType;
    if (type == JsonType.INT) {
      return 'int';
    } else if (type == JsonType.DOUBLE) {
      return 'double';
    } else if (type == JsonType.STRING) {
      return 'String';
    } else if (type == JsonType.MAP) {
      return ReCase(subtype.name).pascalCase;
    } else {
      return 'dynamic';
    }
  }

  ListBuilder<Method> _buildMethods() => ListBuilder(fields.map(
        (Subtype s) => Method(
              (b) => b
                ..name = ReCase(s.name).camelCase
                ..returns = _getDartType(s)
                ..annotations.add(CodeExpression(
                  Code("BuiltValueField(wireName: '${s.name}')"),
                ))
                ..type = MethodType.getter,
            ),
      ));

  @override
  String toString() => _generateStringClass();
}
