import 'package:flutter/services.dart';

class MediaScanner {
  static const MethodChannel _channel = MethodChannel('media_scanner');

  static Future<void> scanFile(String filePath) async {
    await _channel.invokeMethod('scanMedia', {'path': filePath});
  }
}
