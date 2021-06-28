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
      case "onRewardedAdShown":
        rewardedAdListener!.onRewardedAdShown(placement);
        break;
      case "onRewardedAdLoaded":
        isLoaded = true;
        rewardedAdListener!.onRewardedAdLoaded(placement);
        break;
      case "onRewardedAdFailed":
        isLoaded = false;
        rewardedAdListener!.onRewardedAdFailed(placement, methodCall.arguments);
        break;
      case "onRewardedAdShownError":
        rewardedAdListener!.onRewardedAdShownError(placement, methodCall.arguments);
        break;
      case "onRewardedAdDismissed":
        isLoaded = false;
        rewardedAdListener!.onRewardedAdDismissed(placement);
        break;
      case "onRewardedAdCompleted":
        isLoaded = false;
        rewardedAdListener!.onRewardedAdCompleted(placement);
        break;
      default:
        break;
    }
  }

}
