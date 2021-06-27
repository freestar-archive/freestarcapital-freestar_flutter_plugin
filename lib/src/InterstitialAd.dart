import 'package:flutter/services.dart';

import '../freestar_flutter_plugin.dart';

class InterstitialAd {
  bool isLoaded = false;
  static const MethodChannel _channel = const MethodChannel('freestar_flutter_plugin');

  InterstitialAd() {
    _channel.setMethodCallHandler(adsCallbackHandler);
  }

  InterstitialAdListener? _listener;

  void setInterstitialAdListener(InterstitialAdListener? listener) {
    this._listener = listener;
  }

  void loadAd(String? placement) {
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

    if (_listener == null) {
      print("InterstitialAdListener is null. info: " +
          methodCall.method +
          " args: " +
          methodCall.arguments);
    }

    switch (methodCall.method) {
      case "onInterstitialShown":
        _listener!.onInterstitialShown(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onInterstitialLoaded":
        isLoaded = true;
        _listener!.onInterstitialLoaded(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onInterstitialFailed":
        isLoaded = false;
        _listener!.onInterstitialFailed(FreestarUtils.placementFromError(methodCall.arguments),
            FreestarUtils.errorMessageFromError(methodCall.arguments));
        break;
      case "onInterstitialClicked":
        _listener!.onInterstitialClicked(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onInterstitialDismissed":
        isLoaded = false;
        _listener!.onInterstitialDismissed(FreestarUtils.placement(methodCall.arguments));
        break;
      default:
        break;
    }
  }

}
