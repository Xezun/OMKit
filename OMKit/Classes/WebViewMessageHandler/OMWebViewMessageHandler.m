//
//  OMApp.m
//  OMKit
//
//  Created by mlibai on 2017/8/31.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

#import "OMWebViewMessageHandler.h"
@import ObjectiveC;
@import SDWebImage;

#import <XZKit/XZKit-Swift.h>


typedef NSString * ArgumentsType;
static ArgumentsType const kArgumentsTypeString = @"string"; // 字符串
static ArgumentsType const kArgumentsTypeNumber = @"number"; // 数字或布尔值
static ArgumentsType const kArgumentsTypeDictionary = @"dictionary"; // 字典
static ArgumentsType const kArgumentsTypeObject = @"object"; // 任意类型

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




@implementation OMWebViewMessageHandler

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (instancetype)initWithWebView:(WKWebView *)webView viewController:(UIViewController *)viewController {
    self = [super init];
    if (self != nil) {
        _viewController = viewController;
        _webView = webView;
        
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"omApp"];
        NSString *js = @"OMApp.current.delegate = function(message){ window.webkit.messageHandlers.omApp.postMessage(message); }";
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:(WKUserScriptInjectionTimeAtDocumentEnd) forMainFrameOnly:false];
        [_webView.configuration.userContentController addUserScript:script];
    }
    return self;
}

+ (instancetype)messageHandlerWithWebView:(WKWebView *)webView viewController:(UIViewController *)viewController {
    return [[self alloc] initWithWebView:webView viewController:viewController];
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
    
    [self performMethod:method withArguments:parameters callbackID:callbackID];
}


