import 'dart:io';

import 'package:process_run/process_run.dart';

import 'android.dart';
import 'cocoapods.dart';
import 'flutter.dart';
import 'git.dart';
import 'homebrew.dart';
import 'xcode.dart';

export 'dart:io';

export 'package:http/http.dart';
export 'package:process_run/process_run.dart';

export 'program.dart';

Future<void> install(Shell shell) async {
  try {
    await Android(shell).install();
    await Xcode(shell).install();
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

Future<void> update(Shell shell) async {
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

bool isInstalled(
    {required List<ProcessResult> processResult, required String programName}) {
  return processResult.outText.contains(programName);
}

Future<String> setToUserCurrentPath(Shell shell) async {
  final user = (await shell.run('id -u -n'))[0].outText;
  final userPath = '/Users/$user/';
  Directory.current = userPath;
  return userPath;
}
