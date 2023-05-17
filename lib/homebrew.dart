import 'dart:io';

import 'package:environment_setup/program.dart';
import 'package:process_run/process_run.dart';

import 'util.dart';

class Homebrew implements Program {
  Homebrew(this._shell);

  final Shell _shell;

  @override
  Future<bool> checkInstallation() async {
    return isInstalled(
      processResult: await _shell.run('brew --version'),
      programName: 'Homebrew',
    );
  }

  @override
  Future<void> install() async {
    final isInstalled = await checkInstallation();

    if (isInstalled) {
      stdout.writeln('Homebrew already installed.');
      await update();
    } else {
      stdout
          .writeln('Homebrew not installed, would you like to install? (y/n)');
      if (shouldExecute(awnser: stdin.readLineSync())) {
        stdout.writeln('Installing Homebrew.');
        await _shell.run(
          '/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"',
        );
        stdout.writeln('Homebrew installed.');
      } else {
        stdout.writeln(
          'Can\'t continue with installation process because it depends on Homebrew.',
        );
        exit(1);
      }
    }
  }

  @override
  Future<void> update() async {
    final isInstalled = await checkInstallation();

    if (isInstalled) {
      stdout.writeln(
        'Would you like to update Homebrew and all formulae list? (y/n)',
      );
      if (shouldExecute(awnser: stdin.readLineSync())) {
        await _shell.run('brew upgrade');
        stdout.writeln('Homebrew and all formulae list updated.');
      } else {
        stdout.writeln(
          'Would you like to update Homebrew? (y/n)',
        );
        if (shouldExecute(awnser: stdin.readLineSync())) {
          await _shell.run('brew update');
          stdout.writeln('Homebrew updated.');
        } else {
          stdout.writeln('Homebrew not updated.');
        }
      }
    } else {
      stdout.writeln('Homebrew not installed.');
      await install();
    }
  }
}