- (void)performMethod:(NSString *)method withArguments:(NSArray *)arguments callbackID:(NSString *)callbackID {
    WKWebView * __weak webView = _webView;
    
    if ([method isEqualToString:@"ready"]) {
        NSAssert(callbackID != nil, @"The callbackID for ready method is not exists.");
        [self ready:^{
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@')", callbackID];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    if ([method isEqualToString:@"setCurrentTheme"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString], 1);
        [self setCurrentTheme:arguments.firstObject];
        return;
    }
    
    if ([method isEqualToString:@"login"]) {
        NSAssert(callbackID != nil, @"The `callbackID` for `login` method does not exist.");
        [self login:^(BOOL success) {
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', %d)", callbackID, success];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    if ([method isEqualToString:@"open"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeDictionary], 1);
        [self open:arguments.firstObject parameters:arguments.count > 1 ? arguments[1] : nil];
        return;
    }
    
    if ([method isEqualToString:@"present"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeNumber], 2);
        [self present:arguments[0] animated:[arguments[1] boolValue] completion:^{
            if ([callbackID isKindOfClass:[NSString class]]) {
                NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@')", callbackID];
                [webView evaluateJavaScript:js completionHandler:nil];
            }
        }];
        return;
    }
    
    
    if ([method isEqualToString:@"push"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeNumber], 2);
        [self push:arguments[0] animated:[arguments[1] boolValue]];
        return;
    }
    
    if ([method isEqualToString:@"pop"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeNumber], 1);
        [self pop:[arguments.firstObject boolValue]];
        return;
    }
    
    if ([method isEqualToString:@"popTo"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeNumber, kArgumentsTypeNumber], 2);
        [self popTo:[arguments[0] integerValue] animated:[arguments[1] boolValue]];
        return;
    }
    
    if ([method isEqualToString:@"setNavigationBarHidden"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeNumber, kArgumentsTypeNumber], 1);
        [self setNavigationBarHidden:[arguments[0] boolValue] animated:[arguments[1] boolValue]];
        return;
    }
    
    if ([method isEqualToString:@"setNavigationBarTitle"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString], 1);
        [self setNavigationBarTitle:arguments.firstObject];
        return;
    }
    
    if ([method isEqualToString:@"setNavigationBarTitleColor"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString], 1);
        [self setNavigationBarTitleColor:[[UIColor alloc] initWithString:arguments[0]]];
        return;
    }
    
    if ([method isEqualToString:@"setNavigationBarBackgroundColor"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString], 1);
        [self setNavigationBarBackgroundColor:[[UIColor alloc] initWithString:arguments[0]]];
        return;
    }
    
    if ([method isEqualToString:@"track"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeDictionary], 1);
        [self track:arguments.firstObject parameters:(arguments.count > 1 ? arguments[1] : nil)];
        return;
    }
    
    
    if ([method isEqualToString:@"http"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeDictionary], 1);
        NSDictionary *dictionary = arguments[0];
        OMWebViewHTTPRequest *request = [[OMWebViewHTTPRequest alloc] initWithMethod:dictionary[@"method"] url:dictionary[@"url"] data:dictionary[@"data"] headers:dictionary[@"headers"]];
        [self http:request completion:^(OMWebViewHTTPResponse * _Nonnull response) {
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
        [self document:arguments[0] numberOfRowsInList:arguments[1] completion:^(NSInteger count) {
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', %ld)", callbackID, (long)count];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    if ([method isEqualToString:@"dataForRowAtIndex"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeString, kArgumentsTypeNumber], 3);
        NSAssert(callbackID != nil, @"The `callbackID` for `dataForRowAtIndex` method does not exist.");
        [self document:arguments[0] list:arguments[1] dataForRowAtIndex:[arguments[2] integerValue] completion:^(NSDictionary * _Nonnull model) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:model options:(NSJSONWritingPrettyPrinted) error:NULL];
            NSString *string = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', %@)", callbackID, string];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    if ([method isEqualToString:@"cachedResourceForURL"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeString, kArgumentsTypeNumber], 3);
        NSAssert(callbackID != nil, @"The `callbackID` for `cachedResourceForURL` method does not exist.");
        NSURL *url = [NSURL URLWithString:arguments[0]];
        if (url == nil) {
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', '%@')", callbackID, arguments[0]];
            [webView evaluateJavaScript:js completionHandler:nil];
            return;
        }
        [self cachedResourceForURL:url resoureType:arguments[1] downloadIfNotExists:[arguments[1] boolValue] completion:^(NSString * resourcePath) {
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', '%@')", callbackID, resourcePath != nil ? resourcePath : @""];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    // event service
    
    if ([method isEqualToString:@"didSelectRowAtIndex"]) {
        kArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeString, kArgumentsTypeNumber], 3);
        [self document:arguments[0] list:arguments[1] didSelectRowAtIndex:[arguments[2] integerValue] completion:^{
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
        [self document:arguments[0] element:arguments[1] wasClicked:(arguments.count > 2 ? arguments[2] : nil) completion:^(BOOL isSelected) {
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


#pragma mark - OMAppSystem


- (void)ready:(void (^)())completion {
    NSLog(@"[OMWebViewMessageHandler] Message `ready(callback)` is not handled.");
}

- (void)login:(void (^)(BOOL))completion {
    NSLog(@"[OMWebViewMessageHandler] Message `login(callback)` is not handled.");
}

- (void)setCurrentTheme:(NSString *)theme {
    NSLog(@"[OMWebViewMessageHandler] Message `setCurrentTheme(%@)` is not handled.", theme);
}

#pragma mark - OMAppRedirection

- (void)open:(NSString *)page parameters:(NSDictionary *)parameters {
    NSLog(@"[OMWebViewMessageHandler] Message `open(%@, %@)` is not handled.", page, parameters);
}

- (void)present:(NSString *)url animated:(BOOL)animated completion:(void (^)())completion {
    NSLog(@"[OMWebViewMessageHandler] Message `present(%@, %d, callback)` is not handled.", url, animated);
}

#pragma mark - OMAppNavigation


- (void)push:(NSString *)url animated:(BOOL)animated {
    NSLog(@"[OMWebViewMessageHandler] Message `push(%@, %d)` is not handled.", url, animated);
}

- (void)pop:(BOOL)animated {
    [_viewController.navigationController popViewControllerAnimated:animated];
}

- (void)popTo:(NSInteger)index animated:(BOOL)animated {
    NSArray *viewControllers = [_viewController.navigationController viewControllers];
    if (index < viewControllers.count && index > 0) {
        [_viewController.navigationController popToViewController:viewControllers[index] animated:animated];
    } else if (index < 0) {
        [_viewController.navigationController popToRootViewControllerAnimated:animated];
    }
}

- (void)setNavigationBarTitle:(NSString *)title {
    _viewController.navigationController.title = title;
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [_viewController.navigationController setNavigationBarHidden:hidden animated:animated];
}

- (void)setNavigationBarTitleColor:(UIColor *)titleColor {
    _viewController.navigationController.navigationBar.tintColor = titleColor;
}

- (void)setNavigationBarBackgroundColor:(UIColor *)backgrondColor {
    _viewController.navigationController.navigationBar.barTintColor = backgrondColor;
}

#pragma mark - OMAppAnalytics

- (void)track:(NSString *)event parameters:(NSDictionary<NSString *,id> *)parameters {
    NSLog(@"[OMWebViewMessageHandler] Message `track(%@, %@)` is not handled.", event, parameters);
}

#pragma mark - OMAppNetworking

- (void)http:(OMWebViewHTTPRequest *)request completion:(void (^)(OMWebViewHTTPResponse * _Nonnull))completion {
    NSLog(@"[OMWebViewMessageHandler] Message `http(%@, callback)` is not handled.", request);
}

#pragma mark - OMAppData

-  (void)document:(NSString *)document numberOfRowsInList:(NSString *)list completion:(void (^)(NSInteger))completion {
    NSLog(@"[OMWebViewMessageHandler] Message `numberOfRowsInList(%@, %@, callback)` is not handled.", document, list);
}

- (void)document:(NSString *)document list:(NSString *)list dataForRowAtIndex:(NSInteger)index completion:(void (^)(NSDictionary<NSString *,id> * _Nonnull))completion {
    NSLog(@"[OMWebViewMessageHandler] Message `dataForRowAtIndex(%@, %@, %ld, callback)` is not handled.", document, list, (long)index);
}

- (void)cachedResourceForURL:(NSURL *)url resoureType:(NSString *)resoureType downloadIfNotExists:(BOOL)download completion:(void (^)(NSString * _Nullable))completion {
    if ([resoureType isEqualToString:@"image"]) {
        [self cachedImageForURL:url completion:completion];
    } else {
        NSLog(@"[OMWebViewMessageHandler] Message `cachedResourceForURL(%@, %@, %d, callback)` is not handled.", url, resoureType, download);
    }
}

- (void)cachedImageForURL:(NSURL *)url completion:(void (^)(NSString * _Nullable))completion {
    [self OMKit_downloadImageWithURL:url retryIfFailed:true completion:completion];
}

- (void)OMKit_manager:(SDWebImageManager *)manager pathForCachedImageWithURL:(NSURL *)url WithCompletion:(void (^)(NSString * _Nullable))completion {
    NSString *imagePath = [manager.imageCache defaultCachePathForKey:[manager cacheKeyForURL:url]];
    if (imagePath != nil && ![imagePath hasPrefix:@"file://"]) {
        imagePath = [NSString stringWithFormat:@"file://%@", imagePath];
    }
    completion(imagePath);
}

- (void)OMKit_downloadImageWithURL:(NSURL *)url retryIfFailed:(BOOL)retryIfFailed completion:(void (^)(NSString * _Nullable))completion {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache) {
            [self OMKit_manager:manager pathForCachedImageWithURL:url WithCompletion:completion];
        } else {
            [manager loadImageWithURL:url options:(SDWebImageAllowInvalidSSLCertificates) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (error != nil && error.code != noErr && retryIfFailed) {
                    // 如果下载发生错误，则重试一次。
                    [self OMKit_downloadImageWithURL:url retryIfFailed:false completion:completion];
                } else {
                    // 如果没有错误，直接加载图片。
                    [self OMKit_manager:manager pathForCachedImageWithURL:url WithCompletion:completion];
                }
            }];
        }
    }];
}


- (void)document:(NSString *)document list:(NSString *)list didSelectRowAtIndex:(NSInteger)index completion:(void (^)())completion {
    NSLog(@"[OMWebViewMessageHandler] Message `didSelectRowAtIndex(%@, %@, %ld, callback)` is not handled.", document, list, (long)index);
}

- (void)document:(NSString *)document element:(NSString *)element wasClicked:(id)data completion:(void (^)(BOOL))completion {
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
