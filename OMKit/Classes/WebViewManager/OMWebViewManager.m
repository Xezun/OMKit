//
//  OMWebViewManager.m
//  OMKit
//
//  Created by mlibai on 2017/8/31.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

#import "OMWebViewMessageHandler.h"
#import <objc/runtime.h>
#import <SDWebImage/SDWebImageManager.h>
#import <XZKit/XZKit-Swift.h>


typedef NSString * ArgumentsType;
static ArgumentsType const kArgumentsTypeString         = @"string"; // 字符串
static ArgumentsType const kArgumentsTypeNumber         = @"number"; // 数字或布尔值
static ArgumentsType const kArgumentsTypeDictionary     = @"dictionary"; // 字典
static ArgumentsType const kArgumentsTypeObject         = @"object"; // 任意类型

static NSString *NSStringFromBOOL(BOOL aBool) {
    return (aBool ? @"true" : @"false");
}

/**
 检查 OMApp 消息方法的参数。

 @param method 消息方法名
 @param arguments 消息参数
 @param types 参数的所有数据类型
 @param numberOfRequiredArguments 必选参数的个数
 */
inline static void kArgumentsAssert(NSString *method, NSArray *arguments, NSArray<ArgumentsType> *types, NSInteger numberOfRequiredArguments) {
    if (arguments.count < numberOfRequiredArguments) {
        NSString *reson = [NSString stringWithFormat:@"The method expect to have `%ld` arguments, but passed %ld`.", (long)types.count, (long)arguments.count];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reson userInfo:nil];
    }
    for (NSInteger index = 0; index < arguments.count; index++) {
        if ([types[index] isEqualToString:kArgumentsTypeString]) {
            if ([arguments[index] isKindOfClass:[NSString class]]) {
                continue;
            }
            NSString *reson = [NSString stringWithFormat:@"The argument for method `%@` at `%ld` expect to a string value", method, (long)index];
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reson userInfo:nil];
        }
        if ([types[index] isEqualToString:kArgumentsTypeNumber]) {
            if ([arguments[index] isKindOfClass:[NSNumber class]]) {
                continue;
            }
            NSString *reson = [NSString stringWithFormat:@"The argument for method `%@` at `%ld` expect to a number/bool value", method, (long)index];
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reson userInfo:nil];
        }
        if ([types[index] isEqualToString:kArgumentsTypeObject]) {
            continue;
        }
    }
}


/**
 把一个字符串转换成 JavaScript 代码。转换结果可能是 null 字符串。

 @param aString 字符串
 @return 可以直接执行的 JavaScript 代码。
 */
inline static NSString *JavaScriptCodeForNSString(NSString *aString) {
    NSString *encoded = [aString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    if (encoded != nil) {
        return [NSString stringWithFormat:@"decodeURIComponent('%@')", encoded];
    }
    return @"null";
}

inline static NSString *JavaScriptCodeForUIColor(UIColor *aColor) {
    return [NSString stringWithFormat:@"#%06X", aColor.rgbaValue];
}

@interface OMWebViewUserInfo ()

- (void)readyForWebView:(WKWebView *)webView;

@end

@interface OMWebViewNavigationBarInfo ()

- (void)readyForWebView:(WKWebView *)webView;

- (void)setHidden:(BOOL)isHidden needsSync:(BOOL)needsSync;
- (void)setTitle:(NSString *)title needsSync:(BOOL)needsSync;
- (void)setTitleColor:(UIColor *)titleColor needsSync:(BOOL)needsSync;
- (void)setBackgroundColor:(UIColor *)backgroundColor  needsSync:(BOOL)needsSync;

@end


@implementation OMWebViewManager

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (instancetype)initWithWebView:(WKWebView *)webView currentUser:(nonnull OMWebViewUserInfo *)currentUser navigationBar:(nonnull OMWebViewNavigationBarInfo *)navigationBar currentTheme:(OMWebViewInfoTheme)currentTheme {
    self = [super init];
    if (self != nil) {
        _isReady        = NO;
        _webView        = webView;
        _currentUser    = currentUser;
        _navigationBar  = navigationBar;
        _currentTheme   = currentTheme;
        
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"omApp"];
        NSString *js = @"OMApp.current.delegate = function(message){ window.webkit.messageHandlers.omApp.postMessage(message); }";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:(WKUserScriptInjectionTimeAtDocumentEnd) forMainFrameOnly:false];
        [_webView.configuration.userContentController addUserScript:script];
    }
    return self;
}

