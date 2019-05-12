# json2builtvalue

Generates Dart built_value classes from given JSON String.

Examples:

```dart
json2builtvalue -h
json2builtvalue -n todo -i todo.json -o todo.dart
echo '{
  "userId": 1,
  "id": 1,
  "title": "delectus aut autem",
  "completed": false
}' | dart bin/main.dart -n todo
```

Based upon [json2builtvalue](https://github.com/glacion/json2builtvalue) which is based on [json2builtvalue](https://github.com/charafau/json2builtvalue)