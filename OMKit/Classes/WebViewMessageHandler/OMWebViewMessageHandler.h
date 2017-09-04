//
//  OMApp.h
//  OMKit
//
//  Created by mlibai on 2017/8/31.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JavaScriptCore;
@import WebKit;

NS_ASSUME_NONNULL_BEGIN
@class OMWebViewHTTPRequest, OMWebViewHTTPResponse;

NS_SWIFT_NAME(WebViewMessageHandler)
@interface OMWebViewMessageHandler: NSObject <WKScriptMessageHandler>

@property (nonatomic, weak, nullable, readonly) WKWebView *webView;
@property (nonatomic, weak, nullable) UIViewController *viewController;


/**
 创建一个 OMApp 对象来处理 WKWebView 的消息。需调用 -removeFromWebView 来释放该对象。

 @param webView WKWebView
 @param viewController UIViewController
 @return OMApp
 */
+ (instancetype)messageHandlerForWebView:(WKWebView *)webView viewController:(UIViewController *)viewController;
- (void)removeFromWebView;


- (void)ready:(void (^)())completion;
- (void)login:(void (^)(BOOL success))completion;

- (void)setCurrentTheme:(nonnull NSString *)theme;

- (void)open:(nonnull NSString *)page parameters:(nullable NSDictionary *)parameters;
- (void)present:(nonnull NSString *)url animated:(BOOL)animated completion:(void (^)())completion;

- (void)push:(NSString *)url animated:(BOOL)animated;
- (void)pop:(BOOL)animated;
- (void)popTo:(NSInteger)index animated:(BOOL)animated;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setNavigationBarTitle:(NSString *)title;
- (void)setNavigationBarTitleColor:(UIColor *)titleColor;
- (void)setNavigationBarBackgroundColor:(UIColor *)backgrondColor;

- (void)track:(NSString *)event parameters:(nullable NSDictionary<NSString *, id> *)parameters;

- (void)http:(OMWebViewHTTPRequest *)request completion:(void (^)(OMWebViewHTTPResponse *response))completion;

- (void)document:(NSString *)document numberOfRowsInList:(NSString *)list completion:(void (^)(NSInteger count))completion;
- (void)document:(NSString *)document list:(NSString *)list dataForRowAtIndex:(NSInteger)index completion:(void (^)(NSDictionary<NSString *, id> *data))completion;

- (void)cachedResourceForURL:(NSString *)url resoureType:(NSString *)resoureType downloadIfNotExists:(BOOL)download completion:(void (^)(NSString *resourcePath))completion;

- (void)document:(NSString *)document list:(NSString *)list didSelectRowAtIndex:(NSInteger)index completion:(void (^)())completion;
- (void)document:(NSString *)document elementWasClicked:(NSString *)element data:(id)data completion:(void (^)(BOOL isSelected))completion;

@end



NS_SWIFT_NAME(WebViewHTTPRequest)
@interface OMWebViewHTTPRequest : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *method;
@property (nonatomic, copy, readonly, nonnull) NSString *url;
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, id> *data;
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, NSString *> *headers;

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url data:(NSDictionary<NSString *, id> *)data headers:(NSDictionary<NSString *, NSString *> *)headers;

@end

NS_SWIFT_NAME(WebViewHTTPResponse)
@interface OMWebViewHTTPResponse : NSObject

@property (nonatomic, readonly) NSInteger code;
@property (nonatomic, readonly, nonnull) NSString *message;
@property (nonatomic, readonly, nullable) id data;
@property (nonatomic, readonly, nonnull) NSString *contentType;

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message data:(id)data contentType:(NSString *)contentType;

@end


NS_ASSUME_NONNULL_END

