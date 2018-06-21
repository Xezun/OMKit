//
//  XZAppRedirection.h
//  XZKit
//
//  Created by mlibai on 2018/6/12.
//  Copyright © 2018年 mlibai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZAppRedirectable;

NS_SWIFT_NAME(AppRedirection)
/// App重定向信息，单次重定向信息共享一个对象。
@interface XZAppRedirection: NSObject

/// 当前重定向值，重定向到达指定的控制器时，此属性可能不同。
@property (nonatomic, readonly, nonnull) id currentValue;

/// 所有重定向值。
@property (nonatomic, readonly, copy, nonnull) NSArray *values;

- (nonnull instancetype)init NS_UNAVAILABLE;

/// 从指定的控制器开始重定向。
///
/// @param values 重定向值。
/// @param viewController 重定向开始的控制器。
+ (void)redirectWithValues:(nonnull NSArray *)values viewController:(nullable UIViewController<XZAppRedirectable> *)viewController NS_SWIFT_NAME(redirect(with:viewController:));

/// 从根控制器开始重定向。
///
/// @param values 重定向值。
+ (void)redirectWithValues:(nonnull NSArray *)values;

/// 将重定向发送到下一个控制器，如果重定向已到最后，本方法返回 NO 。
///
/// @param nextViewController 下一控制器。
/// @return 是否发送重定向。
- (BOOL)redirectToNextViewController:(nullable UIViewController<XZAppRedirectable> *)nextViewController NS_SWIFT_NAME(redirect(to:));

@end


