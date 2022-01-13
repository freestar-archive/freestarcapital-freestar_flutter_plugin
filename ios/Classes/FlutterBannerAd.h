//
//  FlutterBannerAd.h
//  freestar_flutter_plugin
//
//  Created by Lev Trubov on 7/8/21.
//

#import <FreestarAds/FreestarAds.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const BANNER_CHANNEL_PREFIX = @"plugins.freestar.ads/BannerAd";

@interface FlutterBannerAdFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end


@interface FlutterBannerAd : NSObject <FlutterPlatformView>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
