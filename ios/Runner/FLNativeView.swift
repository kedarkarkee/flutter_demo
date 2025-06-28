//
//  FLNativeView.swift
//  Runner
//
//  Created by Kedar Karki on 28/06/2025.
//

import Flutter
import UIKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var channel: FlutterMethodChannel?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        if let messenger = messenger {
            channel = FlutterMethodChannel(
                name: "demo",
                binaryMessenger: messenger
            )
        }
        // iOS views can be created here
        createNativeView(view: _view, arguments: args)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView, arguments args: Any?) {
        _view.backgroundColor = UIColor.systemGreen
        let nativeButton = UIButton(type: .system)
        if let argsDict = args as? [String: Any],
            let text = argsDict["text"] as? String
        {
            nativeButton.setTitle(text, for: .normal)
        } else {
            nativeButton.setTitle("Native Button", for: .normal)
        }
        nativeButton.setTitleColor(UIColor.white, for: .normal)
        nativeButton.backgroundColor = UIColor.systemGreen
        nativeButton.layer.cornerRadius = 8.0
        nativeButton.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        nativeButton.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
        _view.addSubview(nativeButton)
        nativeButton.center = CGPoint(
            x: _view.bounds.midX,
            y: _view.bounds.midY
        )
        nativeButton.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin,
            .flexibleBottomMargin,
        ]
    }

    @objc func buttonTapped() {
        channel?.invokeMethod(
            "onNativeButtonClicked",
            arguments: receiveBatteryLevel()
        )
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
}
