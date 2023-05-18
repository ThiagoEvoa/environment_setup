import 'util.dart';

class Homebrew implements Program {
  Homebrew(this._shell);

  final Shell _shell;

  @override
  Future<bool> isProgramInstalled() async {
    return isInstalled(
      processResult: await _shell.run('brew --version'),
      programName: 'Homebrew',
    );
  }

  @override
  Future<void> install() async {
    final isInstalled = await isProgramInstalled();

    if (isInstalled) {
      stdout.writeln('Homebrew already installed.');
    } else {
      stdout.writeln('Installing Homebrew.');
      await _shell.run(
        '/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"',
      );
      stdout.writeln('Homebrew installed.');
    }
  }

  @override
  Future<void> update() async {
    final isInstalled = await isProgramInstalled();

    if (isInstalled) {
      stdout.writeln('Updating Homebrew.');
      await _shell.run('brew update');
      stdout.writeln('Homebrew updated.');
    } else {
      stdout.writeln('Homebrew not installed.');
    }
  }
}
