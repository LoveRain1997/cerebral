import 'dart:async';
import 'package:flutter/widgets.dart';

abstract class Action {
  bool get isWarp;
}

class CerebralState {
  const CerebralState();
}

typedef T Signal<T>(Action action, T state);
typedef T MapFunction<T, S>(S state);

class Store<T> {
  T _state;
  Map<Action, List<Signal>> _signals;
  // ignore: close_sinks
  StreamController<T> _controller;
  Stream<T> _stream;

  T get state => _state;
  Store(this._state, this._signals) {
    this._controller = StreamController<T>.broadcast();
    this._stream = this._controller.stream;
  }

  StreamBuilder connector<T1>({
    MapFunction<T1, T> map,
    AsyncWidgetBuilder<T1> builder,
    Key key,
  }) {
    T1 previousValue;
    return StreamBuilder(
      key: key,
      stream: this._stream.transform(StreamTransformer<T, T1>.fromHandlers(
          handleData: (T data, EventSink<T1> sink) {
        final transformed = map(data);
        if (previousValue.hashCode != transformed.hashCode &&
            previousValue != transformed) {
          previousValue = transformed;
          sink.add(transformed);
        }
      })),
      builder: builder,
    );
  }

  void consume(Action action) {
    if (this._signals.containsKey(action)) {
      final signals = this._signals[action];
      T state = this._state;
      for (int i = 0; i < signals.length; i++) {
        state = signals[i](action, state);
      }
      this._state = state;
      if (action.isWarp) {
        // TODO persist to storage
      }
      this._controller.add(this._state);
    }
  }
}
