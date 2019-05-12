import 'package:json2builtvalue/json2builtvalue.dart';

const _result = '''library user;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  User._();

  factory User([updates(UserBuilder b)]) = _\$User;

  @BuiltValueField(wireName: 'id')
  int get id;
  @BuiltValueField(wireName: 'name')
  String get name;
  @BuiltValueField(wireName: 'username')
  String get username;
  @BuiltValueField(wireName: 'email')
  String get email;
  @BuiltValueField(wireName: 'address')
  Address get address;
  @BuiltValueField(wireName: 'phone')
  String get phone;
  @BuiltValueField(wireName: 'website')
  String get website;
  @BuiltValueField(wireName: 'company')
  Company get company;
  String toJson() {
    return json.encode(serializers.serializeWith(User.serializer, this));
  }

  static User fromJson(String jsonString) {
    return serializers.deserializeWith(
        User.serializer, json.decode(jsonString));
  }

  static Serializer<User> get serializer => _\$userSerializer;
}
library address;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'address.g.dart';

abstract class Address implements Built<Address, AddressBuilder> {
  Address._();

  factory Address([updates(AddressBuilder b)]) = _\$Address;

  @BuiltValueField(wireName: 'street')
  String get street;
  @BuiltValueField(wireName: 'suite')
  String get suite;
  @BuiltValueField(wireName: 'city')
  String get city;
  @BuiltValueField(wireName: 'zipcode')
  String get zipcode;
  @BuiltValueField(wireName: 'geo')
  Geo get geo;
  String toJson() {
    return json.encode(serializers.serializeWith(Address.serializer, this));
  }

  static Address fromJson(String jsonString) {
    return serializers.deserializeWith(
        Address.serializer, json.decode(jsonString));
  }

  static Serializer<Address> get serializer => _\$addressSerializer;
}
library company;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'company.g.dart';

abstract class Company implements Built<Company, CompanyBuilder> {
  Company._();

  factory Company([updates(CompanyBuilder b)]) = _\$Company;

  @BuiltValueField(wireName: 'name')
  String get name;
  @BuiltValueField(wireName: 'catchPhrase')
  String get catchPhrase;
  @BuiltValueField(wireName: 'bs')
  String get bs;
  String toJson() {
    return json.encode(serializers.serializeWith(Company.serializer, this));
  }

  static Company fromJson(String jsonString) {
    return serializers.deserializeWith(
        Company.serializer, json.decode(jsonString));
  }

  static Serializer<Company> get serializer => _\$companySerializer;
}
''';

const _input = '''{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {
      "lat": "-37.3159",
      "lng": "81.1496"
    }
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
}''';

bool testMultiDepth() => Parser().parse(_input, 'User') == _result;