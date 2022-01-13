//
//  FlutterNativeAd.h
//  freestar_flutter_plugin
//
//  Created by Lev Trubov on 7/8/21.
//

#import <FreestarAds/FreestarAds.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const NATIVE_CHANNEL_PREFIX = @"plugins.freestar.ads/NativeAd";

@interface FlutterNativeAdFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end


@interface FlutterNativeAd : NSObject <FlutterPlatformView>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
