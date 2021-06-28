class RewardedAdListener {

  // The rewarded ad has been loaded and is ready to be shown.
  void onRewardedAdLoaded(String? placement) {}

  // The rewarded ad failed to load.
  void onRewardedAdFailed(String? placement, String errorMessage) {}

  // The rewarded ad has shown on the screen.
  void onRewardedAdShown(String? placement) {}

  // The rewarded ad encountered an error when it was about to show on screen.
  void onRewardedAdShownError(String? placement, String errorMessage) {}

  // The rewarded ad was dismissed.
  void onRewardedAdDismissed(String? placement) {}

  // The rewarded ad has completed and the user can be rewarded.
  void onRewardedAdCompleted(String? placement) {}
}
