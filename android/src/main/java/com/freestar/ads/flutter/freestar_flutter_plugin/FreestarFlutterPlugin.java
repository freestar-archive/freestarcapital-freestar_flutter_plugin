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
  private MethodChannel channel, interstitialChannel, rewardedChannel;
  private static final String CHANNEL_NAME = "freestar_flutter_plugin";
  private static final String INTERSTITIAL_CHANNEL_NAME = "freestar_flutter_plugin/InterstitialAd";
  private static final String REWARDED_CHANNEL_NAME = "freestar_flutter_plugin/RewardedAd";
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
    interstitialChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), INTERSTITIAL_CHANNEL_NAME);
    rewardedChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), REWARDED_CHANNEL_NAME);
    channel.setMethodCallHandler(this);
    interstitialChannel.setMethodCallHandler(this);
    rewardedChannel.setMethodCallHandler(this);

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

    switch (call.method) {
      case "enableTestMode":
        ChocolateLogger.w(TAG, "fsfp_tag: enableTestMode " + (Boolean) firstArg(call));
        FreeStarAds.enableTestAds((Boolean) firstArg(call));
        result.success(null);
        break;
      case "enableLogging":
        FreeStarAds.enableLogging((Boolean) firstArg(call));
        ChocolateLogger.w(TAG, "fsfp_tag: enableLogging " + (Boolean) firstArg(call));
        result.success(null);
        break;
      case "enablePartnerChooser":
        ChocolateLogger.w(TAG, "fsfp_tag: enablePartnerChooser " + (Boolean) firstArg(call));
        isPartnerChooserEnabled = (Boolean) firstArg(call);
        result.success(null);
        break;
      case "init": {
        ChocolateLogger.w(TAG, "fsfp_tag: before init: activity: " + activity);
        AdRequest adRequest = new AdRequest(activity.get());
        //adRequest.addCustomTargeting("some target", "my value");
        String publisherKey = (String) firstArg(call);
        FreeStarAds.init(activity.get(), publisherKey, adRequest);
        ChocolateLogger.w(TAG, "fsfp_tag: after init: " + publisherKey + " activity: " + activity);
        result.success(null);
        break;
      }
      case "showInterstitialAd":

        if (interstitialAd != null && interstitialAd.isReady()) {
          interstitialAd.show();
          result.success(null);
        } else {
          result.error("INTERSTITIAL_AD_NOT_READY", "Must call loadAd first", null);
        }

        break;
      case "loadRewardedAd": {

        rewardedAd = new RewardedAd(activity.get(), new RewardedAdListener() {
          @Override
          public void onRewardedAdLoaded(String s) {
            ChocolateLogger.e(TAG, "onRewardedAdLoaded");
            if (rewardedAd != null && isActivityAlive()) {
              rewardedChannel.invokeMethod("onRewardedAdLoaded", "", callbackResult);
            }
          }

          @Override
          public void onRewardedAdFailed(String s, int i) {
            ChocolateLogger.e(TAG, "onRewardedAdFailed: " + ErrorCodes.getErrorDescription(i));
            if (rewardedAd != null && isActivityAlive()) {
              rewardedChannel.invokeMethod("onRewardedAdFailed", ErrorCodes.getErrorDescription(i), callbackResult);
            }
          }

          @Override
          public void onRewardedAdShown(String s) {
            ChocolateLogger.e(TAG, "onRewardedAdShown");
            rewardedChannel.invokeMethod("onRewardedAdShown", "", callbackResult);
          }

          @Override
          public void onRewardedAdShownError(String s, int i) {
            ChocolateLogger.e(TAG, "onRewardedAdShownError: " + ErrorCodes.getErrorDescription(i));
            if (rewardedAd != null && isActivityAlive()) {
              rewardedChannel.invokeMethod("onRewardedAdShownError", ErrorCodes.getErrorDescription(i), callbackResult);
            }
          }

          @Override
          public void onRewardedAdDismissed(String s) {
            ChocolateLogger.e(TAG, "onRewardedAdDismissed");
            rewardedChannel.invokeMethod("onRewardedAdDismissed", "", callbackResult);
          }

          @Override
          public void onRewardedAdCompleted(String s) {
            ChocolateLogger.e(TAG, "onRewardedAdCompleted");
            rewardedChannel.invokeMethod("onRewardedAdCompleted", "", callbackResult);
          }
        });
        final AdRequest adRequest = new AdRequest(activity.get());
        Map map = (Map) call.arguments;
        final String placement = (String) map.get("placement");
        Utils.addTargetingParams(adRequest, (Map) map.get("targetingMap"));
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

        break;
      }
      case "showRewardedAd":

        //String secret, String userId, String rewardName, String rewardAmount
        Map params = (Map) call.arguments;
        if (rewardedAd != null && rewardedAd.isReady()) {
          ChocolateLogger.i(TAG, "showRewardedAd " + params.get("secret") + " " + params.get("userId") + " " + params.get("rewardName") + " " + params.get("rewardAmount"));
          rewardedAd.showRewardAd((String) params.get("secret"), (String) params.get("userId"), (String) params.get("rewardName"), (String) params.get("rewardAmount"));
          result.success(null);
        } else {
          result.error("REWARDED_AD_NOT_READY", "Must call load first", "rewarded ad: " + rewardedAd);
        }

        break;
      case "loadInterstitialAd": {

        interstitialAd = new InterstitialAd(activity.get(), new InterstitialAdListener() {
          @Override
          public void onInterstitialAdLoaded(String s) {
            ChocolateLogger.e(TAG, "onInterstitialAdLoaded");
            if (interstitialAd != null && isActivityAlive()) {
              interstitialChannel.invokeMethod("onInterstitialAdLoaded", "", callbackResult);
            }
          }

          @Override
          public void onInterstitialAdFailed (String s, int i) {
            ChocolateLogger.e(TAG, "onInterstitialAdFailed : " + ErrorCodes.getErrorDescription(i));
            if (interstitialAd != null && isActivityAlive()) {
              interstitialChannel.invokeMethod("onInterstitialAdFailed ", ErrorCodes.getErrorDescription(i), callbackResult);
            }
          }

          @Override
          public void onInterstitialAdShown(String s) {
            ChocolateLogger.e(TAG, "onInterstitialAdShown");
            interstitialChannel.invokeMethod("onInterstitialAdShown", "", callbackResult);
          }

          @Override
          public void onInterstitialAdClicked(String s) {
            ChocolateLogger.e(TAG, "onInterstitialAdClicked");
            interstitialChannel.invokeMethod("onInterstitialAdClicked", "", callbackResult);
          }

          @Override
          public void onInterstitialAdDismissed(String s) {
            ChocolateLogger.e(TAG, "onInterstitialAdDismissed");
            interstitialAd = null;
            interstitialChannel.invokeMethod("onInterstitialAdDismissed", "", callbackResult);
          }
        });
        final AdRequest adRequest = new AdRequest(activity.get());
        Map map = (Map) call.arguments;
        String placement = (String) map.get("placement");
        Utils.addTargetingParams(adRequest, (Map) map.get("targetingMap"));
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

        break;
      }
      default:
        result.notImplemented();
        break;
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
    interstitialChannel.setMethodCallHandler(null);
    rewardedChannel.setMethodCallHandler(null);
  }

}