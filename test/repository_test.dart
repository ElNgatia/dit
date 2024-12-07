import 'dart:io';
import 'package:test/test.dart';
import 'package:dit/repository.dart';

void main() {
  group('Repository', () {
    final repo = Repository();

    setUp(() {
      // Ensure a clean environment before each test
      if (Directory('.dit').existsSync()) {
        Directory('.dit').deleteSync(recursive: true);
      }
    });

    tearDown(() {
      // Ensure a clean environment after each test
      if (Directory('.dit').existsSync()) {
        Directory('.dit').deleteSync(recursive: true);
      }

      if (File('.ditignore').existsSync()) {
        File('.ditignore').deleteSync();
      }

      if (Directory('test_clone').existsSync()) {
        Directory('test_clone').deleteSync(recursive: true);
      }
    });
    test('init creates necessary repository structure', () {
      repo.init();

      expect(Directory('.dit').existsSync(), isTrue);
      expect(Directory('.dit/objects').existsSync(), isTrue);
      expect(Directory('.dit/refs').existsSync(), isTrue);
      expect(File('.dit/HEAD').existsSync(), isTrue);
      expect(File('.dit/index').existsSync(), isTrue);
      expect(File('.ditignore').existsSync(), isTrue);
    });

    test('init does not overwrite existing repository', () {
      repo.init();
      final headFile = File('.dit/HEAD');
      headFile.writeAsStringSync('refs/heads/test');

      repo.init();

      expect(headFile.readAsStringSync(), equals('refs/heads/test'));
    });

    test('clone creates a copy of the repository', () {
      repo.init();
      repo.clone('test_clone');

      expect(Directory('test_clone').existsSync(), isTrue);
      expect(File('test_clone/HEAD').existsSync(), isTrue);
    });
  });
}
