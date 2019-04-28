import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:json2builtvalue/src/arg_parser.dart';
import 'package:json2builtvalue/src/validation_result.dart';
import 'package:libjson2builtvalue/libjson2builtvalue.dart';

bool fileExists(String name) =>
    FileSystemEntity.typeSync(name) != FileSystemEntityType.notFound;

ValidationResult validate(ArgResults results) {
  if (results['name'] == null)
    return ValidationResult.nameRequired;
  else if (results['input'] != '-' && !fileExists(results['input']))
    return ValidationResult.fileNotFound;
  else if (fileExists(results['output']) && !results['force'])
    return ValidationResult.canNotOverwrite;
  else
    return ValidationResult.successful;
}

bool handleValidation(ArgResults argResults) {
  var validation = validate(argResults);
  bool res = false;
  if (validation == ValidationResult.canNotOverwrite)
    print("Can not overwrite existing file without the force flag!");
  else if (validation == ValidationResult.fileNotFound)
    print("Input file does not exist!");
  else if (validation == ValidationResult.nameRequired)
    print("Root level class name is required!\n\n${argParser.usage}");
  else
    res = true;
  return res;
}

init(List<String> arguments) async {
  var argResults = argParser.parse(arguments);
  if (argResults['help'])
    print(argParser.usage);
  else if (!handleValidation(argResults)) return;
  run(argResults['name'], argResults['input'], argResults['output'], Parser());
}

run(String name, String inputFile, String outputfile, Parser parser) async {
  var string = await read(inputFile);
  write(parser.parse(string, name), outputfile);
}

write(String result, String outFile) async {
  if (outFile == '-')
    stdout.write(result);
  else {
    var sink = File(outFile).openWrite();
    sink.write(result);
    await sink.flush();
    await sink.close();
  }
}

Future<String> read(String inputFile) async {
  if (inputFile == '-') {
    var raw = await stdin.transform(utf8.decoder).toList();
    return raw.join();
  } else
    return File(inputFile).readAsString();
}
