//
//  OMAppENUM.h
//  Pods
//
//  Created by mlibai on 2017/8/10.
//
//

#import <Foundation/Foundation.h>

@import JavaScriptCore;

/// AppPage 枚举 NS_EXTENSIBLE_STRING_ENUM
typedef NSString *OMAppPage NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(AppPage);
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageMall;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageTask;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageNewsDetail;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageNewsList;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageVideoList;
FOUNDATION_EXPORT OMAppPage _Nonnull const OMAppPageVideoDetail;

NS_SWIFT_NAME(AppPageExportProtocol) @protocol
OMAppPageExport <NSObject, JSExport>
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






/// AppTheme 枚举
typedef NSString *OMAppTheme NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(AppTheme);
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




/// OMAppUserType 枚举
typedef NSString *OMAppUserType NS_EXTENSIBLE_STRING_ENUM NS_SWIFT_NAME(AppUserType);
FOUNDATION_EXPORT OMAppUserType const _Nonnull OMAppUserTypeVisitor;
FOUNDATION_EXPORT OMAppUserType const _Nonnull OMAppUserTypeGoogle;
FOUNDATION_EXPORT OMAppUserType const _Nonnull OMAppUserTypeFacebook;
FOUNDATION_EXPORT OMAppUserType const _Nonnull OMAppUserTypeTwitter;

NS_SWIFT_NAME(AppUserTypeExportProtocol)
@protocol OMAppUserTypeExport <NSObject, JSExport>
@property (nonatomic, readonly, nonnull) OMAppUserType visitor;
@property (nonatomic, readonly, nonnull) OMAppUserType google;
@property (nonatomic, readonly, nonnull) OMAppUserType facebook;
@property (nonatomic, readonly, nonnull) OMAppUserType twitter;
@end

NS_SWIFT_NAME(AppUserTypeExport)
@interface OMAppUserTypeExport : NSObject <OMAppUserTypeExport>
@end






/// OMAppNetworkType 枚举
typedef NSString *OMAppNetworkType NS_STRING_ENUM NS_SWIFT_NAME(AppNetworkType);
FOUNDATION_EXPORT OMAppNetworkType const _Nonnull OMAppNetworkTypeNone;
FOUNDATION_EXPORT OMAppNetworkType const _Nonnull OMAppNetworkTypeWiFi NS_SWIFT_NAME(WiFi);
FOUNDATION_EXPORT OMAppNetworkType const _Nonnull OMAppNetworkType2G NS_SWIFT_NAME(WWan2G);
FOUNDATION_EXPORT OMAppNetworkType const _Nonnull OMAppNetworkType3G NS_SWIFT_NAME(WWan3G);
FOUNDATION_EXPORT OMAppNetworkType const _Nonnull OMAppNetworkType4G NS_SWIFT_NAME(WWan4G);
FOUNDATION_EXPORT OMAppNetworkType const _Nonnull OMAppNetworkTypeUnknown;

NS_SWIFT_NAME(AppNetworkTypeExportProtocol)
@protocol OMAppNetworkTypeExport <NSObject, JSExport>

@property (nonatomic, copy, readonly, nonnull) NSString *none;
@property (nonatomic, copy, readonly, nonnull) NSString *WiFi;
@property (nonatomic, copy, readonly, nonnull) NSString *WWan2G;
@property (nonatomic, copy, readonly, nonnull) NSString *WWan3G;
@property (nonatomic, copy, readonly, nonnull) NSString *WWan4G;
@property (nonatomic, copy, readonly, nonnull) NSString *unknown;

@end

NS_SWIFT_NAME(AppNetworkTypeExport)
@interface OMAppNetworkTypeExport : NSObject <OMAppNetworkTypeExport>
@end


