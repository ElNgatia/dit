import 'package:dit/branch.dart';
import 'package:dit/commit.dart';
import 'package:dit/index.dart';
import 'package:dit/repository.dart';

void main(List<String> args) {
  final repo = Repository();
  final index = Index([]);
  final commit = Commit();
  final branch = Branch();

  if (args.isEmpty || args[0] == 'help') {
    printHelp();
    return;
  }

  final command = args[0];

  switch (command) {
    case 'init':
      repo.init();
      break;
    case 'clone':
      if (args.length < 2) {
        print('Usage: dit clone <target>');
        return;
      }
      repo.clone(args[1]);
      break;
    case 'add':
      if (args.length < 2) {
        print('Usage: dit add <file>');
        return;
      }
      index.add(args[1]);
      break;
    case 'commit':
      if (args.length < 2) {
        print('Usage: dit commit <message>');
        return;
      }
      commit.create(args[1]);
      break;
    case 'branch':
      if (args.length < 2) {
        print('Usage: dit branch <name>');
        return;
      }
      branch.create(args[1]);
      break;
    case 'checkout':
      if (args.length < 2) {
        print('Usage: dit checkout <branch>');
        return;
      }
      branch.checkout(args[1]);
      break;
    case 'merge':
      if (args.length < 2) {
        print('Usage: dit merge <branch>');
        return;
      }
      branch.merge(args[1]);
      break;
    default:
      print('Unknown command: $command');
  }
}

void printHelp() {
  print('Usage: dit <command> [<args>]\n');
  print('Commands:');
  print('  init          Initialize a new repository');
  print('  clone <target> Clone a repository');
  print('  add <file>    Add a file to the index');
  print('  commit <message> Commit changes with a message');
  print('  branch <name> Create a new branch');
  print('  checkout <branch> Checkout a branch');
  print('  merge <branch> Merge a branch');
  print('\nRun "dit <command> --help" for more information on a command.');
}
