import 'dart:io';

import 'diff.dart';

class Branch {
  void create(String branchName) {
    // Get the current branch
    final headBranch = File('.dit/HEAD').readAsStringSync().trim();
    final branchPath = headBranch.startsWith('refs/') ? headBranch.substring(5) : headBranch;

    // Ensure the current branch commit exists
    final commitFile = File('.dit/refs/$branchPath');
    if (!commitFile.existsSync()) {
      print('Error: Current branch commit does not exist. $branchPath');
      return;
    }

    final commitId = commitFile.readAsStringSync().trim();

    // Create the new branch
    final newBranchFile = File('.dit/refs/heads/$branchName');
    newBranchFile.writeAsStringSync(commitId);

    print('Created branch $branchName at commit $commitId.');
  }

  void checkout(String branchName) {
    final branchPath = '.dit/refs/heads/$branchName';
    if (!File(branchPath).existsSync()) {
      print('Branch $branchName does not exist.');
      return;
    }

    File('.dit/HEAD').writeAsStringSync('refs/heads/$branchName');
    print('Switched to branch $branchName.');
  }

  void merge(String sourceBranch) {
    // Find commits
    final targetBranch = File('.dit/HEAD').readAsStringSync().trim();
    final sourceCommit = File('.dit/refs/heads/$sourceBranch').readAsStringSync().trim();
    final targetCommit = File('.dit/$targetBranch').readAsStringSync().trim();

    if (sourceCommit == targetCommit) {
      print('Already up-to-date.');
      return;
    }

    // Find diff and handle conflicts
    Diff().threeWayMerge(targetBranch, sourceBranch);
  }
}
