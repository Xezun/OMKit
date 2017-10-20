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

@class OMWebViewManagerHTTPRequest, OMWebViewManagerHTTPResponse, OMWebViewManagerUser, OMWebViewManagerNavigationBar;

/** 主题枚举。 对应 js 环境中的 OMApp.Theme 。*/
typedef NSString *OMWebViewManagerTheme NS_STRING_ENUM NS_SWIFT_NAME(WebViewManager.Theme);
FOUNDATION_EXPORT OMWebViewManagerTheme const OMWebViewManagerThemeDay;
FOUNDATION_EXPORT OMWebViewManagerTheme const OMWebViewManagerThemeNight;

/** 网络类型。 */
typedef NSString *OMWebViewManagerNetworkingType NS_STRING_ENUM NS_SWIFT_NAME(WebViewManager.NetworkingType);
FOUNDATION_EXPORT OMWebViewManagerNetworkingType const OMWebViewManagerNetworkingTypeNone   NS_SWIFT_NAME(none);
FOUNDATION_EXPORT OMWebViewManagerNetworkingType const OMWebViewManagerNetworkingTypeWiFi   NS_SWIFT_NAME(WiFi);
FOUNDATION_EXPORT OMWebViewManagerNetworkingType const OMWebViewManagerNetworkingTypeWWan2G NS_SWIFT_NAME(WWan2G);
FOUNDATION_EXPORT OMWebViewManagerNetworkingType const OMWebViewManagerNetworkingTypeWWan3G NS_SWIFT_NAME(WWan3G);
FOUNDATION_EXPORT OMWebViewManagerNetworkingType const OMWebViewManagerNetworkingTypeWWan4G NS_SWIFT_NAME(WWan4G);
FOUNDATION_EXPORT OMWebViewManagerNetworkingType const OMWebViewManagerNetworkingTypeOther  NS_SWIFT_NAME(other);

/* App 原生页面类型。 */
typedef NSString *OMWebViewManagerPage NS_STRING_ENUM NS_SWIFT_NAME(WebViewManager.Page);

/**
 OMWebViewManager 是 HTML 与 App 交互过程中，负责实现 App 功能的类。
 */
NS_SWIFT_NAME(WebViewManager) @interface OMWebViewManager: NSObject <WKScriptMessageHandler>

@property (nonatomic, weak, nullable, readonly) WKWebView *webView;

/** WebView 是否准备好接收事件。如果此值为 false，对 OMWebViewManager 属性的修改，会在 ready 时同步到 WebView 的 JS 环境中。*/
@property (nonatomic, readonly) BOOL isReady;

/** 直接修改 currentUser 属性，会同步复制到 JS 环境中的对象。*/
@property (nonatomic, strong, readonly) OMWebViewManagerUser *currentUser;

/** 直接修改 navigationBar 属性，会同步复制到 JS 环境中的对象。*/
@property (nonatomic, strong, readonly) OMWebViewManagerNavigationBar *navigationBar;

/** 直接修改 currentTheme 属性，会同步复制到 JS 环境中的对象。*/
@property (nonatomic, copy) OMWebViewManagerTheme currentTheme;

@property (nonatomic, copy) OMWebViewManagerNetworkingType networkType;

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
- (instancetype)initWithWebView:(WKWebView *)webView currentUser:(OMWebViewManagerUser *)currentUser navigationBar:(OMWebViewManagerNavigationBar *)navigationBar currentTheme:(OMWebViewManagerTheme)currentTheme networkType:(OMWebViewManagerNetworkingType)networkType NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithWebView:(WKWebView *)webView;

/**
 把当前的 handler 从 WebView 中移除，在视图销毁前，请调用此方法。
 */
- (void)removeFromWebView;

/**
 当 webView ready 时，OMWebViewManager 进行的初始化工作。子类重新应该调用父类方法。
 */
- (void)webViewWasReady NS_REQUIRES_SUPER;

@end



@interface OMWebViewManager (OMWebViewMessage)

/**
 请在此方法中初始化 JavaScript 中的 omApp 对象。
 
 @param webView 发送此消息的 webView
 @param completion 请在初始化完成后执行此闭包。
 */
- (void)webView:(WKWebView *)webView ready:(void (^)(BOOL isDebug))completion;

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
- (void)webView:(WKWebView *)webView setCurrentTheme:(nonnull OMWebViewManagerTheme)theme;

/**
 页面跳转。
 
 @param webView 发送此消息的 webView
 @param page 目的页面。
 @param parameters 页面所需参数。
 */
- (void)webView:(WKWebView *)webView open:(nonnull OMWebViewManagerPage)page parameters:(nullable NSDictionary *)parameters;

/**
 打开新的页面。
 
 @param webView 发送此消息的 webView
 @param url 页面的 URL 。
 @param animated 是否呈现转场动画。
 @param completion 新页面呈现后，执行的回调。
 */
- (void)webView:(WKWebView *)webView present:(nonnull NSString *)url animated:(BOOL)animated completion:(void (^)(void))completion;

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
- (void)webView:(WKWebView *)webView http:(OMWebViewManagerHTTPRequest *)request completion:(void (^)(OMWebViewManagerHTTPResponse *response))completion;

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
- (void)webView:(WKWebView *)webView document:(NSString *)document list:(NSString *)list didSelectRowAtIndex:(NSInteger)index completion:(void (^)(void))completion;

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


/**
 将布尔值转换成 @"true" 或 @"false" 。

 @param aBool 布尔值
 @return 在 JS 环境中表示布尔值的字符串
 */
extern NSString *OMJavaScriptCodeForBOOL(BOOL aBool);

/**
 将 OC 字符串转换成 JavaScript 字符串。转换后的内容，在 JS 环境中是字符串对象，而非字符串字面量。
 该方法先将字符串进行 URL 编码，然后在 JS 环境中 URL 解码。
 ```
 NSString *aString = "Some string";
 NSLog(@"%@", OMJavaScriptCodeForNSString(aString));
 // decodeURIComponent('Some%20string')
 ```

 @param aString 需要在 JS 中使用的字符串
 @return 在 JS 中表示原字符串的对象
 */
extern NSString *OMJavaScriptCodeForNSString(NSString *aString);

/**
 将 UIColor 对象转换成颜色值字符串，如 '#FFAABB' 。

 @param aColor UIColor 对象
 @return 表示颜色值字符串
 */
extern NSString *OMJavaScriptCodeForUIColor(UIColor *aColor);


NS_ASSUME_NONNULL_END



