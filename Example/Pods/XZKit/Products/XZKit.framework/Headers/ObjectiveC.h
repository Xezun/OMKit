//
//  ObjectiveC.h
//  XZKit
//
//  Created by mlibai on 2018/4/14.
//  Copyright © 2018年 mlibai. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 标识 XZKit 是否为 DEBUG 模式。
///
/// @return YES or NO.
UIKIT_EXTERN BOOL XZKitIsDebugMode(void) NS_SWIFT_UNAVAILABLE("Use XZKit.isDebugMode instead.");

/// 将指定类的 方法1 与 方法2 的方法体互换。
/// @note 如果 方法1 不存在（包括继承自父类但是没有重写的方法），则给类增加一个与方法2相同方法体的方法。
///
/// @param aClass 需要替换方法体的类。
/// @param selector1 待交换方法体的方法。
/// @param selector2 被交换方法体的方法。
UIKIT_EXTERN void xz_objc_class_exchangeMethodImplementations(Class _Nonnull aClass, SEL _Nonnull selector1, SEL _Nonnull selector2) NS_SWIFT_NAME(objc_class_exchangeMethodImplementations(_:_:_:));

/// 获取当前时间戳，精确到微秒。
/// @note 在 Swift 中，请使用 `TimeInterval.since1970` 代替。
///
/// @return 单位为秒，小数点后为微秒。
FOUNDATION_EXTERN NSTimeInterval xz_timestamp(void) NS_REFINED_FOR_SWIFT;

/// 输出信息到控制台，末尾自动换行。不附加任何其它信息。
///
/// @param format 输出格式。
/// @param ...    参数列表。
FOUNDATION_EXTERN void xz_print(NSString * _Nonnull format, ...) NS_FORMAT_FUNCTION(1, 2) NS_NO_TAIL_CALL NS_SWIFT_UNAVAILABLE("Use Swift.print instead.");

/// 输出信息到控制台，末尾自动换行。不附加任何其它信息。
///
/// @param format 输出格式。
/// @param args   参数列表指针。
FOUNDATION_EXTERN void xz_print_v(NSString * _Nonnull format, va_list _Nonnull args) NS_FORMAT_FUNCTION(1, 0) NS_NO_TAIL_CALL NS_SWIFT_UNAVAILABLE("Use Swift.print instead.");

/// 仅在 XZKitDEBUG 模式下，才在控制台输出指定信息。
/// @note 配置 DEBUG 模式：Edit Scheme -> Arguments Passed On Launch -> 添加 **-XZKitDEBUG** 启动参数。
/// @note 此函数为声明，实际使用的为 __XZLog 函数。
///
/// @param format 输出格式。
/// @param ...    参数列表。
FOUNDATION_EXTERN void XZLog(NSString * const _Nonnull format, ...) NS_FORMAT_FUNCTION(1, 2) NS_SWIFT_UNAVAILABLE("Use Swift XZKit.XZLog instead.");

/// 仅在 XZKitDEBUG 模式下，才在控制台输出指定信息，XZLog 的 verbose 模式。
/// @note 配置 DEBUG 模式：Edit Scheme -> Arguments Passed On Launch -> 添加 **-XZKitDEBUG** 启动参数。
/// @note 请使用宏定义 XZLog ，其该函数会编译到正式代码中。
/// @note 该函数与 Swift 版本实现方式不同。
///
/// @param filePath __FILE__
/// @param line     __LINE__
/// @param function __func__
/// @param format   输出格式。
/// @param ...      参数列表。
FOUNDATION_EXTERN void XZLogv(const char * const filePath, int const line, const char * const function, NSString * const _Nonnull format, ...) NS_FORMAT_FUNCTION(4, 5) NS_SWIFT_UNAVAILABLE("Use Swift XZKit.XZLog instead.");

/// XZLog 原型只起注释的作用。实际执行的是 _XZLog 函数。
#undef XZLog
#define XZLog(format, ...) XZLogv(__FILE__, (int)__LINE__, __func__, format, ##__VA_ARGS__)





