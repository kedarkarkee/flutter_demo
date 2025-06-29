import 'package:flutter/services.dart';

class DemoPlatformChannel {
  final MethodChannel channel;

  const DemoPlatformChannel(this.channel);

  Future<Map<Object?, Object?>> getSystemInformation() async {
    final result =
        await channel.invokeMethod('getSystemInformation')
            as Map<Object?, Object?>;
    return result;
  }
}
