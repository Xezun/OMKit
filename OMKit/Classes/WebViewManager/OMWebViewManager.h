//
//  OMWebViewManager.h
//  OMKit
//
//  Created by mlibai on 2017/8/31.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//
//  OMWebViewManager 是与 OMApp.js 交互框架配套使用的基础类，用于转发 omApp 的消息。
//  开发者应该使用子类，分发具体的事件。


#import <Foundation/Foundation.h>
@import JavaScriptCore;
@import WebKit;




NS_ASSUME_NONNULL_BEGIN

@class OMWebViewHTTPRequest, OMWebViewHTTPResponse;



/** 用户类型枚举 */
typedef NSString *OMWebViewInfoUserType NS_SWIFT_NAME(WebViewInfoUserType);
FOUNDATION_EXTERN OMWebViewInfoUserType const OMWebViewInfoUserTypeVisitor;
FOUNDATION_EXTERN OMWebViewInfoUserType const OMWebViewInfoUserTypeGoogle;
FOUNDATION_EXTERN OMWebViewInfoUserType const OMWebViewInfoUserTypeFacebook;
FOUNDATION_EXTERN OMWebViewInfoUserType const OMWebViewInfoUserTypeTwitter;
FOUNDATION_EXTERN OMWebViewInfoUserType const OMWebViewInfoUserTypeWhatsapp;

/** 主题枚举 */
typedef NSString *OMWebViewInfoTheme NS_SWIFT_NAME(WebViewInfoTheme);
FOUNDATION_EXPORT OMWebViewInfoTheme const OMWebViewInfoThemeDay;
FOUNDATION_EXPORT OMWebViewInfoTheme const OMWebViewInfoThemeNight;


NS_SWIFT_NAME(WebViewUserInfo)
@interface OMWebViewUserInfo : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) OMWebViewInfoUserType type;
@property (nonatomic) NSInteger coin;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithID:(NSString *)id name:(NSString *)name type:(OMWebViewInfoUserType)type coin:(NSInteger)coin NS_DESIGNATED_INITIALIZER;

@end

NS_SWIFT_NAME(WebViewNavigationBarInfo)
@interface OMWebViewNavigationBarInfo : NSObject

@property (nonatomic, setter=setHidden:) BOOL isHidden;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *backgroundColor;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor isHidden:(BOOL)isHidden NS_DESIGNATED_INITIALIZER;

@end


NS_SWIFT_NAME(WebViewMessageHandler)
@interface OMWebViewManager: NSObject <WKScriptMessageHandler>

@property (nonatomic, weak, nullable, readonly) WKWebView *webView;

@property (nonatomic, readonly) BOOL isReady;

@property (nonatomic, strong, readonly) OMWebViewUserInfo *currentUser;
@property (nonatomic, strong, readonly) OMWebViewNavigationBarInfo *navigationBar;
@property (nonatomic, copy) OMWebViewInfoTheme currentTheme;


+ (instancetype)messageHandlerWithWebView:(WKWebView *)webView;
+ (instancetype)messageHandlerWithWebView:(WKWebView *)webView currentUser:(OMWebViewUserInfo *)currentUser navigationBar:(OMWebViewNavigationBarInfo *)navigationBar currentTheme:(OMWebViewInfoTheme)currentTheme;

- (instancetype)init NS_UNAVAILABLE;

/**
 创建一个 OMApp 对象来处理 WKWebView 的消息。需调用 -removeFromWebView 来释放该对象。
 - 当 OMWebViewMessageHandler 收到 ready 消息时，会将 currentUser／navigationBar 的信息会同步到 JS 环境的对象中。
 - 当改变 currentUser／navigationBar 的属性时，信息也会同步到 JS 环境中。
 
 @param webView webView description
 @param currentUser currentUser description
 @param navigationBar navigationBar description
 @param currentTheme currentTheme description
 @return return value description
 */
- (instancetype)initWithWebView:(WKWebView *)webView currentUser:(OMWebViewUserInfo *)currentUser navigationBar:(OMWebViewNavigationBarInfo *)navigationBar currentTheme:(OMWebViewInfoTheme)currentTheme NS_DESIGNATED_INITIALIZER;


/**
 把当前的 handler 从 WebView 中移除，在视图销毁前，请调用此方法。
 */
- (void)removeFromWebView;



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



@protocol OMWebViewMessage <NSObject>

/**
 请在此方法中初始化 JavaScript 中的 omApp 对象。
 
 @param webView 发送此消息的 webView
 @param completion 请在初始化完成后执行此闭包。
 */
- (void)webView:(WKWebView *)webView ready:(void (^)())completion;

/**
 请在此方法中执行登录操作。
 
 @param webView 发送此消息的 webView
 @param completion 请在登录成功或失败时，调用闭包函数。
 */
- (void)webView:(WKWebView *)webView login:(void (^)(BOOL success))completion;

/**
 请在此方法中执行更改用户主题的操作。
 
 @param webView 发送此消息的 webView
 @param theme 主题
 */
- (void)webView:(WKWebView *)webView setCurrentTheme:(nonnull NSString *)theme;

/**
 页面跳转。
 
 @param webView 发送此消息的 webView
 @param page 目的页面。
 @param parameters 页面所需参数。
 */
- (void)webView:(WKWebView *)webView open:(nonnull NSString *)page parameters:(nullable NSDictionary *)parameters;

