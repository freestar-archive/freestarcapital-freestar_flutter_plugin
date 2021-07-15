import Flutter
import UIKit

import FreestarAds

public class SwiftFreestarFlutterPlugin: NSObject, FlutterPlugin {
    static var partnerChoosingEnabled = false

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "freestar_flutter_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftFreestarFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    @objc public static func partnerChoosing() -> Bool {
        return partnerChoosingEnabled
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "init" {
            guard let apiKey = firstArg(call) else {
                print("No API Key Passed to init")
                return
            }
            Freestar.initWithAdUnitID(apiKey)
        } else if call.method == "enablePartnerChooser" {
            guard let pc = firstArgBool(call) else { return }
            SwiftFreestarFlutterPlugin.partnerChoosingEnabled = pc
        } else if call.method == "enableLogging" {
            print("WARN: Freestar: To enable detailed logging on iOS, set the CHP_LOGGING_ENABLE flag in your app's Info.plist file to the string 'true'.")
        } else if call.method == "enableTestMode" {
            print("WARN: Freestar: To enable test mode on iOS, set the CHP_TEST_ADS flag in your app's Info.plist file to the string 'enable'.")
        }

        result("iOS " + UIDevice.current.systemVersion)
    }
    
    
    private func firstArg(_ call: FlutterMethodCall) -> String? {
        guard let args = call.arguments else { return nil }
        if let fa = args as? String {
            return fa
        }
        
        return nil
    }
    
    private func firstArgBool(_ call: FlutterMethodCall) -> Bool? {
        guard let args = call.arguments else { return nil }
        if let fa = args as? Bool {
            return fa
        }
        
        return nil
    }
}

