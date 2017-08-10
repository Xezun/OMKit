//
//  OMAppAnalyticsExport.h
//  Pods
//
//  Created by mlibai on 2017/8/10.
//
//

@import JavaScriptCore;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AppAnalyticsExportProtocol)
@protocol OMAppAnalyticsExport <NSObject, JSExport>

JSExportAs(track, - (void)track:(nonnull NSString *)event parameters:(nullable NSDictionary<NSString *, id> *)parameters);

@end

NS_ASSUME_NONNULL_END
