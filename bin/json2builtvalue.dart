import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:json2builtvalue/json2builtvalue.dart';

enum ValidationResult {
  successful,
  nameRequired,
  fileNotFound,
  canNotOverwrite,
}

main(List<String> arguments) {
  var argResults = _argParser.parse(arguments);
  if (argResults['help'])
    print(_argParser.usage);
  else if (!handleValidation(argResults)) return;
  run(argResults['name'], argResults['input'], argResults['output'], Parser());
}

final ArgParser _argParser = ArgParser()
  ..addSeparator("Generates Dart built_value classes from given JSON")
  ..addSeparator("Usage: json2builtvalue " +
      "[-n <root class name>] [-i <input file>] [-o <output file>]")
  ..addOption(
    'name',
    abbr: 'n',
    help: "The name of the root class",
  )
  ..addOption(
    'input',
    abbr: 'i',
    defaultsTo: '-',
    help: "The input file; for reading from stdin don't use this option",
  )
  ..addOption(
    'output',
    abbr: 'o',
    defaultsTo: '-',
    help: "The output file; for outputting to stdout don't use this option",
  )
  ..addFlag(
    'help',
    abbr: 'h',
    help: "Print this message",
    negatable: false,
    defaultsTo: false,
  )
  ..addFlag(
    'force',
    abbr: 'f',
    help: "Force overwriting existing output file",
    negatable: false,
    defaultsTo: false,
  );

bool fileExists(String name) =>
    FileSystemEntity.typeSync(name) != FileSystemEntityType.notFound;

ValidationResult validate(ArgResults results) {
  if (results['name'] == null) {
    return ValidationResult.nameRequired;
  } else if (results['input'] != '-' && !fileExists(results['input'])) {
    return ValidationResult.fileNotFound;
  } else if (fileExists(results['output']) && !results['force']) {
    return ValidationResult.canNotOverwrite;
  } else {
    return ValidationResult.successful;
  }
}

bool handleValidation(ArgResults argResults) {
  var validation = validate(argResults);
  bool res = false;
  if (validation == ValidationResult.canNotOverwrite) {
    print("Can not overwrite existing file without the force flag!");
  } else if (validation == ValidationResult.fileNotFound) {
    print("Input file does not exist!");
  } else if (validation == ValidationResult.nameRequired) {
    print("Root level class name is required!\n\n${_argParser.usage}");
  } else {
    res = true;
  }
  return res;
}

run(String name, String inputFile, String outputfile, Parser parser) async {
  var string = await read(inputFile);
  write(parser.parse(string, name), outputfile);
}

write(String result, String outFile) async {
  if (outFile == '-') {
    stdout.write(result);
  } else {
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
  } else {
    return File(inputFile).readAsString();
  }
}
