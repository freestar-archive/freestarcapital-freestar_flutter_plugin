//
//  FlutterNativeAd.m
//  freestar_flutter_plugin
//
//  Created by Lev Trubov on 7/8/21.
//

#import "FlutterNativeAd.h"

static FreestarNativeAdSize FLUTTER_NATIVE_SIZES[2] = {
    FreestarNativeSmall,
    FreestarNativeMedium
};

@implementation FlutterNativeAdFactory {
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
    return [[FlutterNativeAd alloc] initWithFrame:frame
                                   viewIdentifier:viewId
                                        arguments:args
                                  binaryMessenger:_messenger];
    
}

@end

@interface FlutterNativeAd () <FreestarNativeAdDelegate>

@end

@implementation FlutterNativeAd {
    FlutterMethodChannel *channel;
    FreestarNativeAd *ad;
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
               [NSString stringWithFormat:@"%@_%lld", NATIVE_CHANNEL_PREFIX, viewId]
                                          binaryMessenger:messenger];
    
    __weak typeof(self) weakSelf = self;
    
    ad = [[FreestarNativeAd alloc] initWithDelegate:self andSize:FreestarNativeSmall];
    
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"loadNativeAd"]) {
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
    int size = [call.arguments[@"template"] intValue];
    
    if(size == 1) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[ad valueForKey:@"ad"] methodSignatureForSelector:@selector(setSize:)]];
        [inv setSelector:@selector(setSize:)];
        [inv setTarget:[ad valueForKey:@"ad"]];
        [inv setArgument:&FLUTTER_NATIVE_SIZES[size] atIndex:2];
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

#pragma mark - FreestarNativeAdDelegate


- (void)freestarNativeClicked:(nonnull FreestarNativeAd *)ad {
    [channel invokeMethod:@"onNativeAdClicked" arguments:@""];
    
}

- (void)freestarNativeClosed:(nonnull FreestarNativeAd *)ad {
    [channel invokeMethod:@"onNativeAdClosed" arguments:@""];
}

- (void)freestarNativeFailed:(nonnull FreestarNativeAd *)ad because:(FreestarNoAdReason)reason {
    [channel invokeMethod:@"onNativeAdFailed" arguments:[NSString stringWithFormat:@"%ld", reason]];
    
}

- (void)freestarNativeLoaded:(nonnull FreestarNativeAd *)ad {
    [channel invokeMethod:@"onNativeAdLoaded" arguments:@""];
}

- (void)freestarNativeShown:(nonnull FreestarNativeAd *)ad {}
@end
