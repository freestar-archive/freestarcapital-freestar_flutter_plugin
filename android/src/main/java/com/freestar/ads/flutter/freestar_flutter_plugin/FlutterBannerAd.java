package com.freestar.ads.flutter.freestar_flutter_plugin;

import android.content.Context;
import android.content.DialogInterface;
import android.view.View;

import com.freestar.android.ads.AdRequest;
import com.freestar.android.ads.AdSize;
import com.freestar.android.ads.BannerAd;
import com.freestar.android.ads.BannerAdListener;
import com.freestar.android.ads.ChocolateLogger;
import com.freestar.android.ads.ErrorCodes;

import java.util.Map;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import static io.flutter.plugin.common.MethodChannel.Result;

public class FlutterBannerAd implements PlatformView, MethodCallHandler, BannerAdListener {

    private static final String TAG = "fsfp_tag: FlutterBannerAd";

    private final BannerAd bannerAd;
    private final AdRequest adRequest;
    private final MethodChannel methodChannel;

    FlutterBannerAd(Context context, BinaryMessenger messenger, int id) {
        ChocolateLogger.i(TAG,"FlutterBannerAd created");
        bannerAd = new BannerAd(context);
        bannerAd.setBannerAdListener(this);
        adRequest = new AdRequest(context);
        methodChannel = new MethodChannel(messenger, "plugins.freestar.ads/BannerAd_" + id);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public View getView() {
        return bannerAd;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, Result result) {

        ChocolateLogger.i(TAG,"onMethodCall. method: " + methodCall.method + " args: " + methodCall.arguments);

        if (bannerAd == null) {
            result.error("Android_BannerAd_NULL",null,null);
            return;
        }

        switch (methodCall.method) {
            case "loadBannerAd":
                Map map = (Map)methodCall.arguments;
                String placement = (String)map.get("placement");
                int adSize = (Integer)map.get("adSize");
                Utils.addTargetingParams(adRequest, (Map)map.get("targetingMap"));
                bannerAd.setAdSize(from(adSize));
                loadBannerAd(adRequest, placement);
                break;
            case "resumed":
                bannerAd.onResume();
                break;
            case "paused":
                bannerAd.onPause();
                break;
            case "detached":
                bannerAd.destroyView();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void loadBannerAd(final AdRequest adRequest, final String placement) {

        if (FreestarFlutterPlugin.isPartnerChooserEnabled) {
            MediationPartners.choosePartners(FreestarFlutterPlugin.activity.get(), adRequest, MediationPartners.ADTYPE_BANNER, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {
                    ChocolateLogger.i(TAG,"loading...");
                    bannerAd.loadAd(adRequest, placement);
                }
            });
        } else {
            ChocolateLogger.i(TAG,"loading...");
            bannerAd.loadAd(adRequest, placement);
        }
    }

    private AdSize from(int adSize) {
        switch (adSize) {
            case 0:
                return AdSize.BANNER_320_50;
            case 1:
                return AdSize.MEDIUM_RECTANGLE_300_250;
            case 2:
                return AdSize.LEADERBOARD_728_90;
            default:
                break;
        }
        return AdSize.BANNER_320_50;

    }

    @Override
    public void dispose() {
        ChocolateLogger.i(TAG, "dispose");
        if (bannerAd != null)
            bannerAd.destroyView();
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
    public void onBannerAdLoaded(View view, String s) {
        methodChannel.invokeMethod("onBannerAdLoaded", "", result);
    }

    @Override
    public void onBannerAdFailed(View view, String s, int i) {
        methodChannel.invokeMethod("onBannerAdFailed", ErrorCodes.getErrorDescription(i), result);
    }

    @Override
    public void onBannerAdClicked(View view, String s) {
        methodChannel.invokeMethod("onBannerAdClicked", "", result);
    }

    @Override
    public void onBannerAdClosed(View view, String s) {
        ChocolateLogger.e(TAG, "onBannerAdClosed. ignored in Flutter. " + s);
    }

    private final Result result = new Result() {
        @Override
        public void success(@Nullable Object result) {
            ChocolateLogger.i(TAG, "plugins.freestar.ads/BannerAd success: " + result);
        }

        @Override
        public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
            ChocolateLogger.e(TAG, "plugins.freestar.ads/BannerAd errorCode: " + errorCode +  " errorMessage: " + errorMessage + " errorDetails: " + errorDetails);
        }

        @Override
        public void notImplemented() {
            ChocolateLogger.e(TAG, "plugins.freestar.ads/BannerAd notImplemented");
        }
    };
}