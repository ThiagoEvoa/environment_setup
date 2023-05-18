import 'util.dart';

class Xcode implements Program {
  Xcode(this._shell);

  final Shell _shell;

  @override
  Future<bool> isProgramInstalled() async {
    return FileSystemEntity.isDirectorySync('/Applications/Xcode.app');
  }

  @override
  Future<void> install() async {
    final isInstalled = await isProgramInstalled();
    if (isInstalled) {
      stdout.writeln('Xcode already installed.');
    } else {
      await _shell.run(
        'open itms-apps://apps.apple.com/us/app/xcode/id497799835?mt=12',
      );
      stdout.writeln(
        'Press any key to continue after Xcode manually installation is complete.',
      );
      if (isInstalled) {
        stdout.writeln('Finish installing Xcode to continue.');
        exit(1);
      }
      stdout.writeln(
        'Openning Xcode to finish installation',
      );
      await _shell.run(
        'open /Applications/Xcode.app',
      );
      stdout.writeln('Xcode installed.');
    }
  }

  @override
  Future<void> update() {
    throw UnimplementedError();
  }
}
