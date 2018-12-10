import 'dart:async';

import 'package:cerebral/src/base.dart';
import 'package:flutter/widgets.dart';

import 'action.dart';

typedef T Signal<T>(Action action, T state);
typedef T MapFunction<T, S>(S state);

class Store<T> extends StoreBase {
  // ignore: close_sinks
  StreamController<T> _controller;
  T _state;
  Map<Action, List<Signal>> _signals;
  Stream<T> _stream;

  T get state => _state;

  Store() {
    this._controller = StreamController<T>.broadcast();
    this._stream = this._controller.stream;
  }

  StreamBuilder connector<S>({
    MapFunction<S, T> map,
    AsyncWidgetBuilder<S> builder,
    Key key,
  }) {
    S previousValue;
    return StreamBuilder(
      key: key,
      stream: this._stream.transform(StreamTransformer<T, S>.fromHandlers(
          handleData: (T data, EventSink<S> sink) {
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
      if (action is WarpAction) {
        // TODO persist to storage
      }
      this._controller.add(this._state);
    }
  }
}
