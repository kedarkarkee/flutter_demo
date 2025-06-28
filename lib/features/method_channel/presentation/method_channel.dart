import 'package:demo/core/logger/logger.dart';
import 'package:demo/core/native/native_api.dart';
import 'package:demo/features/method_channel/data/entity/system_information.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;

class MethodChannelPage extends StatefulWidget {
  const MethodChannelPage({super.key});

  @override
  State<MethodChannelPage> createState() => _MethodChannelPageState();
}

class _MethodChannelPageState extends State<MethodChannelPage> {
  final platformChannel = const DemoPlatformChannel(MethodChannel('demo'));
  final String viewType = 'native_button';
  final Map<String, dynamic> creationParams = <String, dynamic>{
    'text': 'Refresh',
  };

  SystemInformation? info;

  @override
  void initState() {
    super.initState();
    platformChannel.channel.setMethodCallHandler(_handleNativeMethodCall);
  }

  Future<void> _loadInformation() async {
    final res = await platformChannel.getSystemInformation();
    printGreen(res);
    info = SystemInformation.fromJson(res);
    setState(() {});
  }

  Future<void> _handleNativeMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onNativeButtonClicked':
        final newBatteryLevel = call.arguments as int?;
        info = info?.copyWith(batteryLevel: newBatteryLevel);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Refreshed battery percentage: $newBatteryLevel %'),
          ),
        );
        break;
      default:
        throw PlatformException(code: 'Not Implemented');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Method Channel')),
      body: info == null
          ? Center(
              child: ElevatedButton(
                onPressed: _loadInformation,
                child: Text('Load System Information'),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 16,
                children: [
                  _ItemCard(
                    title: 'Battery Level',
                    trailing: Text('${info!.batteryLevel} %'),
                  ),
                  _ItemCard(
                    title: 'Device Model',
                    trailing: Text(info!.deviceModel),
                  ),
                  _ItemCard(
                    title: 'Charging',
                    trailing: info!.isCharging
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.cancel, color: Colors.red),
                  ),
                  _ItemCard(
                    title: 'System Time',
                    trailing: Text(
                      intl.DateFormat.yMMMEd().add_jms().format(
                        info!.systemTime,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: PlatformViewLink(
                      viewType: viewType,
                      surfaceFactory: (context, controller) {
                        return AndroidViewSurface(
                          controller: controller as AndroidViewController,
                          gestureRecognizers:
                              const <Factory<OneSequenceGestureRecognizer>>{},
                          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                        );
                      },
                      onCreatePlatformView: (params) {
                        return PlatformViewsService.initSurfaceAndroidView(
                            id: params.id,
                            viewType: viewType,
                            layoutDirection: TextDirection.ltr,
                            creationParams: creationParams,
                            creationParamsCodec: const StandardMessageCodec(),
                            onFocus: () {
                              params.onFocusChanged(true);
                            },
                          )
                          ..addOnPlatformViewCreatedListener(
                            params.onPlatformViewCreated,
                          )
                          ..create();
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String title;
  final Widget trailing;

  const _ItemCard({required this.title, required this.trailing});
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
