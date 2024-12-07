import 'dart:convert';
import 'dart:io';

import 'package:dit/utils.dart';

class Index {
  final List<String> ignorePatterns;

  Index(this.ignorePatterns);

  void add(String filePath) {
    final file = File(filePath);

    if (!file.existsSync()) {
      print('File $filePath does not exist.');
      return;
    }

    if (isIgnored(filePath, ignorePatterns)) {
      print('File $filePath is ignored.');
      return;
    }

    final hash = hashFile(file);
    final entry = jsonEncode({'path': filePath, 'hash': hash});
    File('.dit/index').writeAsStringSync('$entry\n', mode: FileMode.append);

    print('Added $filePath to staging.');
  }
}
