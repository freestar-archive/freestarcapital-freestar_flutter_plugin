import 'package:flutter/services.dart';

import '../freestar_flutter_plugin.dart';

class RewardedAd {
  bool isLoaded = false;
  static const MethodChannel _channel = const MethodChannel('freestar_flutter_plugin');

  RewardedAd.from(this.placement, this.rewardedAdListener) {
    _channel.setMethodCallHandler(adsCallbackHandler);
  }

  RewardedAd() {
    _channel.setMethodCallHandler(adsCallbackHandler);
  }

  String? placement;
  RewardedAdListener? rewardedAdListener;

  void loadAd() {
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

    if (rewardedAdListener == null) {
      print("RewardedAdListener is null. info: " +
          methodCall.method +
          " args: " +
          methodCall.arguments);
    }

    switch (methodCall.method) {
      case "onRewardedVideoShown":
        rewardedAdListener!.onRewardedVideoShown(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onRewardedVideoLoaded":
        isLoaded = true;
        rewardedAdListener!.onRewardedVideoLoaded(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onRewardedVideoFailed":
        isLoaded = false;
        rewardedAdListener!.onRewardedVideoFailed(FreestarUtils.placementFromError(methodCall.arguments),
            FreestarUtils.errorMessageFromError(methodCall.arguments));
        break;
      case "onRewardedVideoShownError":
        rewardedAdListener!.onRewardedVideoShownError(FreestarUtils.placementFromError(methodCall.arguments),
            FreestarUtils.errorMessageFromError(methodCall.arguments));
        break;
      case "onRewardedVideoDismissed":
        isLoaded = false;
        rewardedAdListener!.onRewardedVideoDismissed(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onRewardedVideoCompleted":
        isLoaded = false;
        rewardedAdListener!.onRewardedVideoCompleted(FreestarUtils.placement(methodCall.arguments));
        break;
      default:
        break;
    }
  }

}
