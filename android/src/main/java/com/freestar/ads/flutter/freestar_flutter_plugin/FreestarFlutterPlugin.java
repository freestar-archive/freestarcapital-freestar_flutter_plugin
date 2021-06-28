package com.freestar.ads.flutter.freestar_flutter_plugin;

import android.app.Activity;
import android.content.DialogInterface;

import com.freestar.android.ads.AdRequest;
import com.freestar.android.ads.ChocolateLogger;
import com.freestar.android.ads.ErrorCodes;
import com.freestar.android.ads.FreeStarAds;
import com.freestar.android.ads.InterstitialAd;
import com.freestar.android.ads.InterstitialAdListener;
import com.freestar.android.ads.RewardedAd;
import com.freestar.android.ads.RewardedAdListener;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Map;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * PluginCodelabPlugin
 */
public class FreestarFlutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

  private static final String TAG = "FreestarFlutterPlugin";
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private static final String CHANNEL_NAME = "freestar_flutter_plugin";
  public static WeakReference<Activity> activity;
  private InterstitialAd interstitialAd;
  private RewardedAd rewardedAd;
  public static boolean isPartnerChooserEnabled;

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    ChocolateLogger.i(TAG, "fsfp_tag: onAttachedToActivity");
    activity = new WeakReference<>(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    //not implemented yet
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = new WeakReference<>(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    //not implemented yet
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_NAME);
    channel.setMethodCallHandler(this);

    flutterPluginBinding
            .getPlatformViewRegistry()
            .registerViewFactory("plugins.freestar.ads/BannerAd", new BannerAdFactory(flutterPluginBinding.getBinaryMessenger()));

    flutterPluginBinding
            .getPlatformViewRegistry()
            .registerViewFactory("plugins.freestar.ads/NativeAd", new NativeAdFactory(flutterPluginBinding.getBinaryMessenger()));
  }

  private boolean isActivityAlive() {
    return activity != null && activity.get() != null && !activity.get().isFinishing() && !activity.get().isDestroyed();
  }

  private Object firstArg(MethodCall call) {
    if (call.arguments instanceof ArrayList) {
      return ((ArrayList) call.arguments).get(0);
    } else {
      return call.arguments;
    }
  }

  private void loadInterstitialAd(AdRequest adRequest, String placement) {
    if (placement == null || placement.trim().isEmpty()) {
      interstitialAd.loadAd(adRequest);
    } else {
      interstitialAd.loadAd(adRequest, placement.trim());
    }
  }

  private void loadRewardedAd(AdRequest adRequest, String placement) {
    if (placement == null || placement.trim().isEmpty()) {
      rewardedAd.loadAd(adRequest);
    } else {
      rewardedAd.loadAd(adRequest, placement.trim());
    }
  }

  @Override
  public void onMethodCall(final @NonNull MethodCall call, final @NonNull Result result) {

    ChocolateLogger.w(TAG, "fsfp_tag: onMethodCall. call: " + call.method + " args: " + call.arguments);

    if (call.method.equals("enableTestMode")) {
      ChocolateLogger.w(TAG, "fsfp_tag: enableTestMode " + (Boolean) firstArg(call));
      FreeStarAds.enableTestAds((Boolean) firstArg(call));
      result.success(null);
    } else if (call.method.equals("enableLogging")) {
      FreeStarAds.enableLogging((Boolean) firstArg(call));
      ChocolateLogger.w(TAG, "fsfp_tag: enableLogging " + (Boolean) firstArg(call));
      result.success(null);
    } else if (call.method.equals("enablePartnerChooser")) {
      ChocolateLogger.w(TAG, "fsfp_tag: enablePartnerChooser " + (Boolean) firstArg(call));
      isPartnerChooserEnabled = (Boolean) firstArg(call);
      result.success(null);
    } else if (call.method.equals("init")) {
      ChocolateLogger.w(TAG, "fsfp_tag: before init: activity: " + activity);
      AdRequest adRequest = new AdRequest(activity.get());
      //adRequest.addCustomTargeting("some target", "my value");
      String publisherKey = (String) firstArg(call);
      FreeStarAds.init(activity.get(), publisherKey, adRequest);
      ChocolateLogger.w(TAG, "fsfp_tag: after init: " + publisherKey + " activity: " + activity);
      result.success(null);
    } else if (call.method.equals("showInterstitialAd")) {

      if (interstitialAd != null && interstitialAd.isReady()) {
        interstitialAd.show();
        result.success(null);
      } else {
        result.error("INTERSTITIAL_AD_NOT_READY", "Must call loadAd first", null);
      }

    } else if (call.method.equals("loadRewardedAd")) {

      rewardedAd = new RewardedAd(activity.get(), new RewardedAdListener() {
        @Override
        public void onRewardedVideoLoaded(String s) {
          ChocolateLogger.e(TAG, "onRewardedVideoLoaded");
          if (rewardedAd != null && isActivityAlive()) {
            channel.invokeMethod("onRewardedVideoLoaded", "", callbackResult);
          }
        }

        @Override
        public void onRewardedVideoFailed(String s, int i) {
          ChocolateLogger.e(TAG, "onRewardedVideoFailed: " + ErrorCodes.getErrorDescription(i));
          if (rewardedAd != null && isActivityAlive()) {
            channel.invokeMethod("onRewardedVideoFailed", ErrorCodes.getErrorDescription(i), callbackResult);
          }
        }

        @Override
        public void onRewardedVideoShown(String s) {
          ChocolateLogger.e(TAG, "onRewardedVideoShown");
          channel.invokeMethod("onRewardedVideoShown", "", callbackResult);
        }

        @Override
        public void onRewardedVideoShownError(String s, int i) {
          ChocolateLogger.e(TAG, "onRewardedVideoShownError: " + ErrorCodes.getErrorDescription(i));
          if (rewardedAd != null && isActivityAlive()) {
            channel.invokeMethod("onRewardedVideoShownError", ErrorCodes.getErrorDescription(i), callbackResult);
          }
        }

        @Override
        public void onRewardedVideoDismissed(String s) {
          ChocolateLogger.e(TAG, "onRewardedVideoDismissed");
          channel.invokeMethod("onRewardedVideoDismissed", "", callbackResult);
        }

        @Override
        public void onRewardedVideoCompleted(String s) {
          ChocolateLogger.e(TAG, "onRewardedVideoCompleted");
          channel.invokeMethod("onRewardedVideoCompleted", "", callbackResult);
        }
      });
      final AdRequest adRequest = new AdRequest(activity.get());
      Map params = (Map)call.arguments;
      final String placement = (String)params.get("placement");
      Map targetingParams = (Map)params.get("targetingParams");
      if (targetingParams != null && !targetingParams.isEmpty()) {
        for (Object key : targetingParams.keySet()) {
          String value = (String)targetingParams.get(key);
          adRequest.addCustomTargeting((String)key, value);
          ChocolateLogger.e(TAG, "loadRewardedAd. add custom targeting. name: "+key+ " value: " + value);
        }
      }
      ChocolateLogger.e(TAG, "loadRewardedAd. placement: [" + placement + "]");

      if (isPartnerChooserEnabled) {
        MediationPartners.choosePartners(activity.get(), adRequest, MediationPartners.ADTYPE_REWARDED, new DialogInterface.OnClickListener() {
          @Override
          public void onClick(DialogInterface dialogInterface, int i) {
            loadRewardedAd(adRequest, placement);
          }
        });
      } else {
        loadRewardedAd(adRequest, placement);
      }
      result.success(null);

    } else if (call.method.equals("showRewardedAd")) {

      //String secret, String userId, String rewardName, String rewardAmount
      Map params = (Map)call.arguments;
      if (rewardedAd != null && rewardedAd.isReady()) {
        ChocolateLogger.i(TAG, "showRewardedAd " + params.get("secret") + " " + params.get("userId") + " " + params.get("rewardName") + " " + params.get("rewardAmount"));
        rewardedAd.showRewardAd((String)params.get("secret"), (String)params.get("userId"), (String)params.get("rewardName"), (String)params.get("rewardAmount"));
        result.success(null);
      } else {
        result.error("REWARDED_AD_NOT_READY", "Must call load first", "rewarded ad: " + rewardedAd);
      }

    } else if (call.method.equals("loadInterstitialAd")) {

      interstitialAd = new InterstitialAd(activity.get(), new InterstitialAdListener() {
        @Override
        public void onInterstitialLoaded(String s) {
          ChocolateLogger.e(TAG, "onInterstitialLoaded");
          if (interstitialAd != null && isActivityAlive()) {
            channel.invokeMethod("onInterstitialLoaded", "", callbackResult);
          }
        }

        @Override
        public void onInterstitialFailed(String s, int i) {
          ChocolateLogger.e(TAG, "onInterstitialFailed: " + ErrorCodes.getErrorDescription(i));
          if (interstitialAd != null && isActivityAlive()) {
            channel.invokeMethod("onInterstitialFailed", ErrorCodes.getErrorDescription(i), callbackResult);
          }
        }

        @Override
        public void onInterstitialShown(String s) {
          ChocolateLogger.e(TAG, "onInterstitialShown");
          channel.invokeMethod("onInterstitialShown", "", callbackResult);
        }

        @Override
        public void onInterstitialClicked(String s) {
          ChocolateLogger.e(TAG, "onInterstitialClicked");
          channel.invokeMethod("onInterstitialClicked", "", callbackResult);
        }

        @Override
        public void onInterstitialDismissed(String s) {
          ChocolateLogger.e(TAG, "onInterstitialDismissed");
          interstitialAd = null;
          channel.invokeMethod("onInterstitialDismissed", "", callbackResult);
        }
      });
      final AdRequest adRequest = new AdRequest(activity.get());
      Map params = (Map)call.arguments;
      String placement = (String)params.get("placement");
      Map targetingParams = (Map)params.get("targetingParams");
      if (targetingParams != null && !targetingParams.isEmpty()) {
        for (Object key : targetingParams.keySet()) {
          String value = (String)targetingParams.get(key);
          adRequest.addCustomTargeting((String)key, value);
          ChocolateLogger.e(TAG, "loadInterstitialAd. add custom targeting. name: "+key+ " value: " + value);
        }
      }
      ChocolateLogger.e(TAG, "loadInterstitialAd. placement: [" + placement + "]");
      if (isPartnerChooserEnabled) {
        MediationPartners.choosePartners(activity.get(), adRequest, MediationPartners.ADTYPE_INTERSTITIAL, new DialogInterface.OnClickListener() {
          @Override
          public void onClick(DialogInterface dialogInterface, int i) {
            loadInterstitialAd(adRequest, placement);
          }
        });
      } else {
        loadInterstitialAd(adRequest, placement);
      }
      result.success(null);

    } else {
      result.notImplemented();
    }
  }

  private final Result callbackResult = new Result() {
    @Override
    public void success(@Nullable Object result) {
      ChocolateLogger.e(TAG, "channel success: " + result);
    }

    @Override
    public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
      ChocolateLogger.e(TAG, "channel error: " + errorMessage + " " + errorDetails);
    }

    @Override
    public void notImplemented() {
      ChocolateLogger.e(TAG, "channel notImplemented");
    }
  };

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

}