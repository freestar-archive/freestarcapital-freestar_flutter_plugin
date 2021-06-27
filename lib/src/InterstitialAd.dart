import 'package:flutter/services.dart';

import '../freestar_flutter_plugin.dart';

class InterstitialAd {
  bool isLoaded = false;
  static const MethodChannel _channel = const MethodChannel('freestar_flutter_plugin');

  InterstitialAd.from(this.placement, this.interstitialAdListener) {
    _channel.setMethodCallHandler(adsCallbackHandler);
  }

  InterstitialAd() {
    _channel.setMethodCallHandler(adsCallbackHandler);
  }

  InterstitialAdListener? interstitialAdListener;
  String? placement;

  void loadAd() {
    _channel.invokeMethod('loadInterstitialAd', placement);
  }

  void showAd() {
    if (isLoaded)
      _channel.invokeMethod('showInterstitialAd');
    else
      print("Cannot show interstitial ad.  Not loaded.");
  }

  Future<dynamic> adsCallbackHandler(MethodCall methodCall) async {
    print("fsfp_tag: InterstitialAd. adsCallbackHandler. methodCall: " +
        methodCall.toString() +
        " methodCall.method: [" +
        methodCall.method +
        "] args: " +
        methodCall.arguments);

    if (interstitialAdListener == null) {
      print("InterstitialAdListener is null. info: " +
          methodCall.method +
          " args: " +
          methodCall.arguments);
    }

    switch (methodCall.method) {
      case "onInterstitialShown":
        interstitialAdListener!.onInterstitialShown(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onInterstitialLoaded":
        isLoaded = true;
        interstitialAdListener!.onInterstitialLoaded(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onInterstitialFailed":
        isLoaded = false;
        interstitialAdListener!.onInterstitialFailed(FreestarUtils.placementFromError(methodCall.arguments),
            FreestarUtils.errorMessageFromError(methodCall.arguments));
        break;
      case "onInterstitialClicked":
        interstitialAdListener!.onInterstitialClicked(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onInterstitialDismissed":
        isLoaded = false;
        interstitialAdListener!.onInterstitialDismissed(FreestarUtils.placement(methodCall.arguments));
        break;
      default:
        break;
    }
  }

}
