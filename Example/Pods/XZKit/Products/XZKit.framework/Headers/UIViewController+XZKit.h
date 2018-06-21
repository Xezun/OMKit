//
//  UIViewController+XZKit.h
//  XZKit
//
//  Created by mlibai on 2017/10/16.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIControl;

@interface UIViewController (XZKit)

+ (void)load;

/// 此属性用于标识控制器是否正在显示。当且仅当控制器生命周期在 [viewDidAppear, viewWillDisappear) 之间时，此属性为 YES 。
///
/// @note 此属性的意义在于，当此属性为 YES 时，可以直接在此控制器上进行转场。
/// @note 当控制器 viewDidAppear 方法被调用时，此属性已为 YES，但在 XZViewControllerEventBeforeViewDidAppear 事件中，此属性为 NO。
/// @note 当控制器 viewWillDisappear 方法被调用时，此属性已为 NO，但在 XZViewControllerEventBeforeViewWillDisappear 事件中，此属性为 YES。
@property (nonatomic, readonly) BOOL xz_isAppearing NS_SWIFT_NAME(isAppearing);

@end
