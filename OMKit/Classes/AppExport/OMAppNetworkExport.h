//
//  OMAppNetworkExport.h
//  Pods
//
//  Created by mlibai on 2017/8/3.
//
//

#import <Foundation/Foundation.h>
@import JavaScriptCore;

/// AppTheme 枚举
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


NS_SWIFT_NAME(AppNetworkExportProtocol)
@protocol OMAppNetworkExport <NSObject, JSExport>

@property (nonatomic, readonly) BOOL isReachable;
@property (nonatomic, readonly) BOOL isViaWiFi;
@property (nonatomic, readonly, nonnull) OMAppNetworkType type;

@end


NS_SWIFT_NAME(AppNetworkExport)
@interface OMAppNetworkExport : NSObject <OMAppNetworkExport>

@property (nonatomic, nonnull) OMAppNetworkType type;

@end
