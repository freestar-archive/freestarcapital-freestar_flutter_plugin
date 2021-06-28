class RewardedAdListener {

  // The rewarded ad has been loaded and is ready to be shown.
  void onRewardedVideoLoaded(String? placement) {}

  // The rewarded ad failed to load.
  void onRewardedVideoFailed(String? placement, String errorMessage) {}

  // The rewarded ad has shown on the screen.
  void onRewardedVideoShown(String? placement) {}

  // The rewarded ad encountered an error when it was about to show on screen.
  void onRewardedVideoShownError(String? placement, String errorMessage) {}

  // The rewarded ad was dismissed.
  void onRewardedVideoDismissed(String? placement) {}

  // The rewarded ad has completed and the user can be rewarded.
  void onRewardedVideoCompleted(String? placement) {}
}
