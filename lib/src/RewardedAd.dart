import 'package:flutter/services.dart';

import '../freestar_flutter_plugin.dart';

class RewardedAd {
  bool isLoaded = false;
  static const MethodChannel _channel = const MethodChannel('freestar_flutter_plugin/RewardedAd');

  RewardedAd.from(this.placement, this.rewardedAdListener) {
    _channel.setMethodCallHandler(adsCallbackHandler);
    print("fsfp_tag: RewardedAd.from() constructed from helper.");
  }

  RewardedAd() {
    _channel.setMethodCallHandler(adsCallbackHandler);
    print("fsfp_tag: RewardedAd() default constructor.");
  }

  Map? targetingParams; //optional
  String? placement; //optional
  RewardedAdListener? rewardedAdListener;

  void loadAd() {
    Map params = FreestarUtils.paramsFrom(placement, targetingParams);
    _channel.invokeMethod('loadRewardedAd', params);
  }

  /// Call this method to show the Reward Ad.
  ///
  /// @param secret       Secret key for getting server-to-server callback.
  /// @param userId       User id of the app user. Empty string will also suffice.
  /// @param rewardName   Reward name like coin, life, weapon.
  /// @param rewardAmount Reward amount like 100.
  void showAd(String secret, String userId, String rewardName, String rewardAmount) {
    if (isLoaded) {
      Map params = Map();
      params["secret"] = secret;
      params["userId"] = userId;
      params["rewardName"] = rewardName;
      params["rewardAmount"] = rewardAmount;
      _channel.invokeMethod('showRewardedAd', params);
    } else
      print("Cannot show rewarded ad.  Not loaded.");
  }

  Future<dynamic> adsCallbackHandler(MethodCall methodCall) async {
    print("fsfp_tag: RewardedAd. adsCallbackHandler. " +
         methodCall.method + " args: " + methodCall.arguments);

    if (rewardedAdListener == null) {
      print("RewardedAdListener is null. info: " +
          methodCall.method + " args: " + methodCall.arguments);
    }

    switch (methodCall.method) {
      case "onRewardedVideoShown":
        rewardedAdListener!.onRewardedVideoShown(placement);
        break;
      case "onRewardedVideoLoaded":
        isLoaded = true;
        rewardedAdListener!.onRewardedVideoLoaded(placement);
        break;
      case "onRewardedVideoFailed":
        isLoaded = false;
        rewardedAdListener!.onRewardedVideoFailed(placement, methodCall.arguments);
        break;
      case "onRewardedVideoShownError":
        rewardedAdListener!.onRewardedVideoShownError(placement, methodCall.arguments);
        break;
      case "onRewardedVideoDismissed":
        isLoaded = false;
        rewardedAdListener!.onRewardedVideoDismissed(placement);
        break;
      case "onRewardedVideoCompleted":
        isLoaded = false;
        rewardedAdListener!.onRewardedVideoCompleted(placement);
        break;
      default:
        break;
    }
  }

}
