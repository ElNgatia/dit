import 'dart:convert';
import 'dart:io';

import 'utils.dart';

class Commit {
  void create(String message) {
    const repoDir = '.dit';
    const objectsDir = '$repoDir/objects';

    final headFile = File('$repoDir/HEAD');
    if (!headFile.existsSync()) {
      print('Error: Repository not initialized. Run "init" first.');
      return;
    }

    // Get current branch
    final headBranch = headFile.readAsStringSync().trim();
    final branchPath = headBranch.startsWith('refs/') ? headBranch.substring(5) : headBranch;

    // Ensure the branch file exists
    final branchFile = File('.dit/refs/$branchPath');
    if (!branchFile.existsSync()) {
      print('Error: Current branch does not exist.');
      return;
    }

    final parentCommit = branchFile.readAsStringSync().trim();

    // Read staged files from index
    final indexFile = File('$repoDir/index');
    if (!indexFile.existsSync() || indexFile.readAsStringSync().trim().isEmpty) {
      print('No changes to commit.');
      return;
    }

    final stagedFiles = indexFile
        .readAsLinesSync()
        .map((line) => jsonDecode(line)) // Deserialize each line into a JSON object
        .toList();

    // Create a new commit
    final commitId = generateCommitId();
    final commitFile = File('$objectsDir/$commitId');

    final commitData = jsonEncode({
      'id': commitId,
      'message': message,
      'parent': parentCommit,
      'files': stagedFiles, // Store as JSON objects
      'timestamp': DateTime.now().toIso8601String(),
    });

    commitFile.writeAsStringSync(commitData);

    // Update branch to point to the new commit
    branchFile.writeAsStringSync(commitId);

    // Clear the index
    indexFile.writeAsStringSync('');

    print('Committed changes as $commitId.');
  }
}
