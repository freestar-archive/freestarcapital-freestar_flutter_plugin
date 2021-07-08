import Flutter
import UIKit

import FreestarAds

public class SwiftFreestarFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "freestar_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFreestarFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "init" {
        guard let apiKey = firstArg(call) else {
            print("No API Key Passed to init")
            return
        }
        Freestar.initWithAdUnitID(apiKey)
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
}
