//
//  XZAppRedirectable.h
//  XZKit
//
//  Created by mlibai on 2018/6/12.
//  Copyright © 2018年 mlibai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XZAppRedirection;

@protocol XZAppRedirectable <NSObject>

- (void)xz_setNeedsRedirectWithRedirection:(nullable XZAppRedirection *)redirection NS_SWIFT_NAME(setNeedsRedirect(with:));

@end
