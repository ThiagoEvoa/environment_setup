import 'package:http/http.dart' as http;

import 'util.dart';

class Android implements Program {
  Android(this._shell);

  final Shell _shell;
  late String fileName;
  late File androidStudioFile;

  Future<String> _getAndroidStudioUrl() async {
    if (Platform.isMacOS) {
      List<ProcessResult> results = await _shell.run('uname -m');
      if (results[0].outText == 'arm64') {
        return 'https://redirector.gvt1.com/edgedl/android/studio/install/2022.2.1.19/android-studio-2022.2.1.19-mac_arm.dmg';
      } else {
        return 'https://redirector.gvt1.com/edgedl/android/studio/install/2022.2.1.19/android-studio-2022.2.1.19-mac.dmg';
      }
    } else if (Platform.isLinux) {
      throw UnimplementedError('Linux not implemented yet.');
      // return 'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.2.1.19/android-studio-2022.2.1.19-linux.tar.gz';
    } else {
      throw UnimplementedError('Windows not implemented yet.');
      // return 'https://redirector.gvt1.com/edgedl/android/studio/install/2022.2.1.19/android-studio-2022.2.1.19-windows.exe';
    }
  }

  Future<void> _downloadAndroidStudio() async {
    stdout.writeln('Downloading Android Studio.');
    final url = await _getAndroidStudioUrl();
    fileName = url.substring(url.lastIndexOf('/') + 1);
    androidStudioFile = File(
      '/Users/thiagoevoa/Downloads/$fileName',
    );
    final httpClient = http.Client();
    final request = await httpClient.get(
      Uri.parse(url),
    );
    final bytes = request.bodyBytes;
    androidStudioFile.writeAsBytesSync(bytes);
  }

  Future<void> _setJavaEnvironment() async {
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
  }

  @override
  Future<bool> isProgramInstalled() async {
    return FileSystemEntity.isDirectorySync('/Applications/Android Studio.app');
  }

  @override
  Future<void> install() async {
    final isInstalled = await isProgramInstalled();

    if (isInstalled) {
      stdout.writeln('Android Studio already installed.');
    } else {
      _downloadAndroidStudio();
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
      androidStudioFile.delete();
      _setJavaEnvironment();
      stdout.writeln('Android Studio installed.');
    }
  }

  @override
  Future<void> update() {
    throw UnimplementedError();
  }
}
