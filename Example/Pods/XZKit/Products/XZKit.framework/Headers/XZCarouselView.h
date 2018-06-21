//
//  XZCarouselView.h
//  XZCarouselView
//
//  Created by mlibai on 2017/2/13.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XZCarouselView, XZCarouselViewItemView;

@class UIScrollView, UIPageControl;


/// 轮播图的代理方法。
NS_SWIFT_NAME(CarouselViewDelegate) @protocol XZCarouselViewDelegate <NSObject>
@optional
/// XZCarouselView 调用此方法来获取待显示的视图的数量。
/// @note 如果视图数量发生改变，需调用 reloadViews 来重新加载视图。
///
/// @param carouselView 调用此方法的 XZCarouselView 对象。
/// @return 待显示的视图数量。
- (NSInteger)numberOfItemsInCarouselView:(XZCarouselView *)carouselView;

/// XZCarouselView 使用此方法来获取指定索引位置的视图。
/// @note 此方法调用时，视图未必一定正在显示，一般是上一个视图或下一个视图。
/// @note 由于三图轮播机制，参数中的 reusingView 不表示指定索引的历史视图，而表示该位置上的上一个视图。
/// @note 无限轮播模式下，因为重用机制，需保证至少有 3 个可复用的视图，才能使轮播连贯。
///
/// @param carouselView 调用此方法的 XZCarouselView 对象。
/// @param index 指定索引位置。
/// @param reusingView 重用的视图。
/// @return 待显示的视图。
- (nullable UIView *)carouselView:(XZCarouselView *)carouselView viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)reusingView;

/// 当 XZCarouselView 主动切换到指定索引位置的视图时，此方法会被调用。
/// @note 自动轮播或用户手势引起索引变化会调用此方法。
/// @note 设置索引不会调用此方法。
///
/// @param carouselView 调用此方法的 XZCarouselView 对象。
/// @param index 视图所在的索引。
- (void)carouselView:(XZCarouselView *)carouselView didShowViewAtIndex:(NSInteger)index;

/// 当用户缩放了视图时，此方法会被调用。
///
/// @param carouselView 调用此方法的 XZCarouselView 对象。
/// @param view 正在被缩放的视图。
- (void)carouselViewDidBeginZooming:(XZCarouselView *)carouselView withView:(nullable UIView *)view;

/// 指定被缩放的视图。
/// @note 只有正在显示的视图可以被缩放。
///
/// @param carouselView 调用此方法的 XZCarouselView 对象。
- (nullable UIView *)viewForZoomingInCarouselView:(XZCarouselView *)carouselView;

/// 当视图缩放时此方法会被调用。
///
/// @param carouselView 调用此方法的 XZCarouselView 对象。
- (void)carouselViewDidZoom:(XZCarouselView *)carouselView;

/// 当视图停止缩放状态时，此方法会被调用。
///
/// @param carouselView 调用此方法的 XZCarouselView 对象。
/// @param scale 当前缩放比。
- (void)carouselViewDidEndZooming:(XZCarouselView *)carouselView atScale:(CGFloat)scale;

@end

/// XZCarouselView 中的动画效果的默认时长。
UIKIT_EXTERN NSTimeInterval const XZCarouselViewAnimationDuration NS_SWIFT_NAME(CarouselView.AnimationDuration);

/// 自动轮播的方向。
typedef NS_ENUM(NSInteger, XZCarouselViewScrollDirection) {
    /// 正向自动轮播。
    XZCarouselViewScrollDirectionForward = 1,
    /// 反向自动轮播。
    XZCarouselViewScrollDirectionBackward = -1
} NS_SWIFT_NAME(CarouselView.ScrollDirection);

/// XZCarouselView 轮播视图。
/// @note 使用三图轮播机制，并支持缩放功能。
/// @note 支持自动轮播，以及无限轮播（首位相连）。
/// @note 使用代理获取轮播的视图，并且提供了重用机制，降低资源消耗。
NS_SWIFT_NAME(CarouselView) @interface XZCarouselView : UIView <UIScrollViewDelegate>

/// 在 XZCarouselView 中处理水平滚动的 UIScrollView 。
@property (strong, nonatomic, nonnull) UIScrollView *scrollView;

