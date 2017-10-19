//
//  OMWebViewNavigationBarInfo.m
//  OMKit
//
//  Created by mlibai on 2017/10/12.
//

#import "OMWebViewManagerNavigationBar.h"
#import "OMWebViewManager.h"

#if DEBUG
/**
 Debug 环境下，该宏创建一个 WKWebView 执行 JS 代码的方法 ·evaluateJavaScript· 的第二个参数的回调。
 Release 环境下，该宏创建一个 nil 。
 */
#define JS_COMPLETION_HANDLER(aJavaScriptString)  (^(id _Nullable result, NSError * _Nullable error) { if (error != nil) { NSLog(@"[JavaScript Error] {\n\tCode: `%@`, \n\tError: %@\n}", aJavaScriptString, error); } })
#else
#define JS_COMPLETION_HANDLER(...) nil
#endif

@implementation OMWebViewManagerNavigationBar {
    __weak WKWebView *_webView;
}

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor isHidden:(BOOL)isHidden {
    self = [super init];
    if (self != nil) {
        _title              = [title copy];
        _titleColor         = titleColor;
        _backgroundColor    = backgroundColor;
        _isHidden           = isHidden;
    }
    return self;
}

- (void)webViewWasReady:(WKWebView *)webView {
    _webView = webView;
    
    NSString *js = [NSString stringWithFormat:@"window.omApp.navigation.bar.setTitle(%@, false); "
                    "window.omApp.navigation.bar.setTitleColor(%@, false); "
                    "window.omApp.navigation.bar.setBackgroundColor(%@, false); "
                    "window.omApp.navigation.bar.setHidden(%@, false, false);",
                    OMJavaScriptCodeForNSString(_title),
                    OMJavaScriptCodeForUIColor(_titleColor),
                    OMJavaScriptCodeForUIColor(_backgroundColor),
                    OMJavaScriptCodeForBOOL(_isHidden)];
    [_webView evaluateJavaScript:js completionHandler:JS_COMPLETION_HANDLER(js)];
}


- (void)setTitle:(NSString *)title {
    [self setTitle:title needsSync:YES];
}

- (void)setTitle:(NSString *)title needsSync:(BOOL)needsSync {
    if (_title != title) {
        _title = [title copy];
        if (!needsSync) {
            return;
        }
        NSString *js = [NSString stringWithFormat:@"window.omApp.navigation.bar.setTitle(%@, false);", OMJavaScriptCodeForNSString(_title)];
        [_webView evaluateJavaScript:js completionHandler:JS_COMPLETION_HANDLER(js)];
    }
}


- (void)setTitleColor:(UIColor *)titleColor {
    [self setTitleColor:titleColor needsSync:YES];
}

- (void)setTitleColor:(UIColor *)titleColor needsSync:(BOOL)needsSync {
    if (_titleColor != titleColor) {
        _titleColor = [titleColor copy];
        if (!needsSync) {
            return;
        }
        NSString *js = [NSString stringWithFormat:@"window.omApp.navigation.bar.setTitleColor(%@, false);", OMJavaScriptCodeForUIColor(_titleColor)];
        [_webView evaluateJavaScript:js completionHandler:JS_COMPLETION_HANDLER(js)];
    }
}


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self setBackgroundColor:backgroundColor needsSync:YES];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor needsSync:(BOOL)needsSync {
    if (![_backgroundColor isEqual:backgroundColor]) {
        _backgroundColor = backgroundColor;
        if (!needsSync) {
            return;
        }
        NSString *js = [NSString stringWithFormat:@"window.omApp.navigation.bar.setBackgroundColor(%@, false);", OMJavaScriptCodeForUIColor(_backgroundColor)];
        [_webView evaluateJavaScript:js completionHandler:JS_COMPLETION_HANDLER(js)];
    }
}


- (void)setHidden:(BOOL)isHidden {
    [self setHidden:isHidden needsSync:YES];
}

- (void)setHidden:(BOOL)hidden needsSync:(BOOL)needsSync {
    if (_isHidden != hidden) {
        _isHidden = hidden;
        if (!needsSync) {
            return;
        }
        NSString *js = [NSString stringWithFormat:@"window.omApp.navigation.bar.setHidden(%@, false, false);", OMJavaScriptCodeForBOOL(_isHidden)];
        [_webView evaluateJavaScript:js completionHandler:JS_COMPLETION_HANDLER(js)];
    }
}

@end
