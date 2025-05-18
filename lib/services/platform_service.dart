import 'package:flutter/services.dart';

class PlatformService {
  static const platform = MethodChannel('app_nation_dog/platform');

  static Future<String> getOSVersion() async {
    try {
      final String version = await platform.invokeMethod('getOSVersion');
      return version;
    } on PlatformException catch (e) {
      print('Failed to get OS version: ${e.message}');
      return 'Unknown';
    }
  }
} 