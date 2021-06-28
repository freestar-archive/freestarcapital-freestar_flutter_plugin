class InterstitialAdListener {

  // The interstitial ad has been loaded and is ready to be shown.
  void onInterstitialAdLoaded(String? placement) {}

  // The interstitial ad has failed to load.
  void onInterstitialAdFailed (String? placement, String errorMessage) {}

  // The interstitial ad has been shown.
  void onInterstitialAdShown(String? placement) {}

  // The interstitial ad has been clicked.  May not be supported by all mediation partners.
  void onInterstitialAdClicked(String? placement) {}

  // The interstitial ad has being dismissed.
  void onInterstitialAdDismissed(String? placement) {}

}