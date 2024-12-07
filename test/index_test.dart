import 'dart:io';

import 'package:dit/index.dart';
import 'package:dit/repository.dart';
import 'package:test/test.dart';

void main() {
  group('Index', () {
    final ignorePatterns = ['*.log', 'build/'];
    final index = Index(ignorePatterns);
    final repository = Repository();

    setUp(() {
      if (Directory('.dit').existsSync()) {
        Directory('.dit').deleteSync(recursive: true);
      }
      repository.init();
    });

    tearDown(() {
      if (File('test_file.txt').existsSync()) {
        File('test_file.txt').deleteSync();
      }

      if (File('ignored.log').existsSync()) {
        File('ignored.log').deleteSync();
      }

      if (Directory('.dit').existsSync()) {
        Directory('.dit').deleteSync(recursive: true);
        File('.ditignore').deleteSync();
      }
    });

    test('add adds files to the staging area', () {
      // ignore: unused_local_variable
      final file = File('test_file.txt')..writeAsStringSync('Hello World');
      index.add('test_file.txt');

      final indexContent = File('.dit/index').readAsStringSync();
      expect(indexContent, contains('"path":"test_file.txt"'));
    });

    test('add ignores files matching patterns', () {
      // ignore: unused_local_variable
      final ignoredFile = File('ignored.log')..writeAsStringSync('Log data');
      index.add('ignored.log');

      final indexContent = File('.dit/index').readAsStringSync();
      expect(indexContent, isEmpty);
    });
  });
}
