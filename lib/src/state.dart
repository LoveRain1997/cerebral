import 'store.dart';

abstract class CerebralState {
  CerebralState(this.host) : assert(host != null);

  final CerebralStore host;
}

class EmptyState extends CerebralState {
  EmptyState(CerebralStore host) : super(host);
}