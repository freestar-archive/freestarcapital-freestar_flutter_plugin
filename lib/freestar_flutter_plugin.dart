import 'package:flutter/services.dart';

export 'src/BannerAd.dart';
export 'src/MrecBannerAd.dart';
export 'src/BannerAdListener.dart';
export 'src/FreestarUtils.dart';
export 'src/InterstitialAd.dart';
export 'src/InterstitialAdListener.dart';
export 'src/NativeAd.dart';
export 'src/NativeAdListener.dart';
export 'src/RewardedAd.dart';
export 'src/RewardedAdListener.dart';

class FreestarFlutterPlugin {
  static const MethodChannel _channel = const MethodChannel('freestar_flutter_plugin');

  static void enableTestMode(bool enable) async {
    await _channel.invokeMethod('enableTestMode', enable);
  }

  static void enableLogging(bool enable) async {
    await _channel.invokeMethod('enableLogging', enable);
  }

  static void enablePartnerChooser(bool enable) async {
    await _channel.invokeMethod('enablePartnerChooser', enable);
  }

  static void init(String key) async {
    await _channel.invokeMethod('init', key);
  }

}
