//
//  OMWebViewNavigationBarInfo.h
//  OMKit
//
//  Created by mlibai on 2017/10/12.
//

#import <Foundation/Foundation.h>
@class WKWebView;

NS_SWIFT_NAME(WebViewNavigationBarInfo)
@interface OMWebViewNavigationBarInfo : NSObject

@property (nonatomic, setter=setHidden:) BOOL isHidden;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *backgroundColor;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor isHidden:(BOOL)isHidden NS_DESIGNATED_INITIALIZER;


- (void)webViewWasReady:(WKWebView *)webView;

- (void)setHidden:(BOOL)isHidden needsSync:(BOOL)needsSync;
- (void)setTitle:(NSString *)title needsSync:(BOOL)needsSync;
- (void)setTitleColor:(UIColor *)titleColor needsSync:(BOOL)needsSync;
- (void)setBackgroundColor:(UIColor *)backgroundColor  needsSync:(BOOL)needsSync;

@end
