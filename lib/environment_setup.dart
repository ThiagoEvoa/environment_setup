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

  Future<void> install() async {
    try {
      await Tools(shell).setUp();
      await Homebrew(shell).install();
      await Git(shell).install();
      await Cocoapods(shell).install();
      await Flutter(shell).install();
      stdout.write('Installation process finished.');
      exit(0);
    } catch (exception) {
      stderr.write(exception);
      exit(1);
    }
  }

  Future<void> update() async {
    try {
      await Homebrew(shell).update();
      await Git(shell).update();
      await Cocoapods(shell).update();
      await Flutter(shell).update();
      stdout.write('Update process finished.');
      exit(0);
    } catch (exception) {
      stderr.write(exception);
      exit(1);
    }
  }

  stdout.writeln('Would you like to install or update your enviroment?');
  answer = stdin.readLineSync();

  switch (answer) {
    case 'install':
    case 'Install':
      install();
      break;
    case 'update':
    case 'Update':
      update();
    default:
      stdout.write('Run the program with a correct option.');
  }
}
