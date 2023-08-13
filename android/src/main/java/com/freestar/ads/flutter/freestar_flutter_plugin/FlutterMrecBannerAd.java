package com.freestar.ads.flutter.freestar_flutter_plugin;

import android.content.Context;
import android.content.DialogInterface;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.widget.FrameLayout;

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

public class FlutterMrecBannerAd implements PlatformView, MethodCallHandler, BannerAdListener {

    private static final String TAG = "fsfp_tag: FlutterMrecBannerAd";

    private final FrameLayout bannerAdContainer;
    private final BannerAd bannerAd;
    private final AdRequest adRequest;
    private final MethodChannel methodChannel;

    FlutterMrecBannerAd(Context context, BinaryMessenger messenger, int id) {
        ChocolateLogger.i(TAG,"FlutterMrecBannerAd created");
        bannerAdContainer = createBannerAdContainer(context);
        /*
         * If use passed in context for BannerAd (below) instead of
         * activity context, then Unity Ads won't work.
         *
         * Conversely, if use activity context for above, then the
         * ads will appear left aligned.
         */
        bannerAd = new BannerAd(FreestarFlutterPlugin.activity.get());
        bannerAd.setBannerAdListener(this);
        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(-2, -2);
        bannerAd.setLayoutParams(layoutParams);
        bannerAdContainer.addView(bannerAd);
        adRequest = new AdRequest(context);
        methodChannel = new MethodChannel(messenger, "plugins.freestar.ads/MrecBannerAd_" + id);
        methodChannel.setMethodCallHandler(this);
    }

    private FrameLayout createBannerAdContainer(Context context) {
        final DisplayMetrics dm = context.getResources().getDisplayMetrics();
        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(
                dm.widthPixels, -2, Gravity.CENTER);
        FrameLayout frameLayout = new FrameLayout(context);
        frameLayout.setLayoutParams(layoutParams);
        ChocolateLogger.i(TAG,"createMrecBannerAdContainer");
        return frameLayout;
    }

    @Override
    public View getView() {
        return bannerAdContainer;
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
            ChocolateLogger.i(TAG, "plugins.freestar.ads/MrecBannerAd success: " + result);
        }

        @Override
        public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
            ChocolateLogger.e(TAG, "plugins.freestar.ads/MrecBannerAd errorCode: " + errorCode +  " errorMessage: " + errorMessage + " errorDetails: " + errorDetails);
        }

        @Override
        public void notImplemented() {
            ChocolateLogger.e(TAG, "plugins.freestar.ads/MrecBannerAd notImplemented");
        }
    };
}