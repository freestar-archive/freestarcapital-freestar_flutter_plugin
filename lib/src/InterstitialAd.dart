import 'package:flutter/services.dart';

import '../freestar_flutter_plugin.dart';

class InterstitialAd {
  bool isLoaded = false;
  static const MethodChannel _channel = const MethodChannel('freestar_flutter_plugin/InterstitialAd');

  InterstitialAd.from(this.placement, this.interstitialAdListener) {
    _channel.setMethodCallHandler(adsCallbackHandler);
    print("fsfp_tag: InterstitialAd.from() constructed from helper.");
  }

  InterstitialAd() {
    _channel.setMethodCallHandler(adsCallbackHandler);
    print("fsfp_tag: InterstitialAd() default constructor.");
  }

  InterstitialAdListener? interstitialAdListener;
  String? placement; //optional
  Map? targetingParams; //optional

  void loadAd() {
    Map params = FreestarUtils.paramsFrom(placement, targetingParams);
    _channel.invokeMethod('loadInterstitialAd', params);
  }

  void showAd() {
    if (isLoaded)
      _channel.invokeMethod('showInterstitialAd');
    else
      print("Cannot show interstitial ad.  Not loaded.");
  }

  Future<dynamic> adsCallbackHandler(MethodCall methodCall) async {
    print("fsfp_tag: InterstitialAd. adsCallbackHandler. " +
        methodCall.method + " args: " + methodCall.arguments);

    if (interstitialAdListener == null) {
      print("InterstitialAdListener is null. info: " +
          methodCall.method + " args: " + methodCall.arguments);
    }

    switch (methodCall.method) {
      case "onInterstitialShown":
        interstitialAdListener!.onInterstitialShown(placement);
        break;
      case "onInterstitialLoaded":
        isLoaded = true;
        interstitialAdListener!.onInterstitialLoaded(placement);
        break;
      case "onInterstitialFailed":
        isLoaded = false;
        interstitialAdListener!.onInterstitialFailed(placement, methodCall.arguments);
        break;
      case "onInterstitialClicked":
        interstitialAdListener!.onInterstitialClicked(placement);
        break;
      case "onInterstitialDismissed":
        isLoaded = false;
        interstitialAdListener!.onInterstitialDismissed(placement);
        break;
      default:
        break;
    }
  }

}
