import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityService {
  final _controller = StreamController<ConnectivityStatus>.broadcast();
  Stream<ConnectivityStatus> get statusStream => _controller.stream;

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // connectivity_plus 6.0.0+ returns a list. 
      // If any of them is not 'none', we are online.
      final hasConnection = results.any((result) => result != ConnectivityResult.none);
      _controller.add(hasConnection ? ConnectivityStatus.online : ConnectivityStatus.offline);
    });
  }

  Future<bool> get isConnected async {
    final results = await Connectivity().checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  void dispose() {
    _controller.close();
  }
}
