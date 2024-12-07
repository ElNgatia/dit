import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:glob/glob.dart';

String hashFile(File file) {
  return sha1.convert(file.readAsBytesSync()).toString();
}

bool isIgnored(String filePath, List<String> patterns) {
  for (final pattern in patterns) {
    final glob = Glob(pattern);
    if (glob.matches(filePath)) {
      return true; // File matches an ignore pattern
    }
  }
  return false; // File does not match any pattern
}

String generateCommitId() {
  return sha1.convert(utf8.encode(DateTime.now().toIso8601String())).toString();
}
