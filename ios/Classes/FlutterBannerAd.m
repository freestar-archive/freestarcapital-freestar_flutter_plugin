//
//  FlutterBannerAd.m
//  freestar_flutter_plugin
//
//  Created by Lev Trubov on 7/8/21.
//

#import "FlutterBannerAd.h"

@implementation FlutterBannerAdFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if( self = [super init] ) {
        _messenger = messenger;
        return self;
    }
    return nil;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    return [[FlutterBannerAd alloc] initWithFrame:frame
                                   viewIdentifier:viewId
                                        arguments:args
                                  binaryMessenger:_messenger];
    
}

@end

@interface FlutterBannerAd () <FreestarBannerAdDelegate>
@property(nonatomic, strong) FreestarBannerAd *ad;

@end

@implementation FlutterBannerAd {
    FlutterMethodChannel *channel;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    channel = [FlutterMethodChannel methodChannelWithName:
               [NSString stringWithFormat:@"%@_%lld", BANNER_CHANNEL_PREFIX, viewId]
                                          binaryMessenger:messenger];
    
    __weak typeof(self) weakSelf = self;
    
    self.ad = [[FreestarBannerAd alloc] initWithDelegate:self andSize:FreestarBanner320x50];
    self.ad.frame =[self frameForSize:FreestarBanner320x50];
    
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"loadBannerAd"]) {
            [weakSelf loadAd:call];
        } else if ([call.method isEqualToString:@"resumed"]) {
            [weakSelf appGainedFocus];
        } else if ([call.method isEqualToString:@"paused"]) {
            [weakSelf appLostFocus];
        } else if ([call.method isEqualToString:@"detached"]) {
            [weakSelf detachAd];
        }
    }];
    return self;
}

- (CGRect)frameForSize:(FreestarBannerAdSize)size {
    switch (size) {
        case FreestarBanner300x250:
            return CGRectMake(0, 0, 300, 250);
        case FreestarBanner320x50:
        case FreestarBanner728x90:
        default:
            break;
}
    return CGRectZero;
}

- (void)loadAd:(FlutterMethodCall *)call {
    int size = [call.arguments[@"adSize"] intValue];
    // TODO: support leaderboard size
    FreestarBannerAdSize adSize = size;
    NSString *placement = call.arguments[@"placement"];
    NSDictionary *targeting = call.arguments[@"targetingMap"];
    
    [targeting enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        [self.ad addCustomTargeting:key as:obj];
    }];
    
    [self.ad loadPlacement:placement];
}

- (void)appLostFocus {
    [self.ad performSelector:@selector(appLostFocus)];
}

- (void)appGainedFocus {
    [self.ad performSelector:@selector(appGainedFocus)];
}

- (void)detachAd {
    [self.ad removeFromSuperview];
}

#pragma mark - FlutterPlatformView

- (nonnull UIView *)view {
    return self.ad;
}

#pragma mark - FreestarBannerAdDelegate


- (void)freestarBannerClicked:(nonnull FreestarBannerAd *)ad {
    [channel invokeMethod:@"onBannerAdClicked" arguments:@""];
    
}

- (void)freestarBannerClosed:(nonnull FreestarBannerAd *)ad {
    [channel invokeMethod:@"onBannerAdClosed" arguments:@""];
}

- (void)freestarBannerFailed:(nonnull FreestarBannerAd *)ad because:(FreestarNoAdReason)reason {
    [channel invokeMethod:@"onBannerAdFailed" arguments:[NSString stringWithFormat:@"%ld", reason]];
    
}

- (void)freestarBannerLoaded:(nonnull FreestarBannerAd *)ad {
    [channel invokeMethod:@"onBannerAdLoaded" arguments:@""];
}

- (void)freestarBannerShown:(nonnull FreestarBannerAd *)ad {}
@end