/// 当前正在显示的视图的索引。
/// @note 如果没有视图，返回 NSNotFound 。
@property (nonatomic) NSInteger currentIndex;

/// 是否无限轮播。默认 YES 。
/// @note 设置此值，会重置轮播方向为 XZCarouselViewScrollDirectionForward 。
@property (nonatomic, getter=isWrapped) BOOL wrapped;

/// 设置滚动到指定索引位置的视图。
/// @note 主动设置索引不会触发代理方法。
/// @note 该方法不检查 newIndex 的合法性，调用此方法时，务必保证其值正确。
///
/// @param newIndex 待显示的视图的索引
/// @param animated 是否动画切换
- (void)setCurrentIndex:(NSInteger)newIndex animated:(BOOL)animated;

/// 双击缩放/恢复缩放手势。
/// @note 如果当前视图已经被缩放，则双击手势为恢复默认状态，否则双击手势为放大到双击点到最大缩放比。
/// @note 缩放时，自动轮播会暂停。
@property (strong, nonatomic, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

/// XZCarouselView 显示的内容依赖于代理，设置代理会自动刷新视图。
@property (nonatomic, weak) id<XZCarouselViewDelegate> delegate;

/// 最小缩放倍数，默认 1.0 。
@property(nonatomic) CGFloat minimumZoomScale;

/// 最大缩放倍数，默认 1.0 。
@property(nonatomic) CGFloat maximumZoomScale;

/// 当前缩放倍数。
@property(nonatomic) CGFloat zoomScale;

/// 自动轮播时间间隔，0 表示不自动轮播。
/// @note 建议时长大于 1 秒，自动轮播动画时间，不包括在此时间内。
/// @note 缩放时，自动轮播会暂停。
/// @note 非无限轮播模式下，自动轮播到末尾会自动返回首个并重新开始。
@property (nonatomic) NSTimeInterval timeInterval;

/// 自动轮播方向，默认 forward 。
/// @note 无限轮播时，设置此值会影响轮播方向。
/// @note 非无限轮播时，此属性会自动改变，即正向轮播到最后一个就会开始逆向轮播。
@property (nonatomic) XZCarouselViewScrollDirection scrollDirection;

/// 刷新视图。
- (void)reloadViews;

/// 当前所显示的视图数量。
@property (nonatomic, readonly) NSInteger numberOfViews;

/// 获取待显示的视图。默认情况下，此方法从代理获取当前 index 所需展示的视图。
///
/// @param itemView 装载视图的容器。
/// @param index 视图的索引位置。
/// @param view 可能可以重用的视图。
/// @return 待显示的视图。
- (nullable UIView *)viewForItemView:(XZCarouselViewItemView *)itemView atIndex:(NSInteger)index reusingView:(nullable UIView *)view;

/// 当指定视图显示时，此方法会被调用。
/// @note 使用 -setCurrentIndex:animated: 方法不会调用此方法。
/// @note 子类在监听所显示的视图发生改变时，除重写此方法外，需要同时重写 -setCurrentIndex:animated: 方法。
///
/// @param index 当前正显示的视图的索引。
- (void)didShowViewAtIndex:(NSInteger)index;

/// 查询待缩放的视图。返回 nil 将不缩放。
/// @note 默认返回当前正在显示的视图。
///
/// @return 被缩放的视图。
- (nullable UIView *)viewForZooming;

/// 已经开始缩放视图。
/// @note 缩放的视图即是当前正显示的视图。
///
/// @param view 被缩放的视图。
- (void)didBeginZoomingWithView:(nullable UIView *)view;

/// 缩放进行中。
- (void)didZoom;

/// 缩放已结束，以及最终缩放的比例。
///
/// @param scale 最终缩放比。
- (void)didEndZoomingAtScale:(CGFloat)scale;

/// 自动布局时，视图将自动调整子视图。
- (void)layoutSubviews;

/// XZCarouselView 重写了此方法。子类重写必须调用父类方法。
/// @note 当 XZCarouselView 添加到父视图时，才会处理自动轮播。
/// @note 当 XZCarouselView 从父视图移除时，将会自动停止轮播。
- (void)didMoveToSuperview;

// UIScrollViewDelegate Methods.

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidZoom:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view;
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale;
/// 默认返回 NO 。
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;
- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
