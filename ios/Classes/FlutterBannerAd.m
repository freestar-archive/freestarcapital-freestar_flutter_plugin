//
//  FlutterBannerAd.m
//  freestar_flutter_plugin
//
//  Created by Lev Trubov on 7/8/21.
//

#import "FlutterBannerAd.h"

static FreestarBannerAdSize FLUTTER_BANNER_SIZES[3] = {
    FreestarBanner320x50,
    FreestarBanner300x250,
    FreestarBanner728x90
};

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



@end

@implementation FlutterBannerAd {
    FlutterMethodChannel *channel;
    FreestarBannerAd *ad;
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
    
    ad = [[FreestarBannerAd alloc] initWithDelegate:self andSize:FreestarBanner320x50];
    
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

- (void)loadAd:(FlutterMethodCall *)call {
    int size = [call.arguments[@"adSize"] intValue];
    
    if(size == 1 || size == 2) {
        ad.bounds = size == 1 ? CGRectMake(0, 0, 300, 250) : CGRectMake(0, 0, 728, 90);
        
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[ad valueForKey:@"ad"] methodSignatureForSelector:@selector(setSize:)]];
        [inv setSelector:@selector(setSize:)];
        [inv setTarget:[ad valueForKey:@"ad"]];
        [inv setArgument:&FLUTTER_BANNER_SIZES[size] atIndex:2];
        [inv invoke];
    }
    
    NSString *placement = call.arguments[@"placement"];
    NSDictionary *targeting = call.arguments[@"targetingMap"];
    
    
    [targeting enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        [ad addCustomTargeting:key as:obj];
    }];
    
    [ad loadPlacement:placement];
}

- (void)appLostFocus {
    [ad performSelector:@selector(appLostFocus)];
    [[ad valueForKeyPath:@"ad.winner"] performSelector:@selector(appLostFocus)];
}

- (void)appGainedFocus {
    [ad performSelector:@selector(appGainedFocus)];
    [[ad valueForKeyPath:@"ad.winner"] performSelector:@selector(appGainedFocus)];
}

- (void) detachAd {
    [[ad valueForKeyPath:@"ad"] performSelector:@selector(close)];
}

#pragma mark - FlutterPlatformView

- (nonnull UIView *)view {
    return ad;
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
