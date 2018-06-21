//
//  UIImage+XZKit.h
//  XZKit
//
//  Created by mlibai on 2017/10/30.
//

#import <UIKit/UIKit.h>
#import <XZKit/UIColor+XZKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XZKit)

/// 读取 XZKit 中的资源库图片。
///
/// @param name 图片名字
/// @param traitCollection UITraitCollection
/// @return UIImage
+ (nullable UIImage *)XZKit:(NSString *)name compatibleWithTraitCollection:(nullable UITraitCollection *)traitCollection NS_SWIFT_NAME(init(XZKit:compatibleWith:));

/// 读取 XZKit 中的资源库图片。
///
/// @param name 图片名称
/// @return UIImage
+ (nullable UIImage *)XZKit:(NSString *)name NS_SWIFT_NAME(init(XZKit:));

@end


@interface UIImage (XZKitDrawing)

/// 根据指定条件绘制图片。
/// @note 该方法绘制的图片不会被缓存。
///
/// @param fillColor 填充颜色。
/// @param borderColor 边线颜色。
/// @param borderWidth 边线粗细。
/// @param cornerRadius 圆角大小。
/// @param roundCorners 圆角数。
/// @param imageSize 图片大小。
/// @return 绘制的图片。
+ (nullable UIImage *)xz_imageWithFillColor:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners size:(CGSize)imageSize NS_SWIFT_NAME(init(fillColor:borderColor:borderWidth:cornerRadius:roundCorners:size:));

@end




@interface UIImage (XZKitColor)

#pragma mark - 指定大小

/// 获取以绘制（缓存中）的纯色图片。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param borderWidth 图片边框粗细。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:borderWidth:cornerRadius:roundCorners:size:));

/// 获取以绘制（缓存中）的纯色图片，默认全圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param borderWidth 图片边框粗细。
/// @param cornerRadius 图片圆角半径。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:borderWidth:cornerRadius:size:));

/// 获取以绘制（缓存中）的纯色图片，默认无圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param borderWidth 图片边框粗细。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:borderWidth:size:));

/// 获取以绘制（缓存中）的纯色图片，默认无圆角，边框1像素。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:size:));

/// 获取以绘制（缓存中）的纯色图片，默认无圆角，无边框。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:size:));

/// 获取以绘制（缓存中）的纯色图片，默认边框1像素。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:cornerRadius:roundCorners:size:));

/// 获取以绘制（缓存中）的纯色图片，默认无边框。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:cornerRadius:roundCorners:size:));

/// 获取以绘制（缓存中）的纯色图片，默认全圆角，无边框。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param cornerRadius 图片圆角半径。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:cornerRadius:size:));

// -borderWidth/borderColor/roundCorners/cornerRadius
// See: -roundCorners/cornerRadius/borderWidth/borderColor

/// 获取以绘制（缓存中）的纯色图片，默认全圆角，边框1像素。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param cornerRadius 图片圆角半径。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:cornerRadius:size:));

#pragma mark - 可拉伸大小的图片

/// 获取以绘制（缓存中）的纯色 resizable 图片。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param borderWidth 图片边框粗细。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners NS_SWIFT_NAME(init(filled:borderColor:borderWidth:cornerRadius:roundCorners:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认边框1像素。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners NS_SWIFT_NAME(init(filled:borderColor:cornerRadius:roundCorners:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认无边框。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners NS_SWIFT_NAME(init(filled:cornerRadius:roundCorners:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认无边框，全圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param cornerRadius 图片圆角半径。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor cornerRadius:(CGFloat)cornerRadius NS_SWIFT_NAME(init(filled:cornerRadius:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认无边框，无圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor NS_SWIFT_NAME(init(filled:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认全圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param borderWidth 图片边框粗细。
/// @param cornerRadius 图片圆角半径。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius NS_SWIFT_NAME(init(filled:borderColor:borderWidth:cornerRadius:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认无圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param borderWidth 图片边框粗细。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor borderWidth:(CGFloat)borderWidth NS_SWIFT_NAME(init(filled:borderColor:borderWidth:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认无圆角，边框1像素。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor NS_SWIFT_NAME(init(filled:borderColor:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认全圆角，边框1像素。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColor 填充图片的颜色对象。
/// @param borderColor 图片边框的颜色对象。
/// @param cornerRadius 图片圆角半径。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilled:(nullable UIColor *)fillColor borderColor:(nullable UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius NS_SWIFT_NAME(init(filled:borderColor:cornerRadius:));

@end



@interface UIImage (XZKitColorValue)

#pragma mark - 指定大小

/// 获取以绘制（缓存中）的纯色图片。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param borderWidth 图片边框粗细。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:borderWidth:cornerRadius:roundCorners:size:));

/// 获取以绘制（缓存中）的纯色图片，默认全圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param borderWidth 图片边框粗细。
/// @param cornerRadius 图片圆角半径。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:borderWidth:cornerRadius:size:));

/// 获取以绘制（缓存中）的纯色图片，默认无圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param borderWidth 图片边框粗细。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue borderWidth:(CGFloat)borderWidth size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:borderWidth:size:));

/// 获取以绘制（缓存中）的纯色图片，默认无圆角，边框1像素。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:size:));

/// 获取以绘制（缓存中）的纯色图片，默认无圆角，无边框。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:size:));

