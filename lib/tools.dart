import 'dart:io';

import 'package:environment_setup/util.dart';
import 'package:http/http.dart' as http;
import 'package:process_run/process_run.dart';

class Tools {
  Tools(this._shell);

  final Shell _shell;
  final httpClient = http.Client();

  bool _isAndroidStudioInstalled() {
    return FileSystemEntity.isDirectorySync('/Applications/Android Studio.app');
  }

  bool _isXcodeInstalled() {
    return FileSystemEntity.isDirectorySync('/Applications/Xcode.app');
  }

  Future<void> setUp() async {
    if (!_isAndroidStudioInstalled()) {
      stdout.writeln('Downloading Android Studio.');
      final url =
          'https://redirector.gvt1.com/edgedl/android/studio/install/2022.2.1.19/android-studio-2022.2.1.19-mac_arm.dmg';
      final fileName = url.substring(url.lastIndexOf('/') + 1);
      File androidStudioFile = File(
        '/Users/thiagoevoa/Downloads/$fileName',
      );

      final request = await httpClient.get(
        Uri.parse(url),
      );
      final bytes = request.bodyBytes;
      androidStudioFile.writeAsBytesSync(bytes);

      stdout.writeln('Installing Android Studio.');
      await _shell.run(
        'hdiutil attach /Users/thiagoevoa/Downloads/$fileName',
      );

      final hdUtilInfo = await _shell.run('hdiutil info');

      final mounted = hdUtilInfo.outLines
          .toList()[hdUtilInfo.outLines.toList().length - 1]
          .substring(0, 12)
          .trim();

      final path = hdUtilInfo.outLines
          .toList()[hdUtilInfo.outLines.toList().length - 1]
          .substring(50);

      await _shell.run('sudo cp -R "$path/Android Studio.app" /Applications');

      await _shell.run('hdiutil detach $mounted');

      await _shell.run('open /Applications/Android Studio.app');

      stdout.writeln('Setting up Java environment variable.');

      final androidStudioContentPath =
          '/Applications/Android Studio.app/Contents/';

      await _shell.run(
        'cp -R $androidStudioContentPath/jbr $androidStudioContentPath/jre',
      );

      setToUserCurrentPath(_shell);

      final zshrcFile = File('.zshrc');
      zshrcFile.writeAsStringSync(
        'export JAVA_HOME=/Applications/Android Studio.app/Contents/jre/Contents/Home',
        mode: FileMode.append,
      );

      androidStudioFile.delete();

      stdout.writeln('Android Studio installed.');
    }

    if (!_isXcodeInstalled()) {
      await _shell.run(
        'open itms-apps://apps.apple.com/us/app/xcode/id497799835?mt=12',
      );
      stdout.writeln(
        'Press any key to continue after Xcode manually installation is complete.',
      );
      if (!_isXcodeInstalled()) {
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
}
