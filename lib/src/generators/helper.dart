import 'package:async/async.dart';

Stream<String> normalizeGeneratorOutput(Object value) {
  if (value == null) {
    return Stream.empty();
  } else if (value is Future) {
    return StreamCompleter.fromFuture(value.then(normalizeGeneratorOutput));
  } else if (value is String) {
    value = [value];
  }

  if (value is Iterable) {
    value = Stream.fromIterable(value as Iterable);
  }

  if (value is Stream) {
    return value.where((e) => e != null).map((e) {
      if (e is String) {
        return e.trim();
      }

      throw _argError(e);
    }).where((e) => e.isNotEmpty);
  }
  throw _argError(value);
}

ArgumentError _argError(Object value) => ArgumentError(
    'Must be a String or be an Iterable/Stream containing String values. '
    'Found `${Error.safeToString(value)}` (${value.runtimeType}).');
