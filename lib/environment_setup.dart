import 'dart:io';

import 'package:process_run/process_run.dart';

import 'util.dart';

void main(List<String> args) async {
  late String? answer;
  final shell = Shell(
    verbose: false,
    commandVerbose: false,
    commentVerbose: true,
  );

  stdout.writeln('Would you like to install or update your enviroment?');
  answer = stdin.readLineSync();

  switch (answer) {
    case 'install':
    case 'Install':
      install(shell);
      break;
    case 'update':
    case 'Update':
      update(shell);
    default:
      stdout.write('Run the program with a correct option.');
  }
}