/// 获取以绘制（缓存中）的纯色图片，默认边框1像素。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:cornerRadius:roundCorners:size:));

/// 获取以绘制（缓存中）的纯色图片，默认无边框。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:cornerRadius:roundCorners:size:));

/// 获取以绘制（缓存中）的纯色图片，默认全圆角，无边框。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param cornerRadius 图片圆角半径。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue cornerRadius:(CGFloat)cornerRadius size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:cornerRadius:size:));

// -borderWidth/borderColor/roundCorners/cornerRadius
// See: -roundCorners/cornerRadius/borderWidth/borderColor

/// 获取以绘制（缓存中）的纯色图片，默认边框1像素，全圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param cornerRadius 图片圆角半径。
/// @param imageSize 图片大小。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue cornerRadius:(CGFloat)cornerRadius size:(CGSize)imageSize NS_SWIFT_NAME(init(filled:borderColor:cornerRadius:size:));

#pragma mark - 可拉伸大小的图片

/// 获取以绘制（缓存中）的纯色 resizable 图片。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param borderWidth 图片边框粗细。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners NS_SWIFT_NAME(init(filled:borderColor:borderWidth:cornerRadius:roundCorners:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认边框1像素。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners NS_SWIFT_NAME(init(filled:borderColor:cornerRadius:roundCorners:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认无边框。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param cornerRadius 图片圆角半径。
/// @param roundCorners 图片的圆角。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue cornerRadius:(CGFloat)cornerRadius roundCorners:(UIRectCorner)roundCorners NS_SWIFT_NAME(init(filled:cornerRadius:roundCorners:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认无边框，全圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param cornerRadius 图片圆角半径。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue cornerRadius:(CGFloat)cornerRadius NS_SWIFT_NAME(init(filled:cornerRadius:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认无边框，无圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue NS_SWIFT_NAME(init(filled:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认全圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param borderWidth 图片边框粗细。
/// @param cornerRadius 图片圆角半径。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius NS_SWIFT_NAME(init(filled:borderColor:borderWidth:cornerRadius:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认无圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param borderWidth 图片边框粗细。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue borderWidth:(CGFloat)borderWidth NS_SWIFT_NAME(init(filled:borderColor:borderWidth:));

/// 获取以绘制（缓存中）的纯色 resizable 图片，默认无圆角，边框1像素。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue NS_SWIFT_NAME(init(filled:borderColor:));


/// 获取以绘制（缓存中）的纯色 resizable 图片，默认边框1像素，全圆角。
/// @note 使用 XZCacheManager 进行缓存。
///
/// @param fillColorValue 填充图片的颜色值。
/// @param borderColorValue 图片边框的颜色值。
/// @param cornerRadius 图片圆角半径。
/// @return 绘制的图片或存在与缓存中已绘制的图片对象。
+ (nullable UIImage *)xz_imageFilledWithColorValue:(XZColorValue)fillColorValue borderColorValue:(XZColorValue)borderColorValue cornerRadius:(CGFloat)cornerRadius NS_SWIFT_NAME(init(filled:borderColor:cornerRadius:));

@end











@interface UIImage (XZKitBlending)

/// 混合。改变图片透明度。
///
/// @param alpha 透明度
/// @return UIImage
- (nullable UIImage *)xz_imageWithBlendingAlpha:(CGFloat)alpha NS_SWIFT_NAME(blending(_:));

/// 该方法首先从缓存（XZCacheManager）中获取图片，如果没有获取到，则从资源库中获取，应用透明度并缓存。
///
/// @param name 图片名字
/// @param alpha 透明度
/// @return UIImage
+ (nullable UIImage *)xz_imageNamed:(NSString *)name blendingAlpha:(CGFloat)alpha NS_SWIFT_NAME(init(named:blending:));


/// 混合，重新渲染图片颜色。
///
/// @param tintColor 图片渲染色。
/// @return 渲染后的图片。
- (nullable UIImage *)xz_imageWithBlendingColor:(UIColor *)tintColor NS_SWIFT_NAME(blending(_:));

/// 按指定颜色渲染后的资源图片。
///
/// @param name 资源图片名。
/// @param tintColor 渲染色。
/// @return 渲染后的资源图片。
+ (nullable UIImage *)xz_imageNamed:(NSString *)name blendingColor:(UIColor *)tintColor NS_SWIFT_NAME(init(named:blending:));

@end






@interface UIImage (XZKitFiltering)

/// 滤镜。改变图片亮度。
///
/// @param brightness 图片亮度，0 为正常，-1.0 为最暗，1.0 为最亮。
/// @return UIImage
- (nullable UIImage *)xz_imageWithFilteringBrightness:(CGFloat)brightness NS_SWIFT_NAME(filtering(_:));

/// 该方法首先从缓存（XZCacheManager）中获取图片，如果没有获取到，则从资源库中获取，应用亮度滤镜并缓存。
///
/// @param name 图片名字
/// @param brightness 图片亮度，0 为正常，-1.0 为最暗，1.0 为最亮。
/// @return UIImage
+ (nullable UIImage *)xz_imageNamed:(NSString *)name filteringBrightness:(CGFloat)brightness NS_SWIFT_NAME(init(named:filtering:));

@end





NS_ASSUME_NONNULL_END
