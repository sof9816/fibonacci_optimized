import 'package:fibonacci_optimized/fibonacci_bloc.dart';
import 'package:fibonacci_optimized/fibonacci_event.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
  final ScrollController _scrollController = new ScrollController();
  final textStyle = const TextStyle(fontSize: 20, color: Colors.black);
  final textStyle1 = const TextStyle(fontSize: 20, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          SizedBox(
            width: 30,
            height: 30,
            child: StreamBuilder(
              stream: fibonacciBloc.stateStream,
              initialData: true,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return Visibility(
                  visible:
                      !(snapshot.data ?? false), //calling when data changes
                  child: const LoadingIndicator(
                    indicatorType: Indicator.lineSpinFadeLoader,
                    strokeWidth: 2,
                    colors: [Colors.white],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            flex: 1,
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
          Expanded(
            flex: 7,
            child: StreamBuilder(
                stream: fibonacciBloc.tableStream,
                initialData: {},
                builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                  var map = snapshot.data ?? {};

                  if (map.isNotEmpty) {
                    var isScrolling =
                        _scrollController.position.isScrollingNotifier.value;
                    if (!isScrolling) {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut);
                    }
                  }
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: map.keys.length,
                      itemBuilder: (context, index) {
                        final item = map[index + 1];
                        final status =
                            item.toString().split("{")[1].split(":")[0];
                        final fib =
                            item.toString().split(": ")[1].split("}")[0];
                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Text(
                                "${index + 1}: ",
                                style: textStyle,
                              ),
                              Text(
                                fib,
                                style: textStyle,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: status == "Running"
                                      ? Colors.yellow[700]
                                      : Colors.green[500],
                                ),
                                child: Text(
                                  status,
                                  style: textStyle1,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fibonacciBloc.eventSink.add(FibonacciIncrementPressed());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
