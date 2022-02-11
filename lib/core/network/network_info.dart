import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    late ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } on PlatformException catch (_) {
      return Future.value(false);
    }
  }
}
