import 'dart:io';

import 'package:environment_setup/program.dart';
import 'package:process_run/process_run.dart';

import 'util.dart';

class Cocoapods implements Program {
  Cocoapods(this._shell);

  final Shell _shell;

  @override
  Future<bool> checkInstallation() async {
    return isInstalled(
      processResult: await _shell.run('pod --version --verbose'),
      programName: 'pod',
    );
  }

  @override
  Future<void> install() async {
    final isInstalled = await checkInstallation();

    if (isInstalled) {
      stdout.writeln('Cocoapods already installed.');
      await update();
    } else {
      stdout
          .writeln('Cocoapods not installed, would you like to install? (y/n)');
      if (shouldExecute(awnser: stdin.readLineSync())) {
        stdout.writeln('Installing Cocoapods.');
        await _shell.run('brew install cocoapods');
        stdout.writeln('Cocoapods installed.');
      } else {
        stdout.writeln('Cocoapods not installed.');
      }
    }
  }

  @override
  Future<void> update() async {
    final isInstalled = await checkInstallation();

    if (isInstalled) {
      stdout.writeln('Would you like to update Cocoapods? (y/n)');
      if (shouldExecute(awnser: stdin.readLineSync())) {
        await _shell.run('brew upgrade cocoapods');
        stdout.writeln('Cocoapods updated.');
      } else {
        stdout.writeln('Cocoapods not updated.');
      }
    } else {
      stdout.writeln('Cocoapods not installed');
      await install();
    }
  }
}
