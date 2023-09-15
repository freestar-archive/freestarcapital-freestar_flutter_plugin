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

  late final String? placement;  //optional
  Map? targetingParams; //optional
  BannerAdListener? bannerAdListener;
  late final int adSize; //AD_SIZE_BANNER_320x50
  late final bool doAutoloadWhenCreated; //if false, loadAd must be explicitly called

  MethodChannel? _channel;
  MethodChannel? get channel => _channel;

  Future<void> loadAd() async {
    print("fsfp_tag: BannerAd.dart. loadAd.");
    _channel!.setMethodCallHandler(adsCallbackHandler);
    Map params = FreestarUtils.paramsFrom(placement, targetingParams);
    params["adSize"] = adSize;
    unawaited (_channel!.invokeMethod('loadBannerAd', params));
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
        bannerAdListener!.onBannerAdLoaded(placement);
        break;
      case "onBannerAdClicked":
        bannerAdListener!.onBannerAdClicked(placement);
        break;
      case "onBannerAdFailed":
        bannerAdListener!.onBannerAdFailed(placement, methodCall.arguments);
        break;
      default:
        break;
    }
  }

  @override
  State<StatefulWidget> createState() => _BannerAdViewState();
}

class _BannerAdViewState extends State<BannerAd> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    print("fsfp_tag: BannerAd.dart. initState");
  }

  @override
  void dispose() {
    // remove the observer
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
    print("fsfp_tag: BannerAd.dart. dispose");

    widget._channel!.setMethodCallHandler(null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
      // widget is resumed
        print("fsfp_tag: BannerAd.dart. AppLifecycleState.resumed");
        widget._channel!.invokeMethod('resumed');
        break;
      case AppLifecycleState.inactive:
      // widget is inactive
        print("fsfp_tag: BannerAd.dart. AppLifecycleState.inactive");
        break;
      case AppLifecycleState.paused:
      // widget is paused
        print("fsfp_tag: BannerAd.dart. AppLifecycleState.paused");
        widget._channel!.invokeMethod('paused');
        break;
      case AppLifecycleState.detached:
      // widget is detached
        print("fsfp_tag: BannerAd.dart. AppLifecycleState.detached");
        widget._channel!.invokeMethod('detached');
        break;
      case AppLifecycleState.hidden:
        widget._channel!.invokeMethod('paused');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.freestar.ads/BannerAd',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'plugins.freestar.ads/BannerAd',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the Freestar Flutter Plugin');
  }

  void _onPlatformViewCreated(int id) {
    print("fsfp_tag: BannerAd.dart. _onPlatformViewCreated: " + id.toString());
    widget._channel = new MethodChannel('plugins.freestar.ads/BannerAd_$id');
    if (widget.doAutoloadWhenCreated) {
      widget.loadAd();
    }
    // add the observer
    WidgetsBinding.instance.addObserver(this);
  }
}
