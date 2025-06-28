import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController =
            window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(
            name: "demo",
            binaryMessenger: controller.binaryMessenger
        )
        methodChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void
            in
            // This method is invoked on the UI thread.
            guard call.method == "getSystemInformation" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.getSystemInformation(result: result)
        })
        GeneratedPluginRegistrant.register(with: self)
        guard let pluginRegistrar = self.registrar(forPlugin: "plugin-name")
        else { return false }

        let factory = FLNativeViewFactory(
            messenger: pluginRegistrar.messenger()
        )
        pluginRegistrar.register(
            factory,
            withId: "native_button"
        )
        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }

    private func getSystemInformation(result: FlutterResult) {
        let device = UIDevice.current
        let isCharging = device.batteryState == .charging

        let deviceModel = device.model

        let systemTime = getSystemTime()

        result([
            "batteryLevel": receiveBatteryLevel(),
            "deviceModel": deviceModel,
            "isCharging": isCharging,
            "systemTime": systemTime,
        ])
    }

    private func receiveBatteryLevel() -> Int {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            return -1
        } else {
            return Int(device.batteryLevel * 100)
        }
    }

    private lazy var isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime, .withFractionalSeconds,
        ]
        formatter.timeZone = TimeZone(identifier: "Asia/Kathmandu")
        return formatter
    }()

    private func getSystemTime() -> String {
        let now = Date()
        return isoFormatter.string(from: now)
    }
}
