import 'dart:async';

class _Event {
  _Event(this.name, {this.args = const []});

  final String name;
  final List<dynamic> args;
}

class EventBus {
  // ignore: close_sinks
  static final _controller = StreamController<_Event>.broadcast();

  static publish(String name, [List<dynamic> args = const []]) =>
      _controller.add(_Event(name, args: args));

  static Stream<List<dynamic>> subscribe(String name) => _controller.stream
      .where((event) => event.name == name)
      .transform(StreamTransformer<_Event, List<dynamic>>.fromHandlers(
        handleData: (event, sink) => sink.add(event.args),
        handleDone: (sink) => sink.close(),
        handleError: (error, stackTrace, sink) =>
            sink.addError(error, stackTrace),
      ));
}
