import 'package:args/args.dart';


final ArgParser argParser = ArgParser()
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
