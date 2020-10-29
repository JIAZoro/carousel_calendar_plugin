#import "CarouselCalendarPlugin.h"
#if __has_include(<carousel_calendar_plugin/carousel_calendar_plugin-Swift.h>)
#import <carousel_calendar_plugin/carousel_calendar_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "carousel_calendar_plugin-Swift.h"
#endif

@implementation CarouselCalendarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCarouselCalendarPlugin registerWithRegistrar:registrar];
}
@end
