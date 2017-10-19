//
//  OMWebViewUserInfo.m
//  OMKit
//
//  Created by mlibai on 2017/10/12.
//

#import "OMWebViewManagerUser.h"
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


OMWebViewManagerUserType const OMWebViewManagerUserTypeVisitor    = @"visitor";
OMWebViewManagerUserType const OMWebViewManagerUserTypeGoogle     = @"google";
OMWebViewManagerUserType const OMWebViewManagerUserTypeFacebook   = @"facebook";
OMWebViewManagerUserType const OMWebViewManagerUserTypeTwitter    = @"twitter";
OMWebViewManagerUserType const OMWebViewManagerUserTypeWhatsapp   = @"whatsapp";



@implementation OMWebViewManagerUser {
    __weak WKWebView *_webView;
}

- (instancetype)initWithID:(NSString *)id name:(NSString *)name type:(OMWebViewManagerUserType)type coin:(NSInteger)coin {
    self = [super init];
    if (self != nil) {
        _id   = id.copy;
        _name = name.copy;
        _type = type.copy;
        _coin = coin;
    }
    return self;
}

- (void)webViewWasReady:(WKWebView *)webView {
    _webView = webView;
    
    NSString *js = [NSString stringWithFormat:@
                    "window.omApp.currentUser.setName(%@);"
                    "window.omApp.currentUser.setType(%@);"
                    "window.omApp.currentUser.setCoin(%ld);"
                    "window.omApp.currentUser.setID(%@);",
                    OMJavaScriptCodeForNSString(_name),
                    OMJavaScriptCodeForNSString(_type),
                    (long)_coin,
                    OMJavaScriptCodeForNSString(_id)];
    [_webView evaluateJavaScript:js completionHandler:JS_COMPLETION_HANDLER(js)];
}

- (void)setName:(NSString *)name {
    if (_name != name) {
        _name = [name copy];
        
        NSString *js = [NSString stringWithFormat:@"window.omApp.currentUser.setName(%@);", OMJavaScriptCodeForNSString(_name)];
        [_webView evaluateJavaScript:js completionHandler:JS_COMPLETION_HANDLER(js)];
    }
}

- (void)setType:(OMWebViewManagerUserType)type {
    if (_type != type) {
        _type = [type copy];
        
        NSString *js = [NSString stringWithFormat:@"window.omApp.currentUser.setType(%@);", OMJavaScriptCodeForNSString(_type)];
        [_webView evaluateJavaScript:js completionHandler:JS_COMPLETION_HANDLER(js)];
    }
}

- (void)setCoin:(NSInteger)coin {
    if (_coin != coin) {
        _coin = coin;
        
        NSString *js = [NSString stringWithFormat:@"window.omApp.currentUser.setCoin(%ld);", (long)_coin];
        [_webView evaluateJavaScript:js completionHandler:JS_COMPLETION_HANDLER(js)];
    }
}

@end
