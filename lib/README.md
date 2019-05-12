Library for generating Dart built_value classes from given JSON.  
Extracted from [charafau](https://github.com/charafau)'s [json2builtvalue](https://github.com/charafau/json2builtvalue)

## Usage

A simple usage example:

```dart
// Initialize Parser
var parser = Parser(); 
// Sample JSON data
var json = """{
"userId": 1,
"id": 1,
"title": "delectus aut autem",
"completed": false
}""";
// Parse JSON with root class name.
var parsed = parser.parse(json, 'todo');
print(parsed);
```

## Notes

* Currently does not play well with inner objects as lists, example;

  ```json
  {
    "size": 2,
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
  ```
  Assuming that the inner class's name should be `Todo`, since there is no way to learn this from, in the generated code the inner class will have name of `Items` instead of `Todo`, you should check this manually.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/glacion/json2builtvalue/issues
