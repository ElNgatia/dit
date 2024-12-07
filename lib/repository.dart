import 'dart:io';

class Repository {
  static const String repoDir = '.dit';
  static const String objectsDir = '$repoDir/objects';
  static const String refsDir = '$repoDir/refs';
  static const String headFile = '$repoDir/HEAD';
  static const String indexFile = '$repoDir/index';
  static const String ignoreFile = '.ditignore';

  void init() {
    if (Directory(repoDir).existsSync()) {
      print('Repository already initialized.');
      return;
    }

    try {
      // Ensure base directory exists
      Directory(repoDir).createSync(recursive: true);

      // Create objects and refs/heads directories
      Directory(objectsDir).createSync(recursive: true);
      Directory("$refsDir/heads").createSync(recursive: true);

      // Create HEAD file pointing to main branch
      File(headFile).writeAsStringSync('refs/heads/main');

      // Initialize main branch with no commits
      File('$refsDir/heads/main').writeAsStringSync('');

      // Create an empty index file
      File(indexFile).writeAsStringSync('');

      // Create a default .ditignore file
      File(ignoreFile).writeAsStringSync('# Add patterns to ignore files and directories\n');

      print('Initialized empty repository in $repoDir');
    } catch (e) {
      print('Error during repository initialization: $e');
    }
  }

  void clone(String targetDir) {
    if (!Directory(repoDir).existsSync()) {
      print('No repository found.');
      return;
    }

    final target = Directory(targetDir);
    if (target.existsSync()) {
      print('Target directory $targetDir already exists.');
      return;
    }

    Directory(repoDir).renameSync(target.path);
    print('Cloned repository to $targetDir');
  }
}
