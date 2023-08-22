package com.freestar.ads.flutter.freestar_flutter_plugin;

import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class MrecBannerAdFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;

    public MrecBannerAdFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        return new FlutterMrecBannerAd(context, messenger, id);
    }
}