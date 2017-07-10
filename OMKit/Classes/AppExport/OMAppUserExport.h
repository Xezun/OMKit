//
//  AppUserExport.h
//  OCJSCore
//
//  Created by mlibai on 2017/6/16.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JavaScriptCore;


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

NS_SWIFT_NAME(AppUserExportProtocol)
@protocol OMAppUserExport <NSObject, JSExport>
@property (nonatomic, readonly) BOOL isOnline;
@property (nonatomic, copy, nullable, readonly) NSString *id;
@property (nonatomic, copy, nullable, readonly) NSString *name;
@property (nonatomic, copy, nullable, readonly) NSString *type;
@property (nonatomic, copy, nullable, readonly) NSString *token __deprecated;
@property (nonatomic, readonly) NSInteger coin;
@end

NS_SWIFT_NAME(AppUserTypeExport)
@interface OMAppUserTypeExport : NSObject <OMAppUserTypeExport>
@end

NS_SWIFT_NAME(AppUserExport)
@interface OMAppUserExport : NSObject <OMAppUserExport>
@property (nonatomic, copy, nullable) NSString *id;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *type;
@property (nonatomic, copy, nullable) NSString *token;
@property (nonatomic) NSInteger coin;
@end
