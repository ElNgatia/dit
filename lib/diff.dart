import 'dart:convert';
import 'dart:io';

import 'package:dit/utils.dart';

class Diff {
  /// Generate a diff between two sets of files.
  Map<String, String> generateDiff(List<String> base, List<String> other) {
    final diff = <String, String>{};

    final baseFiles = {for (var entry in base) jsonDecode(entry)['path']: entry};
    final otherFiles = {for (var entry in other) jsonDecode(entry)['path']: entry};

    // Detect modifications, additions, and deletions
    for (final file in otherFiles.keys) {
      if (!baseFiles.containsKey(file)) {
        diff[file] = 'added';
      } else if (baseFiles[file] != otherFiles[file]) {
        diff[file] = 'modified';
      }
    }

    for (final file in baseFiles.keys) {
      if (!otherFiles.containsKey(file)) {
        diff[file] = 'deleted';
      }
    }

    return diff;
  }

  /// Perform a three-way merge and detect conflicts.
  void threeWayMerge(String targetBranch, String sourceBranch) {
    final targetCommit = File('.dit/$targetBranch').readAsStringSync().trim();
    final sourceCommit = File('.dit/refs/heads/$sourceBranch').readAsStringSync().trim();

    final baseCommit = _findCommonAncestor(sourceCommit, targetCommit);
    if (baseCommit == null) {
      print('No common ancestor found. Cannot merge.');
      return;
    }

    final baseFiles = jsonDecode(File('.dit/objects/$baseCommit').readAsStringSync())['files'];
    final sourceFiles = jsonDecode(File('.dit/objects/$sourceCommit').readAsStringSync())['files'];
    final targetFiles = jsonDecode(File('.dit/objects/$targetCommit').readAsStringSync())['files'];

    final sourceDiff = generateDiff(baseFiles, sourceFiles);
    final targetDiff = generateDiff(baseFiles, targetFiles);

    final conflicts = <String>[];
    final mergedFiles = <String>[];

    for (final file in {...sourceDiff.keys, ...targetDiff.keys}) {
      if (sourceDiff[file] == targetDiff[file]) {
        // No conflict; apply change
        mergedFiles.add(
          sourceDiff[file] == 'deleted'
              ? null
              : (sourceDiff[file] == 'modified' ? sourceFiles.firstWhere((f) => jsonDecode(f)['path'] == file) : targetFiles.firstWhere((f) => jsonDecode(f)['path'] == file)),
        );
      } else {
        // Conflict detected
        conflicts.add(file);
      }
    }

    if (conflicts.isNotEmpty) {
      print('Merge conflicts detected in: ${conflicts.join(', ')}');
      return;
    }

    // Commit the merged files
    final mergeCommitId = generateCommitId();
    final mergeCommitFile = File('.dit/objects/$mergeCommitId');

    final mergeData = jsonEncode({
      'id': mergeCommitId,
      'message': 'Merge branch $sourceBranch into $targetBranch',
      'parents': [sourceCommit, targetCommit],
      'files': mergedFiles,
      'timestamp': DateTime.now().toIso8601String(),
    });

    mergeCommitFile.writeAsStringSync(mergeData);
    File('.dit/refs/heads/$targetBranch').writeAsStringSync(mergeCommitId);

    print('Merged branch $sourceBranch into $targetBranch.');
  }

  /// Find the common ancestor of two commits.
  String? _findCommonAncestor(String commit1, String commit2) {
    final visited = <String>{};

    // Traverse the first commit's ancestry
    String? current = commit1;
    while (current != null && current.isNotEmpty) {
      visited.add(current);
      final commitFile = File('.dit/objects/$current');
      if (!commitFile.existsSync()) break;
      current = jsonDecode(commitFile.readAsStringSync())['parent'];
    }

    // Traverse the second commit's ancestry
    current = commit2;
    while (current != null && current.isNotEmpty) {
      if (visited.contains(current)) {
        return current; // Found the common ancestor
      }
      final commitFile = File('.dit/objects/$current');
      if (!commitFile.existsSync()) break;
      current = jsonDecode(commitFile.readAsStringSync())['parent'];
    }

    return null; // No common ancestor
  }
}
