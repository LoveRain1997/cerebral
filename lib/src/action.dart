abstract class Action {
  Action(this.type);

  final _ActionType type;
}

enum _ActionType {
  initialize,
  normal,
}

abstract class InitializeAction extends Action {
  InitializeAction() : super(_ActionType.initialize);
}

abstract class NormalAction extends Action {
  NormalAction() : super(_ActionType.normal);
}

class Resolver {
  const Resolver(
    this.store, {
    this.priority = 100,
  });

  final int priority;
  final Type store;
}

class AutoSave {
  const AutoSave();
}
