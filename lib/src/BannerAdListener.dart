
class BannerAdListener {

  // Banner has successfully loaded.
  void onBannerAdLoaded(String? placement) {}

  // Banner has failed to retrieve an ad.
  void onBannerAdFailed(String? placement, String errorMessage) {}

  // The user has tapped on the banner.
  void onBannerAdClicked(String? placement) {}

}
