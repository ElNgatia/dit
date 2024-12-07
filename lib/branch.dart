import 'dart:io';

class Branch {
  void create(String branchName) {
    final headBranch = File('.dit/HEAD').readAsStringSync().trim();
    final commitId = File('.dit/refs/$headBranch').readAsStringSync().trim();
    File('.dit/refs/heads/$branchName').writeAsStringSync(commitId);

    print('Created branch $branchName.');
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
    final targetCommit = File('.dit/refs/$targetBranch').readAsStringSync().trim();

    if (sourceCommit == targetCommit) {
      print('Already up-to-date.');
      return;
    }


  }
}