import 'dart:io';

import 'package:process_run/process_run.dart';

export 'cocoapods.dart';
export 'flutter.dart';
export 'git.dart';
export 'homebrew.dart';
export 'tools.dart';

bool isInstalled(
    {required List<ProcessResult> processResult, required String programName}) {
  return processResult.outText.contains(programName);
}

bool shouldExecute({String? awnser}) {
  switch (awnser) {
    case 'y':
    case 'yes':
      return true;
    case 'n':
    case 'no':
      return false;
    default:
      return false;
  }
}

Future<String> setToUserCurrentPath(Shell shell) async {
  final user = (await shell.run('id -u -n'))[0].outText;
  final userPath = '/Users/$user/';
  Directory.current = userPath;
  return userPath;
}
