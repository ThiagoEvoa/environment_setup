import 'dart:io';

import 'package:environment_setup/program.dart';
import 'package:process_run/process_run.dart';

import 'util.dart';

class Git implements Program {
  Git(this._shell);

  final Shell _shell;

  @override
  Future<bool> isProgramInstalled() async {
    return isInstalled(
      processResult: await _shell.run('git --version'),
      programName: 'git',
    );
  }

  @override
  Future<void> install() async {
    final isInstalled = await isProgramInstalled();

    if (isInstalled) {
      stdout.writeln('Git already installed.');
    } else {
      stdout.writeln('Installing Git.');
      await _shell.run('brew install git');
      stdout.writeln('Git installed.');
    }
  }

  @override
  Future<void> update() async {
    final isInstalled = await isProgramInstalled();

    if (isInstalled) {
      stdout.writeln('Updating Git.');
      await _shell.run('brew upgrade git');
      stdout.writeln('Git updated.');
    } else {
      stdout.writeln('Git not installed');
    }
  }
}
