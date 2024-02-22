import 'dart:async';

import 'package:flutter/services.dart';

class NetworkInfo {
  static const MethodChannel _channel = MethodChannel('network_info');

  static Future<String?> get getDefaultGateway async {
    try {
      return await _channel.invokeMethod('getDefaultGateway');
    } catch (e) {
      print('Error getting default gateway: $e');
      return null;
    }
  }
}