/**
 打开新的页面。
 
 @param webView 发送此消息的 webView
 @param url 页面的 URL 。
 @param animated 是否呈现转场动画。
 @param completion 新页面呈现后，执行的回调。
 */
- (void)webView:(WKWebView *)webView present:(nonnull NSString *)url animated:(BOOL)animated completion:(void (^)())completion;

/**
 导航到下级页面。
 
 @param webView 发送此消息的 webView
 @param url 下级页面的 URL 。
 @param animated 是否呈现转场动画。
 */
- (void)webView:(WKWebView *)webView push:(NSString *)url animated:(BOOL)animated;

/**
 返回到上级页面。
 
 @param webView 发送此消息的 webView
 @param animated 是否呈现转场动画。
 */
- (void)webView:(WKWebView *)webView pop:(BOOL)animated;

/**
 返回到指定级页面。
 
 @param webView 发送此消息的 webView
 @param index 页面在栈中的索引。
 @param animated 是否呈现转场动画。
 */
- (void)webView:(WKWebView *)webView popTo:(NSInteger)index animated:(BOOL)animated;

/**
 设置隐藏或显示导航条。
 
 @param webView 发送此消息的 webView
 @param hidden 导航的显隐状态。
 @param animated 是否呈现过渡动画。
 */
- (void)webView:(WKWebView *)webView setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

/**
 设置导航标题。
 
 @param webView 发送此消息的 webView
 @param title 导航标题。
 */
- (void)webView:(WKWebView *)webView setNavigationBarTitle:(NSString *)title;

/**
 设置导航标题文字颜色。
 
 @param webView 发送此消息的 webView
 @param titleColor 标题文字颜色。
 */
- (void)webView:(WKWebView *)webView setNavigationBarTitleColor:(UIColor *)titleColor;

/**
 设置导航背景色。
 
 @param backgrondColor 导航背景色。
 */
- (void)webView:(WKWebView *)webView setNavigationBarBackgroundColor:(UIColor *)backgrondColor;

/**
 跟踪一条新的统计事件。
 
 @param webView 发送此消息的 webView
 @param event 事件名称
 @param parameters 事件参数
 */
- (void)webView:(WKWebView *)webView track:(NSString *)event parameters:(nullable NSDictionary<NSString *, id> *)parameters;

/**
 发送网络请求。
 
 @param webView 发送此消息的 webView
 @param request 网络请求对象。
 @param completion 请求完毕后执行的回调。
 */
- (void)webView:(WKWebView *)webView http:(OMWebViewHTTPRequest *)request completion:(void (^)(OMWebViewHTTPResponse *response))completion;

/**
 HTML 页面查询列表的行数。
 
 @param webView 发送此消息的 webView
 @param document 列表所属页面名称。
 @param list 列表名称。
 @param completion 通过此回调返回列表的行数。
 */
- (void)webView:(WKWebView *)webView document:(NSString *)document numberOfRowsInList:(NSString *)list completion:(void (^)(NSInteger count))completion;

/**
 HTML 获取页面列表某一行的数据。
 
 @param webView 发送此消息的 webView
 @param document 列表所属的页面名称。
 @param list 列表名称。
 @param index 列表行所在的索引。
 @param completion 请通过此回调返回所查询的数据。
 */
- (void)webView:(WKWebView *)webView document:(NSString *)document list:(NSString *)list dataForRowAtIndex:(NSInteger)index completion:(void (^)(NSDictionary<NSString *, id> *data))completion;

/**
 HTML 获取指定资源的缓存。s
 
 @param webView 发送此消息的 webView
 @param url 资源的 URL 。
 @param resoureType 资源类型。
 @param completion 请在此回调中，返回缓存文件的路径。
 */
- (void)webView:(WKWebView *)webView cachedResourceForURL:(NSURL *)url ofType:(NSString *)resoureType completion:(void (^)(NSString * _Nullable resourcePath))completion;

/**
 基于 SDWebImageView 提供了默认的图片缓存处理。
 - NOTE: WKWebView 不能访问非同目录下的文件，需要将 HTML 文件拷贝到 SDWebImageView 默认缓存相同的目录下。
 
 @param webView 发送此消息的 webView
 @param url 图片 URL
 @param completion 回调
 */
- (void)webView:(WKWebView *)webView cachedImageForURL:(NSURL *)url completion:(void (^)(NSString * _Nullable imagePath))completion;

/**
 HTML 列表的行被选中时，此方法会触发。
 
 @param webView 发送此消息的 webView
 @param document 列表所在的页面
 @param list 列表名称
 @param index 行所在的索引
 @param completion 执行操作后的操作
 */
- (void)webView:(WKWebView *)webView document:(NSString *)document list:(NSString *)list didSelectRowAtIndex:(NSInteger)index completion:(void (^)())completion;

/**
 HTML 页面的元素被点击时。
 
 @param webView 发送此消息的 webView
 @param document 页面名称
 @param element 元素名称
 @param data 数据
 @param completion 请在执行完毕点击事件后，执行此回调，告知元素是否应该被选中
 */
- (void)webView:(WKWebView *)webView document:(NSString *)document element:(NSString *)element wasClicked:(id)data completion:(void (^)(BOOL isSelected))completion;


@end


@interface OMWebViewManager (OMWebViewMessage) <OMWebViewMessage>

@end

NS_ASSUME_NONNULL_END

