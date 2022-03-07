import 'dart:async';
import 'package:fibonacci_optimized/fibonacci_event.dart';

class FibonacciBloc {
  late int counter;
  late int fibonacci;

  final _counterStreamController = StreamController<int>();
  StreamSink<int> get counterSink => _counterStreamController.sink;
  Stream<int> get counterStream => _counterStreamController.stream;

  final _fibonacciStreamController = StreamController<int>();
  StreamSink<int> get fibonacciSink => _fibonacciStreamController.sink;
  Stream<int> get fibonacciStream => _fibonacciStreamController.stream;

  final _eventStreamController = StreamController<FibonacciEvent>();
  Sink<FibonacciEvent> get eventSink => _eventStreamController.sink;

  FibonacciBloc() {
    counter = 0;
    fibonacci = 0;
    //
    _eventStreamController.stream.listen(_mapingEvents);
  }
  fib(int n) {
    if (n < 2) return n;
    return fib(n - 1) + fib(n - 2);
  }

  _mapingEvents(FibonacciEvent event) async {
    if (event is FibonacciIncrementPressed) {
      counter++;
    }
    counterSink.add(counter);
    fibonacci = fib(counter);
    fibonacciSink.add(fibonacci);
  }

  void dispose() {
    _counterStreamController.close();
    _fibonacciStreamController.close();
    _eventStreamController.close();
  }
}