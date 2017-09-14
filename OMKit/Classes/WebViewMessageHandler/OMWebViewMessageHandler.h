//
//  OMApp.h
//  OMKit
//
//  Created by mlibai on 2017/8/31.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//
//  OMWebViewMessageHandler 是与 OMApp.js 交互框架配套使用的基础类，用于转发 omApp 的消息。
//  开发者应该使用子类，分发具体的事件。


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
+ (instancetype)messageHandlerWithWebView:(WKWebView *)webView viewController:(UIViewController *)viewController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithWebView:(WKWebView *)webView viewController:(UIViewController *)viewController NS_DESIGNATED_INITIALIZER;


/**
 把当前的 handler 从 WebView 中移除，在视图销毁前，请调用此方法。
 */
- (void)removeFromWebView;


/**
 请在此方法中初始化 JavaScript 中的 omApp 对象。

 @param completion 请在初始化完成后执行此闭包。
 */
- (void)ready:(void (^)())completion;

/**
 请在此方法中执行登录操作。

 @param completion 请在登录成功或失败时，调用闭包函数。
 */
- (void)login:(void (^)(BOOL success))completion;

/**
 请在此方法中执行更改用户主题的操作。

 @param theme 主题
 */
- (void)setCurrentTheme:(nonnull NSString *)theme;

/**
 页面跳转。

 @param page 目的页面。
 @param parameters 页面所需参数。
 */
- (void)open:(nonnull NSString *)page parameters:(nullable NSDictionary *)parameters;

/**
 打开新的页面。

 @param url 页面的 URL 。
 @param animated 是否呈现转场动画。
 @param completion 新页面呈现后，执行的回调。
 */
- (void)present:(nonnull NSString *)url animated:(BOOL)animated completion:(void (^)())completion;

/**
 导航到下级页面。

 @param url 下级页面的 URL 。
 @param animated 是否呈现转场动画。
 */
- (void)push:(NSString *)url animated:(BOOL)animated;

/**
 返回到上级页面。

 @param animated 是否呈现转场动画。
 */
- (void)pop:(BOOL)animated;

/**
 返回到指定级页面。

 @param index 页面在栈中的索引。
 @param animated 是否呈现转场动画。
 */
- (void)popTo:(NSInteger)index animated:(BOOL)animated;

/**
 设置隐藏或显示导航条。

 @param hidden 导航的显隐状态。
 @param animated 是否呈现过渡动画。
 */
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

/**
 设置导航标题。

 @param title 导航标题。
 */
- (void)setNavigationBarTitle:(NSString *)title;

/**
 设置导航标题文字颜色。

 @param titleColor 标题文字颜色。
 */
- (void)setNavigationBarTitleColor:(UIColor *)titleColor;

/**
 设置导航背景色。

 @param backgrondColor 导航背景色。
 */
- (void)setNavigationBarBackgroundColor:(UIColor *)backgrondColor;

/**
 跟踪一条新的统计事件。

 @param event 事件名称
 @param parameters 事件参数
 */
- (void)track:(NSString *)event parameters:(nullable NSDictionary<NSString *, id> *)parameters;

/**
 发送网络请求。

 @param request 网络请求对象。
 @param completion 请求完毕后执行的回调。
 */
- (void)http:(OMWebViewHTTPRequest *)request completion:(void (^)(OMWebViewHTTPResponse *response))completion;

/**
 HTML 页面查询列表的行数。

 @param document 列表所属页面名称。
 @param list 列表名称。
 @param completion 通过此回调返回列表的行数。
 */
- (void)document:(NSString *)document numberOfRowsInList:(NSString *)list completion:(void (^)(NSInteger count))completion;

/**
 HTML 获取页面列表某一行的数据。

 @param document 列表所属的页面名称。
 @param list 列表名称。
 @param index 列表行所在的索引。
 @param completion 请通过此回调返回所查询的数据。
 */
- (void)document:(NSString *)document list:(NSString *)list dataForRowAtIndex:(NSInteger)index completion:(void (^)(NSDictionary<NSString *, id> *data))completion;

/**
 HTML 获取指定资源的缓存。s

 @param url 资源的 URL 。
 @param resoureType 资源类型。
 @param download 如果资源不在缓存中，是否自动下载。
 @param completion 请在此回调中，返回缓存文件的路径。
 */
- (void)cachedResourceForURL:(NSURL *)url resoureType:(NSString *)resoureType downloadIfNotExists:(BOOL)download completion:(void (^)(NSString * _Nullable resourcePath))completion;

/**
 基于 SDWebImageView 提供了默认的图片缓存处理。
 - NOTE: WKWebView 不能访问非同目录下的文件，需要将 HTML 文件拷贝到 SDWebImageView 默认缓存相同的目录下。

 @param url 图片 URL
 @param completion 回调
 */
- (void)cachedImageForURL:(NSURL *)url completion:(void (^)(NSString * _Nullable imagePath))completion;

/**
 HTML 列表的行被选中时，此方法会触发。

 @param document 列表所在的页面。
 @param list 列表名称。
 @param index 行所在的索引。
 @param completion 执行操作后的操作。
 */
- (void)document:(NSString *)document list:(NSString *)list didSelectRowAtIndex:(NSInteger)index completion:(void (^)())completion;

/**
 HTML 页面的元素被点击时。

 @param document 页面名称。
 @param element 元素名称。
 @param data 数据。
 @param completion 请在执行完毕点击事件后，执行此回调，告知元素是否应该被选中。
 */
- (void)document:(NSString *)document element:(NSString *)element wasClicked:(id)data completion:(void (^)(BOOL isSelected))completion;

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

