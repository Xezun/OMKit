//
//  AppExport.h
//  OCJSCore
//
//  Created by mlibai on 2017/6/16.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class OMAppNavigationExport, OMAppUserExport, OMAppNetworkExport;
@protocol OMAppExportDelegate;

NS_ASSUME_NONNULL_BEGIN

/// AppPage 枚举 NS_EXTENSIBLE_STRING_ENUM
typedef NSString *OMAppPage NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(AppPage);
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageMall;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageTask;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageNewsDetail;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageNewsList;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageVideoList;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageVideoDetail;

/// AppTheme 枚举
typedef NSString *OMAppTheme NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(AppTheme);
FOUNDATION_EXPORT OMAppTheme const _Nonnull OMAppThemeDay;
FOUNDATION_EXPORT OMAppTheme const _Nonnull OMAppThemeNight;


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
@property (nonatomic, strong, nonnull, readonly) OMAppNavigationExport *navigation;
// 4.4
@property (nonatomic, strong, nonnull) NSString *currentTheme;
@property (nonatomic, strong, nonnull) NSString *theme __deprecated;
// 4.5
// TODO: 4.5
// 4.6
@property (nonatomic, strong, nonnull, readonly) OMAppUserExport *currentUser;
// 4.7
JSExportAs(http, - (void)http:(nonnull NSDictionary<NSString *, id> *)request completion:(nullable JSValue *)completion);
// 4.8
JSExportAs(alert, - (void)alert:(nonnull NSDictionary<NSString *, id> *)message completion:(nullable JSValue *)completion);
// 4.9
@property (nonatomic, strong, nonnull, readonly) OMAppNetworkExport *network;
- (void)present:(nonnull NSString *)url;
@end


NS_SWIFT_NAME(AppExport)
@interface OMAppExport : NSObject <OMAppExport>

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

//- (void)appExport:(OMAppExport *)appExport didCatchAnException:(NSString *)expection;

@end








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


NS_SWIFT_NAME(AppThemeExportProtocol)
@protocol OMAppThemeExport <NSObject, JSExport>
@property (nonatomic, readonly, nonnull) OMAppTheme day;
@property (nonatomic, readonly, nonnull) OMAppTheme night;
@end

NS_SWIFT_NAME(AppThemeExport)
@interface OMAppThemeExport : NSObject <OMAppThemeExport>
@end




NS_ASSUME_NONNULL_END
