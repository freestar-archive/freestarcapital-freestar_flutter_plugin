class InterstitialAdListener {

  // The interstitial ad has been loaded and is ready to be shown.
  void onInterstitialLoaded(String? placement) {}

  // The interstitial ad has failed to load.
  void onInterstitialFailed(String? placement, String errorMessage) {}

  // The interstitial ad has been shown.
  void onInterstitialShown(String? placement) {}

  // The interstitial ad has been clicked.  May not be supported by all mediation partners.
  void onInterstitialClicked(String? placement) {}

  // The interstitial ad has being dismissed.
  void onInterstitialDismissed(String? placement) {}

}