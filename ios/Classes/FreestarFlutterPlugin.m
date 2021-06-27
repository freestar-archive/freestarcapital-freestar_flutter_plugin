#import "FreestarFlutterPlugin.h"
#if __has_include(<freestar_flutter_plugin/freestar_flutter_plugin-Swift.h>)
#import <freestar_flutter_plugin/freestar_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "freestar_flutter_plugin-Swift.h"
#endif

@implementation FreestarFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFreestarFlutterPlugin registerWithRegistrar:registrar];
}
@end
