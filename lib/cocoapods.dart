import 'dart:io';

import 'package:environment_setup/program.dart';
import 'package:process_run/process_run.dart';

import 'util.dart';

class Cocoapods implements Program {
  Cocoapods(this._shell);

  final Shell _shell;

  @override
  Future<bool> isProgramInstalled() async {
    return isInstalled(
      processResult: await _shell.run('pod --version --verbose'),
      programName: 'pod',
    );
  }

  @override
  Future<void> install() async {
    final isInstalled = await isProgramInstalled();

    if (isInstalled) {
      stdout.writeln('Cocoapods already installed.');
    } else {
      stdout.writeln('Installing Cocoapods.');
      await _shell.run('brew install cocoapods');
      stdout.writeln('Cocoapods installed.');
    }
  }

  @override
  Future<void> update() async {
    final isInstalled = await isProgramInstalled();

    if (isInstalled) {
      stdout.writeln('Updating Cocoapods.');
      await _shell.run('brew upgrade cocoapods');
      stdout.writeln('Cocoapods updated.');
    } else {
      stdout.writeln('Cocoapods not installed');
    }
  }
}
