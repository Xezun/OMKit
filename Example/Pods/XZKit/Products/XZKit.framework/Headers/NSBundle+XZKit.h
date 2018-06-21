//
//  NSBundle+XZKit.h
//  XZKit
//
//  Created by mlibai on 2017/10/31.
//

#import <Foundation/Foundation.h>

@interface NSBundle (XZKit)

/// XZKit Bundle.
@property (class, nonatomic, readonly, nonnull) NSBundle *XZKitBundle NS_SWIFT_NAME(XZKit);

/// 构建版本。CFBundleVersion，默认 0。
@property (nonatomic, readonly, nonnull) NSString *xz_buildVersionString NS_SWIFT_NAME(buildVersionString);

/// 发行版本。CFBundleShortVersionString，默认 0。
@property (nonatomic, readonly, nonnull) NSString *xz_shortVersionString NS_SWIFT_NAME(shortVersionString);

/// App 名称。CFBundleDisplayName，默认空字符串。
@property (nonatomic, readonly, nonnull) NSString *xz_displayName NS_SWIFT_NAME(displayName);

@end
