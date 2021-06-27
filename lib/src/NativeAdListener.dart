
class NativeAdListener {

  // NativeAd has successfully loaded.
  void onNativeAdLoaded(String? placement) {}

  // NativeAd has failed to retrieve an ad.
  void onNativeAdFailed(String? placement, String errorMessage) {}

  // The user has tapped on the ad.
  void onNativeAdClicked(String? placement) {}

}
