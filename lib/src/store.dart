import 'dart:async';

import 'package:cerebral/src/base.dart';
import 'package:flutter/widgets.dart';

import 'action.dart';
import 'persistor.dart';
import 'state.dart';

typedef void ActionResolver<T>(Action action, T state);
typedef T MapFunction<T, S>(S state);
typedef StateWidgetBuilder<T> = Widget Function(BuildContext context, T subState);

abstract class CerebralStore<T extends CerebralState, P extends Persistor> extends StoreBase {
  // ignore: close_sinks
  StreamController<T> _controller;
  T state;
  P persistor;
  Map<Type, List<ActionResolver>> _signals;
  Stream<T> _stream;

  CerebralStore() {
    this._signals = {};
    this._controller = StreamController<T>.broadcast();
    this._stream = this._controller.stream;
    this.initialize(this._signals);
  }

  void initialize(Map<Type, List<ActionResolver>> signals);

  StreamBuilder connector<S>({
    MapFunction<S, T> map,
    StateWidgetBuilder<S> builder,
    Key key,
  }) {
    S previousData = map(this.state);
    final transformerHandler = (T data, EventSink<S> sink) {
      final transformed = map(data);
      if (previousData.hashCode != transformed.hashCode && previousData != transformed) {
        previousData = transformed;
        sink.add(transformed);
      }
    };
    final transformer = StreamTransformer<T, S>.fromHandlers(handleData: transformerHandler);
    return StreamBuilder(
      key: key,
      stream: this._stream.transform(transformer),
      initialData: previousData,
      builder: (context, snapshot) => builder(context, snapshot.data),
    );
  }

  void consume(Action action) {
    final type = action.runtimeType;
    if (this._signals.containsKey(type)) {
      final signals = this._signals[type];
      for (int i = 0; i < signals.length; i++) {
        signals[i](action, this.state);
      }
      if (action is NormalAction) {
        this._controller.add(this.state);
      }
    }
  }
}
