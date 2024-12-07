import 'package:dit/repository.dart';

void main(List<String> args) {
  final repo = Repository();

  if (args.isEmpty) {
    print('Usage: dit <command> [<args>]');
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
    default:
      print('Unknown command: $command');
  }
}
