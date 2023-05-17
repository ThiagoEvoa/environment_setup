import 'dart:io';

import 'package:environment_setup/program.dart';
import 'package:process_run/process_run.dart';

import 'util.dart';

class Flutter implements Program {
  Flutter(this._shell);

  final Shell _shell;

  @override
  Future<bool> checkInstallation() async {
    return isInstalled(
      processResult: await _shell.run('flutter --version'),
      programName: 'Flutter',
    );
  }

  @override
  Future<void> install() async {
    final isInstalled = await checkInstallation();

    if (isInstalled) {
      stdout.writeln('Flutter already installed');
      await update();
    } else {
      stdout.writeln('Flutter not installed, would you like to install? (y/n)');
      if (shouldExecute(awnser: stdin.readLineSync())) {
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
      } else {
        stdout.writeln('Flutter not installed.');
      }
    }
  }

  @override
  Future<void> update() async {
    final isInstalled = await checkInstallation();

    if (isInstalled) {
      stdout.writeln('Would you like to update Flutter? (y/n)');
      if (shouldExecute(awnser: stdin.readLineSync())) {
        await _shell.run('flutter upgrade');
        stdout.writeln('Flutter updated.');
      } else {
        stdout.writeln('Flutter not updated.');
      }
    } else {
      stdout.writeln('Flutter not installed');
      await install();
    }
  }
}
