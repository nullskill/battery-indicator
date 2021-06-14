#import "BatteryIndicatorPlugin.h"
#if __has_include(<battery_indicator/battery_indicator-Swift.h>)
#import <battery_indicator/battery_indicator-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "battery_indicator-Swift.h"
#endif

@implementation BatteryIndicatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBatteryIndicatorPlugin registerWithRegistrar:registrar];
}
@end
