import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freestar_flutter_plugin/freestar_flutter_plugin.dart';

class NativeAd extends StatefulWidget {

  static const int NATIVE_TEMPLATE_SMALL = 0;
  static const int NATIVE_TEMPLATE_MEDIUM = 1;

  NativeAd();

  NativeAd.fromParams(this.placement, this.template, this.nativeAdListener, this.doAutoloadWhenCreated);

  NativeAdListener? nativeAdListener;
  int template = NATIVE_TEMPLATE_SMALL; //default SMALL template
  String? placement;  //optional
  Map? targetingParams; //optional
  bool doAutoloadWhenCreated = false; //if false, loadAd must be explicitly called

  MethodChannel? _channel;

  Future<void> loadAd() async {
    print("fsfp_tag: NativeAd.dart. loadAd.");
    _channel!.setMethodCallHandler(adsCallbackHandler);
    Map params = FreestarUtils.paramsFrom(placement, targetingParams);
    params["template"] = template;
    await _channel!.invokeMethod('loadNativeAd', params);
  }

  Future<dynamic> adsCallbackHandler(MethodCall methodCall) async {
    print("fsfp_tag: NativeAd.dart. adsCallbackHandler. methodCall: " +
        methodCall.method +
        "] args: " +
        methodCall.arguments);

    if (NativeAdListener == null) {
      print("fsfp_tag: NativeAd.dart. Listener is null. info: " +
          methodCall.method +
          " args: " +
          methodCall.arguments);
    }

    switch (methodCall.method) {
      case "onNativeAdLoaded":
        nativeAdListener!.onNativeAdLoaded(placement);
        break;
      case "onNativeAdClicked":
        nativeAdListener!.onNativeAdClicked(placement);
        break;
      case "onNativeAdFailed":
        nativeAdListener!.onNativeAdFailed(placement, methodCall.arguments);
        break;
      default:
        break;
    }
  }

  @override
  State<StatefulWidget> createState() => _NativeAdViewState();
}

class _NativeAdViewState extends State<NativeAd> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    print("fsfp_tag: NativeAd.dart. initState");
  }

  @override
  void dispose() {
    // remove the observer
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
    print("fsfp_tag: NativeAd.dart. dispose");

    widget._channel!.setMethodCallHandler(null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
      // widget is resumed
        print("fsfp_tag: NativeAd.dart. AppLifecycleState.resumed");
        widget._channel!.invokeMethod('resumed');
        break;
      case AppLifecycleState.inactive:
      // widget is inactive
        print("fsfp_tag: NativeAd.dart. AppLifecycleState.inactive");
        break;
      case AppLifecycleState.paused:
      // widget is paused
        print("fsfp_tag: NativeAd.dart. AppLifecycleState.paused");
        widget._channel!.invokeMethod('paused');
        break;
      case AppLifecycleState.detached:
      // widget is detached
        print("fsfp_tag: NativeAd.dart. AppLifecycleState.detached");
        widget._channel!.invokeMethod('detached');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.freestar.ads/NativeAd',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'plugins.freestar.ads/NativeAd',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the Freestar Flutter Plugin');
  }

  void _onPlatformViewCreated(int id) {
    print("fsfp_tag: NativeAd.dart. _onPlatformViewCreated: " + id.toString());
    widget._channel = new MethodChannel('plugins.freestar.ads/NativeAd_$id');
    if (widget.doAutoloadWhenCreated) {
      widget.loadAd();
    }
    // add the observer
    WidgetsBinding.instance!.addObserver(this);
  }
}
