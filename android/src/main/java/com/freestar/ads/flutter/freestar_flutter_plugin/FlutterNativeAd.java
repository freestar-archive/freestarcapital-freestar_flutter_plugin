package com.freestar.ads.flutter.freestar_flutter_plugin;

import android.content.Context;
import android.content.DialogInterface;
import android.view.View;

import com.freestar.ads.flutter.freestar_flutter_plugin.FreestarFlutterPlugin;
import com.freestar.android.ads.AdRequest;
import com.freestar.android.ads.ChocolateLogger;
import com.freestar.android.ads.ErrorCodes;
import com.freestar.android.ads.NativeAd;
import com.freestar.android.ads.NativeAdListener;

import java.util.Map;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import static io.flutter.plugin.common.MethodChannel.Result;

public class FlutterNativeAd implements PlatformView, MethodCallHandler, NativeAdListener {

    private static final String TAG = "fsfp_tag: FlutterNativeAd";

    private final NativeAd nativeAd;
    private final AdRequest adRequest;
    private final MethodChannel methodChannel;

    FlutterNativeAd(Context context, BinaryMessenger messenger, int id) {
        ChocolateLogger.i(TAG, "FlutterNativeAd created");
        nativeAd = new NativeAd(context);
        nativeAd.setNativeAdListener(this);
        adRequest = new AdRequest(context);
        methodChannel = new MethodChannel(messenger, "plugins.freestar.ads/NativeAd_" + id);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public View getView() {
        return nativeAd;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, Result result) {

        ChocolateLogger.i(TAG, "onMethodCall. method: " + methodCall.method + " args: " + methodCall.arguments);

        if (nativeAd == null) {
            result.error("Android_NativeAd_NULL", null, null);
            return;
        }

        switch (methodCall.method) {
            case "loadNativeAd":
                Map map = (Map) methodCall.arguments;
                String placement = (String) map.get("placement");
                int template = (Integer) map.get("template");
                Utils.addTargetingParams(adRequest, (Map)map.get("targetingMap"));
                nativeAd.setTemplate(template);
                loadNativeAd(adRequest, placement);
                break;
            case "resumed":
                nativeAd.onResume();
                break;
            case "paused":
                nativeAd.onPause();
                break;
            case "detached":
                nativeAd.destroyView();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void loadNativeAd(final AdRequest adRequest, final String placement) {

        if (FreestarFlutterPlugin.isPartnerChooserEnabled) {
            MediationPartners.choosePartners(FreestarFlutterPlugin.activity.get(), adRequest, MediationPartners.ADTYPE_BANNER, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {
                    ChocolateLogger.i(TAG, "loading...");
                    nativeAd.loadAd(adRequest, placement);
                }
            });
        } else {
            ChocolateLogger.i(TAG, "loading...");
            nativeAd.loadAd(adRequest, placement);
        }
    }

    @Override
    public void dispose() {
        ChocolateLogger.i(TAG, "dispose");
        if (nativeAd != null)
            nativeAd.destroyView();
    }

    @Override
    public void onFlutterViewAttached(@NonNull View flutterView) {
        ChocolateLogger.i(TAG, "onFlutterViewAttached");
    }

    @Override
    public void onFlutterViewDetached() {
        ChocolateLogger.i(TAG, "onFlutterViewDetached");
    }

    @Override
    public void onNativeAdLoaded(View view, String s) {
        methodChannel.invokeMethod("onNativeAdLoaded", "", result);
    }

    @Override
    public void onNativeAdFailed(String s, int i) {
        methodChannel.invokeMethod("onNativeAdFailed", ErrorCodes.getErrorDescription(i), result);
    }

    @Override
    public void onNativeAdClicked(String s) {
        methodChannel.invokeMethod("onNativeAdClicked", "", result);
    }

    private final Result result = new Result() {
        @Override
        public void success(@Nullable Object result) {
            ChocolateLogger.e(TAG, "plugins.freestar.ads/NativeAd success: " + result);
        }

        @Override
        public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
            ChocolateLogger.e(TAG, "plugins.freestar.ads/NativeAd errorCode: " + errorCode +  " errorMessage: " + errorMessage + " errorDetails: " + errorDetails);
        }

        @Override
        public void notImplemented() {
            ChocolateLogger.e(TAG, "plugins.freestar.ads/NativeAd notImplemented");
        }
    };
}