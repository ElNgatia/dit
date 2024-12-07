import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dit/repository.dart';
import 'package:test/test.dart';
import 'package:dit/commit.dart';

void main() {
  group('Commit', () {
    final commit = Commit();
    final repository = Repository();

    setUp(() {
      if (Directory('.dit').existsSync()) {
        Directory('.dit').deleteSync(recursive: true);
      }
      repository.init();
    });

    tearDown(() {
      if (File('.ditignore').existsSync()) {
        File('.ditignore').deleteSync();
        
      }
      if (Directory('.dit').existsSync()) {
        Directory('.dit').deleteSync(recursive: true);
      }
      if (File('test_file.txt').existsSync()) {
        File('test_file.txt').deleteSync();
      }
    });

    test('create fails when no changes are staged', () {
      commit.create('Initial commit');

      expect(File('.dit/refs/heads/main').readAsStringSync(), isEmpty);
    });

    test('create writes commit data to objects directory', () {
      final file = File('test_file.txt')..writeAsStringSync('Hello World');
      File('.dit/index').writeAsStringSync(
          '{"path":"test_file.txt","hash":"${sha1.convert(file.readAsBytesSync()).toString()}"}\n');

      commit.create('Initial commit');

      final head = File('.dit/refs/heads/main').readAsStringSync();
      final commitFile = File('.dit/objects/$head');
      expect(commitFile.existsSync(), isTrue);

      final commitData = commitFile.readAsStringSync();
      expect(commitData, contains('"message":"Initial commit"'));
      expect(commitData, contains('"path":"test_file.txt"'));
    });
  });
}
