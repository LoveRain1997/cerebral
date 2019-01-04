import 'store.dart';

abstract class CerebralState {
  CerebralState(this.host) : assert(host != null);

  final CerebralStore host;
}