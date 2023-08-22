import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:freestar_flutter_plugin/freestar_flutter_plugin.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    implements InterstitialAdListener, RewardedAdListener, BannerAdListener, NativeAdListener {

  InterstitialAd _interstitialAd = new InterstitialAd();
  RewardedAd _rewardedAd = new RewardedAd();
  BannerAd _bannerAd = BannerAd.from(null, BannerAd.AD_SIZE_BANNER_320x50, null, false);
  MrecBannerAd _mrecBannerAd = MrecBannerAd.from(null, BannerAd.AD_SIZE_MREC_300x250, null, false);
  NativeAd _smallNativeAd = NativeAd.fromParams(null, NativeAd.NATIVE_TEMPLATE_SMALL, null, false);
  NativeAd _mediumNativeAd = NativeAd.fromParams(null, NativeAd.NATIVE_TEMPLATE_MEDIUM, null, false);

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    developer.log('fsfp_tag: before plugin init', name: 'main.dart');
    try {
      FreestarFlutterPlugin.enableLogging(true);
      FreestarFlutterPlugin.enableTestMode(true);
      FreestarFlutterPlugin.enablePartnerChooser(true);
    } on PlatformException {}

    if (defaultTargetPlatform == TargetPlatform.android) {
      FreestarFlutterPlugin.init("XqjhRR"); //android key
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      FreestarFlutterPlugin.init("XqjhRR");  //ios key can be different
    }

  }

  void _loadBannerAd() {
    print("fsfp_tag: BannerAdButton.dart. loadAd.");
    _bannerAd.bannerAdListener = this;
    //_bannerAd.placement = "optional-placement";
    _bannerAd.loadAd();
  }

  void _loadMRECBannerAd() {
    _mrecBannerAd.bannerAdListener = this;
    //_mrecBannerAd.placement = "optional-placement";
    _mrecBannerAd.loadAd();
  }

  void _loadSmallNativeAd() {
    _smallNativeAd.nativeAdListener = this;
    //_smallNativeAd.placement = "optional-placement";
    _smallNativeAd.loadAd();
  }

  void _loadMediumNativeAd() {
    _mediumNativeAd.nativeAdListener = this;
    //_mediumNativeAd.placement = "optional-placement";
    _mediumNativeAd.loadAd();
  }

  void _loadInterstitialAd() {
    _interstitialAd.interstitialAdListener = this;
    //_interstitialAd.placement = "optional-placement";
    _interstitialAd.loadAd();
  }

  void _loadRewardedAd() {
    _rewardedAd.rewardedAdListener = this;
    //_rewardedAd.placement = "optional-placement";
    Map targetingParams = Map();
    targetingParams["my-targeting-param1"] = "example value 1";
    targetingParams["my-targeting-param2"] = "example value 2";
    _rewardedAd.targetingParams = targetingParams; //optional
    _rewardedAd.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //backgroundColor: Color.fromARGB(255, 250, 30, 0),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        onPressed: _loadBannerAd,
                        child: Text('BANNER'),
                      ),
                      TextButton(
                        onPressed: _loadMRECBannerAd,
                        child: Text('MREC'),
                      ),
                      TextButton(
                        onPressed: _loadSmallNativeAd,
                        child: Text('SM-NATIVE'),
                      ),
                      TextButton(
                        onPressed: _loadMediumNativeAd,
                        child: Text('MED-NATIVE'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        onPressed: _loadInterstitialAd,
                        child: Text('INTERSTITIAL'),
                      ),
                      TextButton(
                        onPressed: _loadRewardedAd,
                        child: Text('REWARED'),
                      ),
                    ],
                  ),
                  Text('Banner Ad Below'),
                  Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      width: 320.0,
                      height: 50.0,
                      child: _bannerAd),
                  Text('MREC Banner Ad Below'),
                  Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      width: 300.0,
                      height: 250.0,
                      child: _mrecBannerAd),
                  Text('Small Native Ad Below'),
                  Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      width: window.physicalSize.width,
                      height: 100.0,
                      child: _smallNativeAd),
                  Text('Medium Native Ad Below'),
                  Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      width: window.physicalSize.width,
                      height: 350.0,
                      child: _mediumNativeAd),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _notNull(String? str) {
    if (str == null)
      return "";
    else
      return str;
  }

  @override
  void onInterstitialAdShown(String? placement) {
    print("fsfp_tag: main.dart. onInterstitialAdShown. placement: [" +
        _notNull(placement) +"]");
  }

  @override
  void onInterstitialAdDismissed(String? placement) {
    print("fsfp_tag: main.dart. onInterstitialAdDismissed. placement: [" +
        _notNull(placement) +"]");
  }

  @override
  void onInterstitialAdClicked(String? placement) {
    print("fsfp_tag: main.dart. onInterstitialAdClicked. placement: [" +
        _notNull(placement) +"]");
  }

  @override
  void onInterstitialAdFailed (String? placement, String errorMessage) {
    print("fsfp_tag: main.dart. onInterstitialAdFailed . placement: [" +
        _notNull(placement) +"] error: " + errorMessage);
  }

  @override
  void onInterstitialAdLoaded(String? placement) {
    print("fsfp_tag: main.dart. onInterstitialAdLoaded. placement: [" +
        _notNull(placement) +"]");
    _interstitialAd.showAd();
  }

  @override
  void onRewardedAdCompleted(String? placement) {
    print("fsfp_tag: main.dart. onRewardedAdCompleted. placement: [" +
        _notNull(placement) +"]");
  }

  @override
  void onRewardedAdDismissed(String? placement) {
    print("fsfp_tag: main.dart. onRewardedAdDismissed. placement: [" +
        _notNull(placement) + "]");
  }

  @override
  void onRewardedAdShownError(String? placement, String errorMessage) {
    print("fsfp_tag: main.dart. onRewardedAdShownError. placement: [" +
        _notNull(placement) +"]");
  }

  @override
  void onRewardedAdShown(String? placement) {
    print("fsfp_tag: main.dart. onRewardedAdShown. placement: [" +
        _notNull(placement) +"]");
  }

  @override
  void onRewardedAdFailed(String? placement, String errorMessage) {
    print("fsfp_tag: main.dart. onRewardedAdFailed. placement: [" +
        _notNull(placement) +"]  error: " + errorMessage);
  }

  @override
  void onRewardedAdLoaded(String? placement) {
    print("fsfp_tag: main.dart. onRewardedAdLoaded. placement: [" +
        _notNull(placement) + "]");
    _rewardedAd.showAd("secret-12345", "myUserId765", "V-Bucks", "9000");
  }

  @override
  void onBannerAdClicked(String? placement) {
    print("fsfp_tag: main.dart. onBannerAdClicked. placement: [" +
        _notNull(placement) + "]");
  }

  @override
  void onBannerAdFailed(String? placement, String errorMessage) {
    print("fsfp_tag: main.dart. onBannerAdFailed. placement: [" +
        _notNull(placement) + "]  error: " + errorMessage);
  }

  @override
  void onBannerAdLoaded(String? placement) {
    print("fsfp_tag: main.dart. onBannerAdLoaded. placement: [" +
        _notNull(placement) +"]");
  }

  @override
  void onNativeAdClicked(String? placement) {
    print("fsfp_tag: main.dart. onNativeAdClicked. placement: [" +
        _notNull(placement) + "]");
  }

  @override
  void onNativeAdFailed(String? placement, String errorMessage) {
    print("fsfp_tag: main.dart. onNativeAdFailed. placement: [" +
        _notNull(placement) + "]  error: " + errorMessage);
  }

  @override
  void onNativeAdLoaded(String? placement) {
    print("fsfp_tag: main.dart. onNativeAdLoaded. placement: [" +
        _notNull(placement) + "]");
  }

}
