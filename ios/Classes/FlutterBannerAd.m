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
    self = [super initWithDelegate:self andSize:FreestarBanner300x250];
    channel = [FlutterMethodChannel methodChannelWithName:
               [NSString stringWithFormat:@"%@_%lld", BANNER_CHANNEL_PREFIX, viewId]
               binaryMessenger:messenger];
    
    __weak typeof(self) weakSelf = self;
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"loadBannerAd"]) {
            [weakSelf loadPlacement:nil];
        } else {
            
        }
    }];
    return self;
}

#pragma mark - FlutterPlatformView

- (nonnull UIView *)view {
    return self;
}

#pragma mark - FreestarBannerAdDelegate


- (void)freestarBannerClicked:(nonnull FreestarBannerAd *)ad {
    
}

- (void)freestarBannerClosed:(nonnull FreestarBannerAd *)ad {
    
}

- (void)freestarBannerFailed:(nonnull FreestarBannerAd *)ad because:(FreestarNoAdReason)reason {
    
}

- (void)freestarBannerLoaded:(nonnull FreestarBannerAd *)ad {
    [channel invokeMethod:@"onBannerAdLoaded" arguments:nil];
}

- (void)freestarBannerShown:(nonnull FreestarBannerAd *)ad {
    
}
@end
