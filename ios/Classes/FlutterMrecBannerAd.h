//
//  FlutterMrecBannerAd.h
//  freestar_flutter_plugin
//
//  Created by Dean Chang on 8/10/23.
//

#import <FreestarAds/FreestarAds.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const MREC_BANNER_CHANNEL_PREFIX = @"plugins.freestar.ads/MrecBannerAd";

@interface FlutterMrecBannerAdFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end


@interface FlutterMrecBannerAd : NSObject <FlutterPlatformView>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
