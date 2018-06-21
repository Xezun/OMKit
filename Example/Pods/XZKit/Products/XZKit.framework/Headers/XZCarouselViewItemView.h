//
//  XZCarouselViewItemView.h
//  XZImageCarousel
//
//  Created by mlibai on 2017/12/25.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZCarouselView;

/// 负责显示、缩放的图片。
NS_SWIFT_NAME(CarouselView.ItemView) @interface XZCarouselViewItemView : UIScrollView

/// 展示的视图。
@property (nonatomic, weak, nullable) UIView *contentView;

/// 调整 contentView 的布局。
/// @note 如果视图处于缩放状态，那么优化内容视图的显示位置：如果内容视图比可视区域小，内容视图放置到可视区域中央；如果内容比可视区域大，则保证可视区域始终在内容范围内。
/// @note 如果视图处于正常状态，那么优化内容的大小和位置：如果内容比可视区域小，则按照内容的实际大小放中央显示；如果内容比可视区域大，则将内容保持其宽高比，缩小到区域可以完全显示。
/// @note 缩放时，可调用 setNeedsLayout/layoutIfNeeded 方法将 contentView 的位置调整到最佳位置。
- (void)layoutSubviews;

@end
