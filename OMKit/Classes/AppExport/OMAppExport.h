//
//  AppExport.h
//  OCJSCore
//
//  Created by mlibai on 2017/6/16.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class OMAppNavigationExport, OMAppUserExport;
@protocol OMAppExportDelegate;

/// AppPage 枚举
typedef NSString *OMAppPage NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(AppPage);
/// AppTheme 枚举
typedef NSString *OMAppTheme NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(AppTheme);

NS_ASSUME_NONNULL_BEGIN


/** 定义了 OMApp 对 JavaScript 的接口。 */
NS_SWIFT_NAME(AppExportProtocol)
@protocol OMAppExport <NSObject, JSExport>
@property (nonatomic, strong, nonnull, readonly) OMAppNavigationExport *navigation;
@property (nonatomic, strong, nonnull) NSString *currentTheme;
@property (nonatomic, strong, nonnull) NSString *theme __deprecated;
@property (nonatomic, strong, nonnull, readonly) OMAppUserExport *currentUser;
- (void)login:(nullable JSValue *)completion;
JSExportAs(open, - (void)open:(nonnull NSString *)page parameters:(nullable NSDictionary<NSString *, id> *)parameters);
- (void)present:(nonnull NSString *)url;
JSExportAs(http, - (void)http:(nonnull NSDictionary<NSString *, id> *)request completion:(nullable JSValue *)completion);
JSExportAs(alert, - (void)alert:(nonnull NSDictionary<NSString *, id> *)message completion:(nullable JSValue *)completion);
@end


NS_SWIFT_NAME(AppExport)
@interface OMAppExport : NSObject <OMAppExport>

+ (OMAppExport *)exportWithContext:(nonnull JSContext *)context delegate:(nullable id<OMAppExportDelegate>)delegate;

- (instancetype)initWithNavigation:(OMAppNavigationExport *)navigation currentUser:(OMAppUserExport *)currentUser NS_DESIGNATED_INITIALIZER;

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

- (void)appExport:(OMAppExport *)appExport didCatchAnException:(NSString *)expection;

@end






FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageMall;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageTask;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageNewsDetail;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageNewsList;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageVideoList;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageVideoDetail;

NS_SWIFT_NAME(AppPageExportProtocol)
@protocol OMAppPageExport <NSObject, JSExport>
@property (nonatomic, readonly, nonnull) OMAppPage mall;
@property (nonatomic, readonly, nonnull) OMAppPage task;
@property (nonatomic, readonly, nonnull) OMAppPage newsList;
@property (nonatomic, readonly, nonnull) OMAppPage newsDetail;
@property (nonatomic, readonly, nonnull) OMAppPage videoList;
@property (nonatomic, readonly, nonnull) OMAppPage videoDetail;
@end

NS_SWIFT_NAME(AppPageExport)
@interface OMAppPageExport : NSObject <OMAppPageExport>
@end



FOUNDATION_EXPORT OMAppTheme const _Nonnull OMAppThemeDay;
FOUNDATION_EXPORT OMAppTheme const _Nonnull OMAppThemeNight;

NS_SWIFT_NAME(AppThemeExportProtocol)
@protocol OMAppThemeExport <NSObject, JSExport>
@property (nonatomic, readonly, nonnull) OMAppTheme day;
@property (nonatomic, readonly, nonnull) OMAppTheme night;
@end

NS_SWIFT_NAME(AppThemeExport)
@interface OMAppThemeExport : NSObject <OMAppThemeExport>
@end




NS_ASSUME_NONNULL_END
