import 'dart:convert';
import 'dart:io';

import 'utils.dart';

class Commit {
  void create(String message) {
    // Ensure the HEAD file exists
    final headFile = File('.dit/HEAD');
    if (!headFile.existsSync()) {
      print('Error: Repository not initialized. Run "init" first.');
      return;
    }

    // Read the current branch
    final headBranch = headFile.readAsStringSync().trim();
    final branchPath = headBranch.startsWith('refs/') ? headBranch.substring(5) : headBranch;

    // Ensure the branch file exists
    final branchFile = File('.dit/refs/$branchPath');
    if (!branchFile.existsSync()) {
      print('Error: Current branch $branchPath does not exist.');
      return;
    }

    final parentCommit = branchFile.readAsStringSync().trim();

    // Check if there are staged changes
    final indexFile = File('.dit/index');
    if (!indexFile.existsSync() || indexFile.readAsStringSync().trim().isEmpty) {
      print('No changes to commit.');
      return;
    }

    // Create the commit
    final stagedFiles = indexFile.readAsLinesSync();
    final commitId = generateCommitId();
    final commitFile = File('.dit/objects/$commitId');

    final commitData = jsonEncode({
      'id': commitId,
      'message': message,
      'parent': parentCommit,
      'files': stagedFiles,
      'timestamp': DateTime.now().toIso8601String(),
    });

    commitFile.writeAsStringSync(commitData);

    // Update the branch to point to the new commit
    branchFile.writeAsStringSync(commitId);

    // Clear the index
    indexFile.writeAsStringSync('');

    print('Committed changes as $commitId.');
  }
}
