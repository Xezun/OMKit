//
//  XZImageCarouselView.h
//  XZImageCarousel
//
//  Created by mlibai on 2017/12/27.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import "XZCarouselView.h"

@class XZImageCarouselView;

/// !!! 本地图片自定义显示大小没有处理。

NS_SWIFT_NAME(ImageCarouselViewDelegate) @protocol XZImageCarouselViewDelegate <XZCarouselViewDelegate>

@optional

/// 如果展示的为网络图片，那么 XZImageCarouselView 将调用此方法来来下载网络图片。
///
/// @note 请在图片下载完成并已赋值给 imageView 后执行回调。
/// @note 回调参数 preferredImageSize 表示期望的所展示的图片视图的初始大小，如果为CGSizeZero，将按照图片实际大小展示。
/// @note 回调参数 animated 图片视图如果大小发生变化，是否展示动画过渡效果。
/// @note 如果自定义了代理方法 `-viewForItemView:atIndex:reusingView:` ，那么此方法可能不会被调用。
///
/// @param imageCarouselView 调用此方法的 XZImageScrollView 对象。
/// @param imageView 图片视图，默认大小 {68, 68} ，并默认占位图。
/// @param imageURL 图片 URL 。
/// @param completion 图片下载完成后的回调，默认情况下，回调必须执行（关系到视图是否可以被缩放）。
- (void)imageCarouselView:(nonnull XZImageCarouselView *)imageCarouselView imageView:(nonnull UIImageView *)imageView loadImageWithURL:(nonnull NSURL *)imageURL completion:(void (^ _Nonnull)(CGSize preferredImageSize, BOOL animated))completion;

@end

NS_SWIFT_NAME(ImageCarouselView) @interface XZImageCarouselView : XZCarouselView

/// 设置或获取 XZImageCarouselView 所展示本地图片。
/// @note 如果同时设置了网络图片，本地图片将优先显示。
/// @note 设置属性会自动调用 reloadViews 方法。
@property (nonatomic, copy, nullable) NSArray<UIImage *> *images;

/// 设置或获取 XZImageCarouselView 所显示网络图片。
/// @note 如果同时设置了本地图片，本地图片将优先显示。
/// @note 设置属性会自动调用 reloadViews 方法。
@property (nonatomic, copy, nullable) NSArray<NSURL *> *imageURLs;

/// XZImageCarouselView 重写了父类的此方法。
/// XZImageCarouselView 优先以代理返回的结果为准来确定所显示内容的数目。即：
/// 如果没有代理或代理返回了 0，那么 XZImageCarouselView 将根据自身的 images/imageURLs 属性来确定所显示内容的数量。
- (NSInteger)numberOfViews;

/// XZImageCarouselView 重写了父类的此方法。
/// XZImageCarouselView 优先显示代理创建的视图。如果没有代理或代理返回了 nil，则自动创建 UIImageView 来作为图片的展示视图。
- (nullable UIView *)viewForItemView:(nonnull XZCarouselViewItemView *)itemView atIndex:(NSInteger)index reusingView:(nullable UIView *)view;

/// 当 XZImageCarouselView 显示网络图片时，会调用此方法来下载网络图片。
/// @note 如果没有代理或代理没有实现此方法，否则使用原生的网络请求，下载图片并显示。
/// @note 如果代理或子类自定义了显示图片的视图，那么此方法不会被调用，下载并显示网络图片的过程需开发者自行控制。
/// @note 建议派生子类重写此方法，以优化网络图片的缓存和显示效果。
- (void)imageView:(nonnull UIImageView *)imageView loadImageWithURL:(nonnull NSURL *)imageURL completion:(void (^ _Nonnull)(CGSize preferredImageSize, BOOL animated))completion;

@end
