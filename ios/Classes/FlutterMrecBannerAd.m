//
//  FlutterMrecBannerAd.m
//  freestar_flutter_plugin
//
//  Created by Dean Chang on 8/10/23.
//

#import "FlutterMrecBannerAd.h"

@implementation FlutterMrecBannerAdFactory {
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
    return [[FlutterMrecBannerAd alloc] initWithFrame:frame
                                   viewIdentifier:viewId
                                        arguments:args
                                  binaryMessenger:_messenger];
    
}

@end

@interface FlutterMrecBannerAd () <FreestarBannerAdDelegate>
@property(nonatomic, strong) FreestarBannerAd *ad;

@end

@implementation FlutterMrecBannerAd {
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
               [NSString stringWithFormat:@"%@_%lld", MREC_BANNER_CHANNEL_PREFIX, viewId]
                                          binaryMessenger:messenger];
    
    __weak typeof(self) weakSelf = self;
    
    self.ad = [[FreestarBannerAd alloc] initWithDelegate:self andSize:FreestarBanner300x250];
    self.ad.frame =[self frameForSize:FreestarBanner300x250];
    
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
        case FreestarBanner320x50:
            return CGRectMake(0, 0, 320, 50);
        case FreestarBanner300x250:
            return CGRectMake(0, 0, 300, 250);
        case FreestarBanner728x90:
            return CGRectMake(0, 0, 728, 90);
        default:
            break;
    }
    return CGRectZero;
}

- (void)loadAd:(FlutterMethodCall *)call {
//    int size = [call.arguments[@"adSize"] intValue];
//    self.ad.frame = [self frameForSize:adSize];
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

