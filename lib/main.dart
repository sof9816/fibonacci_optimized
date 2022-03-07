import 'package:fibonacci_optimized/fibonacci_bloc.dart';
import 'package:fibonacci_optimized/fibonacci_event.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fibonacci Optimized',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Fibonacci Optimized'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final fibonacciBloc = FibonacciBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder(
                  stream: fibonacciBloc.counterStream,
                  initialData: 0,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return Text(
                      'Calculatin Fibonacci for: ${snapshot.data}',
                      style: Theme.of(context).textTheme.headline6,
                    );
                  },
                ),
                StreamBuilder(
                  stream: fibonacciBloc.fibonacciStream,
                  initialData: 0,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return Text(
                      '${snapshot.data}',
                      style: Theme.of(context).textTheme.headline5,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fibonacciBloc.eventSink.add(FibonacciIncrementPressed());
          // fibonacciBloc.eventSink.add(FibonacciEvent.fibonacciDecrementPressed);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
