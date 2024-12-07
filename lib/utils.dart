import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

String hashFile(File file) {
  return sha1.convert(file.readAsBytesSync()).toString();
}

bool isIgnored(String filePath, List<String> patterns) {
  return false; // Simplified for brevity
}

String generateCommitId() {
  return sha1.convert(utf8.encode(DateTime.now().toIso8601String())).toString();
}
