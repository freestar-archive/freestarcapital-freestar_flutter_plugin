import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freestar_flutter_plugin/freestar_flutter_plugin.dart';

class BannerAd extends StatefulWidget {

  static const int AD_SIZE_BANNER_320x50 = 0;
  static const int AD_SIZE_MREC_300x250 = 1;
  static const int AD_SIZE_LEADERBOARD_728x90 = 2;

  BannerAd();

  BannerAd.from(this.placement, this.adSize, this.bannerAdListener, this.doAutoloadWhenCreated);

  BannerAdListener? bannerAdListener;
  int adSize = AD_SIZE_BANNER_320x50; //default small banner
  String? placement;  //optional
  bool doAutoloadWhenCreated = false; //if false, loadAd must be explicitly called

  MethodChannel? _channel;

  bool isCreated() {
    return _channel != null;
  }

  String _placement(String? placement) {
    if (placement == null || placement.trim().isEmpty) {
      return " ";
    } else {
      return placement;
    }
  }

  Future<void> loadAd() async {
    print("fsfp_tag: BannerAd.dart. loadAd.");
    _channel!.setMethodCallHandler(adsCallbackHandler);
    String args = _placement(placement) + "|" + adSize.toString();
    await _channel!.invokeMethod('loadBannerAd', args);
  }

  Future<dynamic> adsCallbackHandler(MethodCall methodCall) async {
    print("fsfp_tag: BannerAd.dart. adsCallbackHandler. methodCall: " +
        methodCall.method +
        "] args: " +
        methodCall.arguments);

    if (bannerAdListener == null) {
      print("fsfp_tag: BannerAd.dart. Listener is null. info: " +
          methodCall.method +
          " args: " +
          methodCall.arguments);
    }

    switch (methodCall.method) {
      case "onBannerAdLoaded":
        bannerAdListener!.onBannerAdLoaded(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onBannerAdClicked":
        bannerAdListener!.onBannerAdClicked(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onBannerAdFailed":
        bannerAdListener!.onBannerAdFailed(FreestarUtils.placementFromError(methodCall.arguments),
            FreestarUtils.errorMessageFromError(methodCall.arguments));
        break;
      default:
        break;
    }
  }

  @override
  State<StatefulWidget> createState() => _BannerAdViewState();
}

class _BannerAdViewState extends State<BannerAd> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.freestar.ads/BannerAd',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    print("fsfp_tag: qqqqq BannerAd.dart. _onPlatformViewCreated: " + id.toString());
    widget._channel = new MethodChannel('plugins.freestar.ads/BannerAd_$id');
    if (widget.doAutoloadWhenCreated) {
      widget.loadAd();
    }
  }
}
