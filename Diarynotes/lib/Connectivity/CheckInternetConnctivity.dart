import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static ConnectivityResult _connectionStatus = ConnectivityResult.none;
  static StreamController<ConnectivityResult> _connectionStatusController = StreamController<ConnectivityResult>.broadcast();

  static Future<void> init() async {
    _connectionStatus = await _connectivity.checkConnectivity();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result;
    });
  }


  static Future<bool> isInternetAvailable() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    // print("connectivityResult is $connectivityResult");
    return connectivityResult != ConnectivityResult.none;
  }

}

class ConnectivityServicetwo {
  static final Connectivity _connectivity = Connectivity();
  static ConnectivityResult _connectionStatus = ConnectivityResult.none;
  static StreamController<ConnectivityResult> _connectionStatusController = StreamController<ConnectivityResult>.broadcast();

  static Future<void> init() async {
    _connectionStatus = await _connectivity.checkConnectivity();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result;
    });
  }


  static Stream<bool> isInternetAvailable() async* {
    var connectivityResult = await _connectivity.checkConnectivity();
    yield connectivityResult != ConnectivityResult.none;
  }

  static Stream<ConnectivityResult> get connectionStatusStream =>
      _connectionStatusController.stream;
}
