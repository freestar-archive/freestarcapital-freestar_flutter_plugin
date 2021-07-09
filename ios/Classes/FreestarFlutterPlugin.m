#import "FreestarFlutterPlugin.h"
#if __has_include(<freestar_flutter_plugin/freestar_flutter_plugin-Swift.h>)
#import <freestar_flutter_plugin/freestar_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "freestar_flutter_plugin-Swift.h"
#endif

#import "FlutterBannerAd.h"
#import "FlutterNativeAd.h"

static const NSString *REWARDED_CHANNEL_PREFIX = @"freestar_flutter_plugin/RewardedAd";

@implementation FreestarFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftFreestarFlutterPlugin registerWithRegistrar:registrar];
    FlutterBannerAdFactory *bannerAdFactory = [[FlutterBannerAdFactory alloc] initWithMessenger:registrar.messenger];
    FlutterNativeAdFactory *nativeAdFactory = [[FlutterNativeAdFactory alloc] initWithMessenger:registrar.messenger];

    [registrar registerViewFactory:bannerAdFactory withId:BANNER_CHANNEL_PREFIX];
    [registrar registerViewFactory:nativeAdFactory withId:NATIVE_CHANNEL_PREFIX];
    
    [FreestarRewardedPlugin registerWithRegistrar:registrar];
    
}
@end

@interface FreestarRewardedPlugin() <FreestarRewardedDelegate>
@end

@implementation FreestarRewardedPlugin {
    FreestarRewardedAd *ad;
}

static FlutterMethodChannel* rewardedChanel = nil;

-(instancetype) init {
    self = [super init];
    ad = [[FreestarRewardedAd alloc] initWithDelegate:self andReward:[FreestarReward blankReward]];
    return self;
}

#pragma mark - FlutterPlugin

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    rewardedChanel = [FlutterMethodChannel methodChannelWithName:REWARDED_CHANNEL_PREFIX binaryMessenger:registrar.messenger];
    [registrar addMethodCallDelegate:[[FreestarRewardedPlugin alloc] init] channel:rewardedChanel];
}

-(void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"loadRewardedAd"]) {
        NSString *placement = call.arguments[@"placement"];
        NSDictionary *targeting = call.arguments[@"targetingMap"];
            
        
        [targeting enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
            [ad addCustomTargeting:key as:obj];
        }];
        
        [ad loadPlacement:placement];
    } else if ([call.method isEqualToString:@"showRewardedAd"]) {
        NSString *secret = call.arguments[@"secret"];
        NSString *userID = call.arguments[@"userID"];
        NSString *rewName = call.arguments[@"rewardName"];
        NSString *rewAmt = call.arguments[@"rewardAmount"];
        
        if (secret) {
            ad.reward.secretKey = secret;
        }
        if (userID) {
            ad.reward.userID = userID;
        }
        if (rewName) {
            ad.reward.rewardName = rewName;
        }
        if (rewAmt) {
            ad.reward.rewardAmount = [rewAmt integerValue];
        }
        
        [ad showFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
    }
}

#pragma mark - FreestarRewardAdDelegate

- (void)freestarRewardedAd:(nonnull FreestarRewardedAd *)ad received:(nonnull NSString *)rewardName amount:(NSInteger)rewardAmount {
    [rewardedChanel invokeMethod:@"onRewardedAdCompleted" arguments:(ad.placement ?: @"")];
}

- (void)freestarRewardedClosed:(nonnull FreestarRewardedAd *)ad {
    [rewardedChanel invokeMethod:@"onRewardedAdDismissed" arguments:(ad.placement ?: @"")];
}

- (void)freestarRewardedFailed:(nonnull FreestarRewardedAd *)ad because:(FreestarNoAdReason)reason {
    [rewardedChanel invokeMethod:@"onRewardedAdFailed" arguments:[NSString stringWithFormat:@"%lu", (unsigned long)reason]];

}

- (void)freestarRewardedFailedToStart:(nonnull FreestarRewardedAd *)ad because:(FreestarNoAdReason)reason {
    [rewardedChanel invokeMethod:@"onRewardedAdShownError" arguments:[NSString stringWithFormat:@"%lu", (unsigned long)reason]];

}

- (void)freestarRewardedLoaded:(nonnull FreestarRewardedAd *)ad {
    [rewardedChanel invokeMethod:@"onRewardedAdLoaded" arguments:(ad.placement ?: @"")];
}

- (void)freestarRewardedShown:(nonnull FreestarRewardedAd *)ad {
    [rewardedChanel invokeMethod:@"onRewardedAdShown" arguments:(ad.placement ?: @"")];
}

@end
