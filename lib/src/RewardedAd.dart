import 'package:flutter/services.dart';

import '../freestar_flutter_plugin.dart';

class RewardedAd {
  bool isLoaded = false;
  static const MethodChannel _channel = const MethodChannel('freestar_flutter_plugin');

  RewardedAd() {
    _channel.setMethodCallHandler(adsCallbackHandler);
  }

  RewardedAdListener? _listener;

  void setRewardedAdListener(RewardedAdListener? listener) {
    this._listener = listener;
  }

  void loadAd(String? placement) {
    _channel.invokeMethod('loadRewardedAd', placement);
  }

  /// Call this method to show the Reward Ad.
  ///
  /// @param secret       Secret key for getting server-to-server callback.
  /// @param userId       User id of the app user. Empty string will also suffice.
  /// @param rewardName   Reward name like coin, life, weapon.
  /// @param rewardAmount Reward amount like 100.
  void showAd(String secret, String userId, String rewardName, String rewardAmount) {
    if (isLoaded)
      _channel.invokeMethod('showRewardedAd', secret+"|"+userId+"|"+rewardName+"|"+rewardAmount);
    else
      print("Cannot show rewarded ad.  Not loaded.");
  }

  Future<dynamic> adsCallbackHandler(MethodCall methodCall) async {
    print("fsfp_tag: RewardedAd. adsCallbackHandler. methodCall: " +
        methodCall.toString() +
        " methodCall.method: [" +
        methodCall.method +
        "] args: " +
        methodCall.arguments);

    if (_listener == null) {
      print("RewardedAdListener is null. info: " +
          methodCall.method +
          " args: " +
          methodCall.arguments);
    }

    switch (methodCall.method) {
      case "onRewardedVideoShown":
        _listener!.onRewardedVideoShown(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onRewardedVideoLoaded":
        isLoaded = true;
        _listener!.onRewardedVideoLoaded(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onRewardedVideoFailed":
        isLoaded = false;
        _listener!.onRewardedVideoFailed(FreestarUtils.placementFromError(methodCall.arguments),
            FreestarUtils.errorMessageFromError(methodCall.arguments));
        break;
      case "onRewardedVideoShownError":
        _listener!.onRewardedVideoShownError(FreestarUtils.placementFromError(methodCall.arguments),
            FreestarUtils.errorMessageFromError(methodCall.arguments));
        break;
      case "onRewardedVideoDismissed":
        isLoaded = false;
        _listener!.onRewardedVideoDismissed(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onRewardedVideoCompleted":
        isLoaded = false;
        _listener!.onRewardedVideoCompleted(FreestarUtils.placement(methodCall.arguments));
        break;
      default:
        break;
    }
  }

}
