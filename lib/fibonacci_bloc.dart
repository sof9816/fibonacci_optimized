import 'dart:async';
import 'package:fibonacci_optimized/fibonacci_event.dart';
import 'package:flutter/foundation.dart';

class FibonacciBloc {
  late int counter;
  late int fibonacci;
  late bool isDoneCalculating;
  late Map tableOfdata;

  final _counterStreamController = StreamController<int>();
  StreamSink<int> get counterSink => _counterStreamController.sink;
  Stream<int> get counterStream => _counterStreamController.stream;

  final _stateStreamController = StreamController<bool>();
  StreamSink<bool> get stateSink => _stateStreamController.sink;
  Stream<bool> get stateStream => _stateStreamController.stream;

  final _tableStreamController = StreamController<Map>();
  StreamSink<Map> get tableSink => _tableStreamController.sink;
  Stream<Map> get tableStream => _tableStreamController.stream;

  final _fibonacciStreamController = StreamController<int>();
  StreamSink<int> get fibonacciSink => _fibonacciStreamController.sink;
  Stream<int> get fibonacciStream => _fibonacciStreamController.stream;

  final _eventStreamController = StreamController<FibonacciEvent>();
  Sink<FibonacciEvent> get eventSink => _eventStreamController.sink;

  FibonacciBloc() {
    counter = 0;
    fibonacci = 0;
    isDoneCalculating = true;
    tableOfdata = {};
    //
    _eventStreamController.stream.listen(_mapingEvents);
  }
  // Old function
  fib(int n) {
    if (n < 2) return n;
    return fib(n - 1) + fib(n - 2);
  }

  setTable(n, fib, status) {
    tableOfdata[n] = {status: fib};
  }

  // Optimized function
  Future fibOptimized(int n) async {
    // Add new reference
    setTable(n, 0, "Running");
    tableSink.add(tableOfdata);
    if (n < 2) {
      // Add new reference
      setTable(n, 0, "Finished");
      tableSink.add(tableOfdata);
      fibonacci = n;
      fibonacciSink.add(fibonacci);
    }
    // Active loading
    isDoneCalculating = false;
    stateSink.add(isDoneCalculating);
    // Compute fibonacci
    compute(loopFunction, n).then((value) => {
          // Set fibonacci value
          fibonacci = value,
          // Set table reference
          setTable(n, fibonacci, "Finished"),
          tableSink.add(tableOfdata),
          // Stop loading
          isDoneCalculating = true,
          stateSink.add(isDoneCalculating),
          // Display fibonacci value
          fibonacciSink.add(fibonacci)
        });
  }

  _mapingEvents(FibonacciEvent event) async {
    if (event is FibonacciIncrementPressed) {
      counter++;
    }
    // Display counter value
    counterSink.add(counter);
    // Initiate fibonacci function
    fibOptimized(counter);
  }

  void dispose() {
    _counterStreamController.close();
    _stateStreamController.close();
    _fibonacciStreamController.close();
    _eventStreamController.close();
  }
}

int loopFunction(n) {
  var data = [0, 1];
  for (var i = 2; i < n + 1; i++) {
    data.add(data[i - 1] + data[i - 2]);
  }
  return data[data.length - 1];
}
