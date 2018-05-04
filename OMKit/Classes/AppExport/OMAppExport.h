//
//  AppExport.h
//  OCJSCore
//
//  Created by mlibai on 2017/6/16.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <OMKit/OMAppAnalyticsExport.h>
#import <OMKit/OMAppENUM.h>

@class OMAppNavigationExport, OMAppUserExport, OMAppNetworkExport;
@protocol OMAppExportDelegate;

NS_ASSUME_NONNULL_BEGIN

/** 定义了 OMApp 对 JavaScript 的接口。 */
NS_SWIFT_NAME(AppExportProtocol)
@protocol OMAppExport <NSObject, JSExport>

// 4.0
- (void)ready:(nullable JSValue *)completion;
// 4.1
- (void)login:(nullable JSValue *)completion;
// 4.2
JSExportAs(open, - (void)open:(nonnull NSString *)page parameters:(nullable NSDictionary<NSString *, id> *)parameters);
// 4.3
@property (nonatomic, nonnull, readonly) OMAppNavigationExport *navigation;
// 4.4
@property (nonatomic, nonnull) NSString *currentTheme;
// @property (nonatomic, nonnull) NSString *theme NS_DEPRECATED_IOS(1.0, 1.0, "Use currentTheme instead.");
// 4.5
@property (nonatomic, readonly, nonnull) id<OMAppAnalyticsExport> analytics;
// 4.6
@property (nonatomic, nonnull, readonly) OMAppUserExport *currentUser;
// 4.7
JSExportAs(http, - (void)http:(nonnull NSDictionary<NSString *, id> *)request completion:(nullable JSValue *)completion);
// 4.8
JSExportAs(alert, - (void)alert:(nonnull NSDictionary<NSString *, id> *)message completion:(nullable JSValue *)completion);
// 4.9
@property (nonatomic, nonnull, readonly) OMAppNetworkExport *network;

- (void)present:(nonnull NSString *)url;

@end


NS_SWIFT_NAME(AppExport)
@interface OMAppExport : NSObject <OMAppExport, OMAppAnalyticsExport>

- (instancetype)init;
- (instancetype)initWithNavigation:(OMAppNavigationExport *)navigation
                       currentUser:(OMAppUserExport *)currentUser
                           network:(OMAppNetworkExport *)network NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak, nullable) id<OMAppExportDelegate> delegate;

@end








NS_SWIFT_NAME(AppHTTPRequestProtocol)
@protocol OMAppHTTPRequest <NSObject>
@property (nonatomic, copy, readonly, nonnull) NSString *url;
@property (nonatomic, copy, readonly, nonnull) NSString *method;
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, id> *params OBJC_DEPRECATED("User `data` property please.");
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, id> *data;
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, NSString *> *headers;
@end

NS_SWIFT_NAME(AppHTTPRequest)
@interface OMAppHTTPRequest : NSObject <OMAppHTTPRequest>
@end

@protocol OMAppNavigationBarExport;

NS_SWIFT_NAME(AppExportDelegate)
@protocol OMAppExportDelegate <NSObject>

- (void)appExport:(OMAppExport *)appExport currentTheme:(OMAppTheme)currentTheme;
- (void)appExport:(OMAppExport *)appExport login:(void (^)(BOOL))completion;
- (void)appExport:(OMAppExport *)appExport open:(OMAppPage)page parameters:(nullable NSDictionary<NSString *, id> *)parameters;
- (void)appExport:(OMAppExport *)appExport present:(nonnull NSString *)url;
- (void)appExport:(OMAppExport *)appExport http:(OMAppHTTPRequest *)request completion:(void (^)(BOOL success, id _Nullable result))completion;

- (void)appExport:(OMAppExport *)appExport navigationPush:(NSString *)url animated:(BOOL)animated;
- (void)appExport:(OMAppExport *)appExport navigationPop:(BOOL)animated;
- (void)appExport:(OMAppExport *)appExport navigationPopTo:(NSInteger)index animated:(BOOL)animated;

- (void)appExport:(OMAppExport *)appExport updateNavigationBarTitle:(nullable NSString *)title;
- (void)appExport:(OMAppExport *)appExport updateNavigationBarTitleColor:(UIColor *)titleColor;
- (void)appExport:(OMAppExport *)appExport updateNavigationBarVisibility:(BOOL)isHidden;
- (void)appExport:(OMAppExport *)appExport updateNavigationBarBackgroundColor:(UIColor *)backgroundColor;

- (void)appExport:(OMAppExport *)appExport analyticsTrack:(NSString *)event parameters:(nullable NSDictionary<NSString *, id> *)parameters;

@end



NS_ASSUME_NONNULL_END
