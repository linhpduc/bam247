import 'dart:async';
import 'dart:io';

class Networkk {
  static Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('checkin.base.vn');
      var res = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      return res;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<bool> tcpPortScan(String host, int port) async {
    int connectionTimeout = 1;
    Socket? connection;
    print("$host:$port");
    try {
      connection = await Socket.connect(host, port,
          timeout: Duration(seconds: connectionTimeout));
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      if (connection != null) {
        connection.destroy();
      }
    }
  }
}

abstract class NetworkEvent {}

class ConnectingNetworkEvent implements NetworkEvent {}

class ConnectedNetworkEvent implements NetworkEvent {}

class DisconnectedNetworkEvent implements NetworkEvent {}

class NetworkState {
  final String? currentStatus;
  const NetworkState({this.currentStatus});

  factory NetworkState.initial() => const NetworkState(currentStatus: "disconnected");
}

class NetworkBloc {
  NetworkState _currentState = NetworkState.initial();

  final _eventController = StreamController<NetworkEvent>();
  Sink<NetworkEvent> get eventSink => _eventController.sink;

  final _stateController = StreamController<NetworkState>();
  StreamSink<NetworkState> get _stateSink => _stateController.sink;
  Stream<NetworkState> get currentStatus => _stateController.stream;

  NetworkBloc() {
    _eventController.stream.listen(
      (event) {
        _mapEventToState(event);
      },
    );
  }

  void _mapEventToState(NetworkEvent event) {
    if (event is ConnectedNetworkEvent) {
      _currentState = const NetworkState(currentStatus: 'connected');
    } else if (event is ConnectingNetworkEvent) {
      _currentState = const NetworkState(currentStatus: 'connecting');
    } else {
      _currentState = const NetworkState(currentStatus: 'disconnected');
    }
    _stateSink.add(_currentState);
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
