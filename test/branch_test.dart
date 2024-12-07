import 'dart:io';
import 'package:dit/repository.dart';
import 'package:test/test.dart';
import 'package:dit/branch.dart';

void main() {
  group('Branch', () {
    final branch = Branch();
    final repository = Repository();

    setUp(() async {
      if (Directory('.dit').existsSync()) {
        Directory('.dit').deleteSync(recursive: true);
      }
      repository.init();
      File('.dit/refs/heads/main').writeAsStringSync('initial_commit');
    });

    tearDown(() {
      if (Directory('.dit').existsSync()) {
        Directory('.dit').deleteSync(recursive: true);
        File('.ditignore').deleteSync();
      }
      if (Directory('test_clone').existsSync()) {
        Directory('test_clone').deleteSync(recursive: true);
      }
    });

    test('create creates a new branch', () {
      branch.create('feature');

      final branchFile = File('.dit/refs/heads/feature');
      expect(branchFile.existsSync(), isTrue);
      expect(branchFile.readAsStringSync(), equals('initial_commit'));
    });

    test('checkout switches to an existing branch', () {
      branch.create('feature');
      branch.checkout('feature');

      final head = File('.dit/HEAD').readAsStringSync();
      expect(head, equals('refs/heads/feature'));
    });

    test('checkout fails for non-existent branch', () {
      branch.checkout('nonexistent');

      final head = File('.dit/HEAD').readAsStringSync();
      expect(head, equals('refs/heads/main'));
    });
  });
}
