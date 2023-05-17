import 'dart:io';

import 'package:environment_setup/program.dart';
import 'package:process_run/process_run.dart';

import 'util.dart';

class Git implements Program {
  Git(this._shell);

  final Shell _shell;

  @override
  Future<bool> checkInstallation() async {
    return isInstalled(
      processResult: await _shell.run('git --version'),
      programName: 'git',
    );
  }

  @override
  Future<void> install() async {
    final isInstalled = await checkInstallation();

    if (isInstalled) {
      stdout.writeln('Git already installed.');
      await update();
    } else {
      stdout.writeln('Git not installed, would you like to install? (y/n)');
      if (shouldExecute(awnser: stdin.readLineSync())) {
        stdout.writeln('Installing Git.');
        await _shell.run('brew install git');
        stdout.writeln('Git installed.');
      } else {
        stdout.writeln(
            'Can\'t continue with installation process because it depends on Git.');
        exit(1);
      }
    }
  }

  @override
  Future<void> update() async {
    final isInstalled = await checkInstallation();

    if (isInstalled) {
      stdout.writeln('Would you like to update Git? (y/n)');
      if (shouldExecute(awnser: stdin.readLineSync())) {
        await _shell.run('brew upgrade git');
        stdout.writeln('Git updated.');
      } else {
        stdout.writeln('Git not updated.');
      }
    } else {
      stdout.writeln('Git not installed');
      await install();
    }
  }
}
