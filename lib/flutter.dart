import 'dart:io';

import 'package:environment_setup/program.dart';
import 'package:process_run/process_run.dart';

import 'util.dart';

class Flutter implements Program {
  Flutter(this._shell);

  final Shell _shell;

  @override
  Future<bool> isProgramInstalled() async {
    return isInstalled(
      processResult: await _shell.run('flutter --version'),
      programName: 'Flutter',
    );
  }

  @override
  Future<void> install() async {
    final isInstalled = await isProgramInstalled();

    if (isInstalled) {
      stdout.writeln('Flutter already installed');
    } else {
      stdout.writeln('Installing Flutter');
      final userPath = setToUserCurrentPath(_shell);
      await _shell.run(
        'git clone https://github.com/flutter/flutter.git -b stable',
      );
      final File file = File('.zshrc');
      file.writeAsStringSync(
        'export PATH="\$PATH":"$userPath/flutter/bin"',
        mode: FileMode.append,
      );
      file.writeAsStringSync(
        'export PATH="\$PATH":"\$HOME/.pub-cache/bin"',
        mode: FileMode.append,
      );
      stdout.writeln('Accepting Android Licenses.');
      await _shell.run(
        'yes | flutter doctor --android-licenses',
      );
      stdout.writeln('Flutter installed.');
    }
  }

  @override
  Future<void> update() async {
    final isInstalled = await isProgramInstalled();

    if (isInstalled) {
      stdout.writeln('Updating Flutter.');
      await _shell.run('flutter upgrade');
      stdout.writeln('Flutter updated.');
    } else {
      stdout.writeln('Flutter not installed');
    }
  }
}
