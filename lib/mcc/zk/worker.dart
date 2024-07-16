import 'dart:isolate';
import 'dart:async';

class Worker {
  final Duration interval;
  Isolate? _isolate;
  ReceivePort? _receivePort;

  Worker(this.interval);

  Future<void> start() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_workerEntry, [_receivePort!.sendPort, interval]);

    _receivePort!.listen((message) {
      print('Worker says: $message');
    });
  }

  static void _workerEntry(List<dynamic> args) {
    SendPort sendPort = args[0];
    Duration interval = args[1];

    while (true){
      Timer.periodic(interval, (Timer timer) {
        sendPort.send('hello');
      });
    }
  }

  void stop() {
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort = null;
  }
}

void main() async {
  final worker = Worker(const Duration(seconds: 10)); // Task interval of 1000 milliseconds (1 second)

  await worker.start();

  // Let the worker run for 10 seconds before stopping it
  await Future.delayed(const Duration(seconds: 10));
  worker.stop();

  print('Worker stopped');
}