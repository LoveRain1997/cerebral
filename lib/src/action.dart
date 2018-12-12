abstract class Action {
  Action(this.type);

  final _ActionType type;
}

enum _ActionType {
  warp,
  flat,
}

abstract class WarpAction extends Action {
  WarpAction() : super(_ActionType.warp);
}

abstract class FlatAction extends Action {
  FlatAction() : super(_ActionType.flat);
}

class Resolver {
  const Resolver(
    this.store, {
    this.priority = 100,
  });

  final int priority;
  final Type store;
}
