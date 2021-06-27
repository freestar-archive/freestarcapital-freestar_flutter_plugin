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
    print("fsfp_tag: NativeAd.dart. loadAd.");
    _channel!.setMethodCallHandler(adsCallbackHandler);
    String args = _placement(placement) + "|" + template.toString();
    await _channel!.invokeMethod('loadNativeAd', args);
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
        nativeAdListener!.onNativeAdLoaded(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onNativeAdClicked":
        nativeAdListener!.onNativeAdClicked(FreestarUtils.placement(methodCall.arguments));
        break;
      case "onNativeAdFailed":
        nativeAdListener!.onNativeAdFailed(FreestarUtils.placementFromError(methodCall.arguments),
            FreestarUtils.errorMessageFromError(methodCall.arguments));
        break;
      default:
        break;
    }
  }

  @override
  State<StatefulWidget> createState() => _NativeAdViewState();
}

class _NativeAdViewState extends State<NativeAd> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.freestar.ads/NativeAd',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    print("fsfp_tag: qqqqq NativeAd.dart. _onPlatformViewCreated: " + id.toString());
    widget._channel = new MethodChannel('plugins.freestar.ads/NativeAd_$id');
    if (widget.doAutoloadWhenCreated) {
      widget.loadAd();
    }
  }
}
