//
//  UIColor+XZKit.h
//  XZKit
//
//  Created by mlibai on 2017/10/24.
//

#import <UIKit/UIKit.h>

/// 用十六进制值的整数表示颜色 RGBA 值，如 0xFF0000FF 。
/// @note UInt32 整数。
typedef UInt32 XZColorValue  NS_SWIFT_NAME(ColorValue);

@interface UIColor (XZKit)

@property (nonatomic, readonly) XZColorValue xz_rgbaValue NS_SWIFT_NAME(rgbaValue);

/// 通过十六进制数表示的颜色值字符串，创建 UIColor 。
/// @note 1. 字符串必须以 # 开头。
/// @note 2. 颜色值仅可以是 3、6、8 位十六进制数。
/// @note 3. 如果不符合以上要求，则返回的是 clearColor 。
/// @note 4. 字符串最多只取前 9 位有效值。

/// @param string a string like #1A2B3CFF
/// @return UIColor
+ (nonnull UIColor *)xz_colorWithString:(nonnull NSString *)string NS_SWIFT_NAME(init(_:));

/// 通过一个用十六进制数表示的 RGBA 颜色值创建 UIColor 对象。
///
/// @note 数字必须是 RGBA 值
///
/// @param colorValue RGBA
/// @return UIColor
+ (nonnull UIColor *)xz_colorWithColorValue:(XZColorValue)colorValue NS_SWIFT_NAME(init(_:));

/// 通过用 0 ~ 255 表示的颜色通道分量值，创建 UIColor 。
///
/// @param redValue The red value, 0 ~ 255 .
/// @param greenValue The green value, 0 ~ 255 .
/// @param blueValue The blue value, 0 ~ 255 .
/// @param alphaValue The alpha value, 0 ~ 255 .
/// @return UIColor
+ (nonnull UIColor *)xz_colorWithRedValue:(XZColorValue)redValue greenValue:(XZColorValue)greenValue blueValue:(XZColorValue)blueValue alphaValue:(XZColorValue)alphaValue NS_SWIFT_NAME(init(Red:Green:Blue:Alpha:));

@end
