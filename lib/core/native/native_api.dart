import 'package:flutter/services.dart';

class DemoPlatformChannel {
  final MethodChannel channel;

  const DemoPlatformChannel(this.channel);

  Future<Map<Object?, Object?>> getSystemInformation() async {
    final result =
        await channel.invokeMethod('getSystemInformation')
            as Map<Object?, Object?>;
    // final result = {
    //   "batteryLevel": 88, // int
    //   "deviceModel": "Pixel 6", // string
    //   "isCharging": true, // bool
    //   "systemTime": "2025-06-09T12:30:00Z", // string (ISO format)
    // };
    return result;
  }
}