+ (instancetype)messageHandlerWithWebView:(WKWebView *)webView {
    OMWebViewInfoTheme currentTheme = OMWebViewInfoThemeDay;
    OMWebViewUserInfo *currentUser = [[OMWebViewUserInfo alloc] initWithID:@"" name:@"Onemena" type:OMWebViewInfoUserTypeVisitor coin:0];
    OMWebViewNavigationBarInfo *navigationBar = [[OMWebViewNavigationBarInfo alloc] initWithTitle:@"Onemena" titleColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] isHidden:false];
    return [self messageHandlerWithWebView:webView currentUser:currentUser navigationBar:navigationBar currentTheme:currentTheme];
}

+ (instancetype)messageHandlerWithWebView:(WKWebView *)webView currentUser:(nonnull OMWebViewUserInfo *)currentUser navigationBar:(nonnull OMWebViewNavigationBarInfo *)navigationBar currentTheme:(OMWebViewInfoTheme)currentTheme {
    return [[self alloc] initWithWebView:webView currentUser:currentUser navigationBar:navigationBar currentTheme:currentTheme];
}

- (void)removeFromWebView {
    [_webView evaluateJavaScript:@"OMApp.current.delegate = null;" completionHandler:nil];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"omApp"];
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *messageBody = message.body;
    
    NSAssert([messageBody isKindOfClass:[NSDictionary class]], @"The message body must be a dictionary");
    
    NSString *method = messageBody[@"method"];
    NSAssert([method isKindOfClass:[NSString class]], @"The `method` of the message must be a string.");
    
    NSArray *parameters = messageBody[@"parameters"];
    NSAssert(parameters == nil || [parameters isKindOfClass:[NSArray class]], @"The `parameters` of the message must be an array.");
    
    NSString *callbackID = messageBody[@"callbackID"];
    NSAssert(callbackID == nil || [callbackID isKindOfClass:[NSString class]], @"The `callbackID of the message must be a string.`");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performMethod:method withArguments:parameters callbackID:callbackID];
    });
}


