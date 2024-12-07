import 'dart:convert';
import 'dart:io';

import 'utils.dart';

class Commit {
  void create(String message) {
    final index = File('.dit/index');
    final stagedFiles = index.readAsLinesSync();

    if (stagedFiles.isEmpty) {
      print('No changes to commit.');
      return;
    }

    final commitId = generateCommitId();
    final commitFile = File('.dit/objects/$commitId');
    final headBranch = File('.dit/HEAD').readAsStringSync().trim();
    final parentCommit = File('.dit/refs/$headBranch').readAsStringSync().trim();

    final commitData = jsonEncode({
      'id': commitId,
      'message': message,
      'parent': parentCommit,
      'files': stagedFiles,
      'timestamp': DateTime.now().toIso8601String(),
    });

    commitFile.writeAsStringSync(commitData);
    File('.dit/refs/$headBranch').writeAsStringSync(commitId);

    index.writeAsStringSync('');
    print('Committed changes as $commitId');
  }
}