- (void)performMethod:(NSString *)method withArguments:(NSArray *)arguments callbackID:(NSString *)callbackID {
    WKWebView * __weak webView = _webView;
    
    if ([method isEqualToString:@"ready"]) {
        NSAssert(callbackID != nil, @"The callbackID for ready method is not exists.");
        _isReady = true;
        [_currentUser readyForWebView:_webView];
        [_navigationBar readyForWebView:_webView];
        [self webView:webView ready:^{
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@')", callbackID];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    if ([method isEqualToString:@"setCurrentTheme"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString], 1);
        _currentTheme = arguments.firstObject;
        [self webView:webView setCurrentTheme:_currentTheme];
        return;
    }
    
    if ([method isEqualToString:@"login"]) {
        NSAssert(callbackID != nil, @"The `callbackID` for `login` method does not exist.");
        [self webView:webView login:^(BOOL success) {
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', %d)", callbackID, success];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    if ([method isEqualToString:@"open"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeDictionary], 1);
        [self webView:webView open:arguments.firstObject parameters:arguments.count > 1 ? arguments[1] : nil];
        return;
    }
    
    if ([method isEqualToString:@"present"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeNumber], 2);
        [self webView:webView present:arguments[0] animated:[arguments[1] boolValue] completion:^{
            if ([callbackID isKindOfClass:[NSString class]]) {
                NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@')", callbackID];
                [webView evaluateJavaScript:js completionHandler:nil];
            }
        }];
        return;
    }
    
    
    if ([method isEqualToString:@"push"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeNumber], 2);
        [self webView:webView push:arguments[0] animated:[arguments[1] boolValue]];
        return;
    }
    
    if ([method isEqualToString:@"pop"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeNumber], 1);
        [self webView:webView pop:[arguments.firstObject boolValue]];
        return;
    }
    
    if ([method isEqualToString:@"popTo"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeNumber, kArgumentsTypeNumber], 2);
        [self webView:webView popTo:[arguments[0] integerValue] animated:[arguments[1] boolValue]];
        return;
    }
    
    
    if ([method isEqualToString:@"setNavigationBarHidden"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeNumber, kArgumentsTypeNumber], 1);
        [_navigationBar setHidden:[arguments[0] boolValue] needsSync:NO];
        [self webView:webView setNavigationBarHidden:_navigationBar.isHidden animated:[arguments[1] boolValue]];
        return;
    }
    
    if ([method isEqualToString:@"setNavigationBarTitle"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString], 1);
        [_navigationBar setTitle:arguments.firstObject needsSync:NO];
        [self webView:webView setNavigationBarTitle:arguments.firstObject];
        return;
    }
    
    if ([method isEqualToString:@"setNavigationBarTitleColor"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString], 1);
        [_navigationBar setTitleColor:[[UIColor alloc] initWithString:arguments[0]] needsSync:NO];
        [self webView:webView setNavigationBarTitleColor:_navigationBar.titleColor];
        return;
    }
    
    if ([method isEqualToString:@"setNavigationBarBackgroundColor"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString], 1);
        [_navigationBar setBackgroundColor:[[UIColor alloc] initWithString:arguments[0]] needsSync:NO];
        [self webView:webView setNavigationBarBackgroundColor:_navigationBar.backgroundColor];
        return;
    }
    
    
    if ([method isEqualToString:@"track"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeDictionary], 1);
        [self webView:webView track:arguments.firstObject parameters:(arguments.count > 1 ? arguments[1] : nil)];
        return;
    }
    
    if ([method isEqualToString:@"http"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeDictionary], 1);
        NSDictionary *dictionary = arguments[0];
        OMWebViewHTTPRequest *request = [[OMWebViewHTTPRequest alloc] initWithMethod:dictionary[@"method"] url:dictionary[@"url"] data:dictionary[@"data"] headers:dictionary[@"headers"]];
        [self webView:webView http:request completion:^(OMWebViewHTTPResponse * _Nonnull response) {
            if (callbackID == nil) {
                return;
            }
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            dictionary[@"code"]         = @(response.code);
            dictionary[@"message"]      = response.message;
            dictionary[@"data"]         = response.data;
            dictionary[@"contentType"]  = response.contentType;
            NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:(NSJSONWritingPrettyPrinted) error:NULL];
            NSString *string = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', %@)", callbackID, string];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    // data service
    
    if ([method isEqualToString:@"numberOfRowsInList"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeString], 2);
        NSAssert(callbackID != nil, @"The `callbackID` for `numberOfRows` method does not exist.");
        [self webView:webView document:arguments[0] numberOfRowsInList:arguments[1] completion:^(NSInteger count) {
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', %ld)", callbackID, (long)count];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    if ([method isEqualToString:@"dataForRowAtIndex"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeString, kArgumentsTypeNumber], 3);
        NSAssert(callbackID != nil, @"The `callbackID` for `dataForRowAtIndex` method does not exist.");
        [self webView:webView document:arguments[0] list:arguments[1] dataForRowAtIndex:[arguments[2] integerValue] completion:^(NSDictionary * _Nonnull model) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:model options:(NSJSONWritingPrettyPrinted) error:NULL];
            NSString *string = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', %@)", callbackID, string];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    if ([method isEqualToString:@"cachedResourceForURL"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeString], 2);
        NSAssert(callbackID != nil, @"The `callbackID` for `cachedResourceForURL` method does not exist.");
        NSURL *url = [NSURL URLWithString:arguments[0]];
        if (url == nil) {
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', '%@')", callbackID, arguments[0]];
            [webView evaluateJavaScript:js completionHandler:nil];
            return;
        }
        [self webView:webView cachedResourceForURL:url ofType:arguments[1] completion:^(NSString * _Nullable resourcePath) {
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', '%@')", callbackID, resourcePath != nil ? resourcePath : @""];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    // event service
    
    if ([method isEqualToString:@"didSelectRowAtIndex"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeString, kArgumentsTypeNumber], 3);
        [self webView:webView document:arguments[0] list:arguments[1] didSelectRowAtIndex:[arguments[2] integerValue] completion:^{
            if (callbackID == nil) {
                return;
            }
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@')", callbackID];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    if ([method isEqualToString:@"elementWasClicked"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeString, kArgumentsTypeObject], 2);
        [self webView:webView document:arguments[0] element:arguments[1] wasClicked:(arguments.count > 2 ? arguments[2] : nil) completion:^(BOOL isSelected) {
            if (callbackID == nil) {
                return;
            }
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', %@)", callbackID, NSStringFromBOOL(isSelected)];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    NSLog(@"Unperformed Method: %@, %@, %@.", method, arguments, callbackID);
}


- (void)setCurrentTheme:(OMWebViewInfoTheme)currentTheme {
    if (![_currentTheme isEqualToString:currentTheme]) {
        _currentTheme = [currentTheme copy];
        if ([self isReady]) {
            NSString *js = [NSString stringWithFormat:@"window.omApp.currentTheme = OMApp.Theme.%@;", currentTheme];
#if DEBUG
            void (^completion)(id, NSError *) = ^(id _Nullable result, NSError * _Nullable error) {
                if (error != nil || error.code != noErr) {
                    NSLog(@"[OMWebViewManager] Error occured when set the current theme to `%@`: %@", currentTheme, error);
                }
            };
#else
            void (^completion)(id, NSError *) = nil
#endif
            [_webView evaluateJavaScript:js completionHandler:completion];
        }
    }
}

@end

@implementation OMWebViewManager (OMWebViewMessage)

#pragma mark - OMAppSystem

- (void)webView:(WKWebView *)webView ready:(void (^)())completion {
    NSLog(@"[OMWebViewMessageHandler] Message `ready(callback)` is not handled.");
}

- (void)webView:(WKWebView *)webView login:(void (^)(BOOL))completion {
    NSLog(@"[OMWebViewMessageHandler] Message `login(callback)` is not handled.");
}

- (void)webView:(WKWebView *)webView setCurrentTheme:(NSString *)theme {
    NSLog(@"[OMWebViewMessageHandler] Message `setCurrentTheme(%@)` is not handled.", theme);
}

#pragma mark - OMAppRedirection

- (void)webView:(WKWebView *)webView open:(NSString *)page parameters:(NSDictionary *)parameters {
    NSLog(@"[OMWebViewMessageHandler] Message `open(%@, %@)` is not handled.", page, parameters);
}

- (void)webView:(WKWebView *)webView present:(NSString *)url animated:(BOOL)animated completion:(void (^)())completion {
    NSLog(@"[OMWebViewMessageHandler] Message `present(%@, %@, callback)` is not handled.", url, NSStringFromBOOL(animated));
}

#pragma mark - OMAppNavigation


- (void)webView:(WKWebView *)webView push:(NSString *)url animated:(BOOL)animated {
    NSLog(@"[OMWebViewMessageHandler] Message `push(%@, %@)` is not handled.", url, NSStringFromBOOL(animated));
}

- (void)webView:(WKWebView *)webView pop:(BOOL)animated {
    NSLog(@"[OMWebViewMessageHandler] Message `pop(%@)` is not handled.", NSStringFromBOOL(animated));
}

- (void)webView:(WKWebView *)webView popTo:(NSInteger)index animated:(BOOL)animated {
    NSLog(@"[OMWebViewMessageHandler] Message `popTo(%ld, %@)` is not handled.", (long)index, NSStringFromBOOL(animated));
}

- (void)webView:(WKWebView *)webView setNavigationBarTitle:(NSString *)title {
    NSLog(@"[OMWebViewMessageHandler] Message `setNavigationBarTitle(%@)` is not handled.", title);
}

- (void)webView:(WKWebView *)webView setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    NSLog(@"[OMWebViewMessageHandler] Message `setNavigationBarHidden(%@, %@)` is not handled.", NSStringFromBOOL(hidden), NSStringFromBOOL(animated));
}

- (void)webView:(WKWebView *)webView setNavigationBarTitleColor:(UIColor *)titleColor {
    NSLog(@"[OMWebViewMessageHandler] Message `setNavigationBarTitleColor(#%06X)` is not handled.", [titleColor rgbaValue]);
}

- (void)webView:(WKWebView *)webView setNavigationBarBackgroundColor:(UIColor *)backgrondColor {
    NSLog(@"[OMWebViewMessageHandler] Message `popTo(3%06X)` is not handled.", [backgrondColor rgbaValue]);
}

#pragma mark - OMAppAnalytics

- (void)webView:(WKWebView *)webView track:(NSString *)event parameters:(NSDictionary<NSString *,id> *)parameters {
    NSLog(@"[OMWebViewMessageHandler] Message `track(%@, %@)` is not handled.", event, parameters);
}

#pragma mark - OMAppNetworking

- (void)webView:(WKWebView *)webView http:(OMWebViewHTTPRequest *)request completion:(void (^)(OMWebViewHTTPResponse * _Nonnull))completion {
    NSLog(@"[OMWebViewMessageHandler] Message `http(%@, callback)` is not handled.", request);
}

#pragma mark - OMAppData

-  (void)webView:(WKWebView *)webView document:(NSString *)document numberOfRowsInList:(NSString *)list completion:(void (^)(NSInteger))completion {
    NSLog(@"[OMWebViewMessageHandler] Message `numberOfRowsInList(%@, %@, callback)` is not handled.", document, list);
}

- (void)webView:(WKWebView *)webView document:(NSString *)document list:(NSString *)list dataForRowAtIndex:(NSInteger)index completion:(void (^)(NSDictionary<NSString *,id> * _Nonnull))completion {
    NSLog(@"[OMWebViewMessageHandler] Message `dataForRowAtIndex(%@, %@, %ld, callback)` is not handled.", document, list, (long)index);
}

- (void)webView:(WKWebView *)webView cachedResourceForURL:(NSURL *)url ofType:(NSString *)resoureType completion:(void (^)(NSString * _Nullable))completion {
    if ([resoureType isEqualToString:@"image"]) {
        [self webView:webView cachedImageForURL:url completion:completion];
    } else {
        NSLog(@"[OMWebViewMessageHandler] Message `cachedResourceForURL(%@, %@, callback)` is not handled.", url, resoureType);
    }
}

- (void)webView:(WKWebView *)webView cachedImageForURL:(NSURL *)url completion:(void (^)(NSString * _Nullable))completion {
    [self OMKit_downloadImageWithURL:url completion:completion];
}

- (void)OMKit_downloadImageWithURL:(NSURL *)url completion:(void (^)(NSString * _Nullable))completion {
    [[SDWebImageManager sharedManager] diskImageExistsForURL:url completion:^(BOOL isInCache) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if (isInCache) {
            // 必须在图片存在磁盘缓存时执行 block，否则可能造成 WKWebView 加载不存在的本地图片时卡顿。
            NSString *imagePath = [manager.imageCache defaultCachePathForKey:[manager cacheKeyForURL:url]];
            if (imagePath != nil && ![imagePath hasPrefix:@"file://"]) {
                imagePath = [NSString stringWithFormat:@"file://%@", imagePath];
            }
            completion(imagePath);
        } else {
            [manager loadImageWithURL:url options:(SDWebImageAllowInvalidSSLCertificates) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (error == nil || error.code == noErr) {
                    // 只有在没有发生错误时才能这么处理，否则可能造成循环。
                    [self OMKit_downloadImageWithURL:url completion:completion];
                } else {
                    completion(nil);
                }
            }];
        }
    }];
}


- (void)webView:(WKWebView *)webView document:(NSString *)document list:(NSString *)list didSelectRowAtIndex:(NSInteger)index completion:(void (^)())completion {
    NSLog(@"[OMWebViewMessageHandler] Message `didSelectRowAtIndex(%@, %@, %ld, callback)` is not handled.", document, list, (long)index);
}

- (void)webView:(WKWebView *)webView document:(NSString *)document element:(NSString *)element wasClicked:(id)data completion:(void (^)(BOOL))completion {
    NSLog(@"[OMWebViewMessageHandler] Message `elementWasClicked(%@, %@, %@, callback)` is not handled.", document, element, data);
}


@end


@implementation OMWebViewHTTPRequest

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url data:(NSDictionary<NSString *,id> *)data headers:(NSDictionary<NSString *,NSString *> *)headers {
    self = [super init];
    if (self != nil) {
        _method = method;
        _url = url;
        _data = data;
        _headers = headers;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"OMWebViewHTTPRequest: {\n\tmethod: %@, \n\turl: %@, \n\tdata: %@, \n\theaders: %@\n}", self.method, self.url, self.data, self.headers];
}

@end



@implementation OMWebViewHTTPResponse

- (instancetype)initWithCode:(NSInteger)code message:(NSString *)message data:(id)data contentType:(NSString *)contentType {
    self = [super init];
    if (self != nil) {
        _code = code;
        _message = message;
        _data = data;
        _contentType = contentType;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"OMWebViewHTTPResponse: {\n\tcode: %ld, \n\tmessage: %@, \n\tdata: %@, \n\tcontentType: %@\n}", (long)self.code, self.message, NSStringFromClass([self.data class]), self.contentType];
}


@end







@implementation OMWebViewUserInfo {
    __weak WKWebView *_webView;
}

- (instancetype)initWithID:(NSString *)id name:(NSString *)name type:(OMWebViewInfoUserType)type coin:(NSInteger)coin {
    self = [super init];
    if (self != nil) {
        _id   = id.copy;
        _name = name.copy;
        _type = type.copy;
        _coin = coin;
    }
    return self;
}

- (void)readyForWebView:(WKWebView *)webView {
    _webView = webView;
    [self OMKit_setValue:JavaScriptCodeForNSString(_id) forProperty:@"id"];
    [self OMKit_setValue:JavaScriptCodeForNSString(_name) forProperty:@"name"];
    [self OMKit_setValue:JavaScriptCodeForNSString(_type) forProperty:@"type"];
    [self OMKit_setValue:[NSString stringWithFormat:@"%ld", (long)_coin] forProperty:@"coin"];
}

- (void)setName:(NSString *)name {
    if (_name != name) {
        _name = [name copy];
        [self OMKit_setValue:JavaScriptCodeForNSString(_name) forProperty:@"name"];
    }
}

- (void)setType:(OMWebViewInfoUserType)type {
    if (_type != type) {
        _type = [type copy];
        [self OMKit_setValue:JavaScriptCodeForNSString(_type) forProperty:@"type"];
    }
}

- (void)setCoin:(NSInteger)coin {
    if (_coin != coin) {
        _coin = coin;
        [self OMKit_setValue:[NSString stringWithFormat:@"%ld", (long)_coin] forProperty:@"coin"];
    }
}

- (void)OMKit_setValue:(NSString *)value forProperty:(NSString *)property {
    NSString *js = [NSString stringWithFormat:@"window.omApp.currentUser.%@ = %@;", property, value];
    [_webView evaluateJavaScript:js completionHandler:
#if DEBUG
     ^(id _Nullable result, NSError * _Nullable error) {
         if (error != nil) {
             NSLog(@"[OMAppMessageHandler] Error occured when evaluate `%@`: %@", js, error);
         }
     }
#else
     nil
#endif
     ];
}

@end

@implementation OMWebViewNavigationBarInfo {
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

- (void)readyForWebView:(WKWebView *)webView {
    _webView = webView;
    [self OMKit_setValue:JavaScriptCodeForNSString(_title) forProperty:@"title"];
    [self OMKit_setValue:JavaScriptCodeForUIColor(_titleColor) forProperty:@"titleColor"];
    [self OMKit_setValue:JavaScriptCodeForUIColor(_backgroundColor) forProperty:@"backgroundColor"];
    [self OMKit_setValue:NSStringFromBOOL(_isHidden) forProperty:@"isHidden"];
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
        [self OMKit_setValue:JavaScriptCodeForNSString(_title) forProperty:@"title"];
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
        [self OMKit_setValue:JavaScriptCodeForUIColor(_titleColor) forProperty:@"titleColor"];
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
        [self OMKit_setValue:JavaScriptCodeForUIColor(_backgroundColor) forProperty:@"backgroundColor"];
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
        [self OMKit_setValue:NSStringFromBOOL(hidden) forProperty:@"isHidden"];
    }
}


- (void)OMKit_setValue:(NSString *)value forProperty:(NSString *)property {
    NSString *js = [NSString stringWithFormat:@"window.omApp.navigation.bar.%@ = %@;", property, value];
    [_webView evaluateJavaScript:js completionHandler:
#if DEBUG
     ^(id _Nullable result, NSError * _Nullable error) {
         if (error != nil) {
             NSLog(@"[OMAppMessageHandler] Error occured when evaluate `%@`: %@", js, error);
         }
     }
#else
     nil
#endif
     ];
}

@end
