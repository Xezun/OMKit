//
//  OMApp.m
//  OMKit
//
//  Created by mlibai on 2017/8/31.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

#import "OMAppDelegate.h"
@import ObjectiveC;

//static void (*originalIMP)(id self, SEL _cmd, void* arg0, BOOL arg1, BOOL arg2, id arg3) = NULL;
//
//void interceptIMP (id self, SEL _cmd, void* arg0, BOOL arg1, BOOL arg2, id arg3) {
//    originalIMP(self, _cmd, arg0, TRUE, arg2, arg3);
//}
//
//void setWkWebViewShowKeybord() {
//    Class cls = NSClassFromString(@"WKContentView");
//    SEL originalSelector = NSSelectorFromString(@"_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:");
//    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
//    IMP impOvverride = (IMP) interceptIMP;
//    originalIMP = (void *)method_getImplementation(originalMethod);
//    method_setImplementation(originalMethod, impOvverride);
//}


typedef NSString * ArgumentsType;
static ArgumentsType const kArgumentsTypeString = @"string"; // 字符串
static ArgumentsType const kArgumentsTypeNumber = @"number"; // 数字或布尔值
static ArgumentsType const kArgumentsTypeObject = @"object"; // 任意类型


/** 检查参数。*/
inline static void ArgumentsAssert(NSString *method, NSArray *arguments, NSArray<ArgumentsType> *types) {
    if (arguments.count != types.count) {
        NSString *reson = [NSString stringWithFormat:@"The method expect to have `%ld` arguments, but passed %ld`.", types.count, arguments.count];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reson userInfo:nil];
    }
    for (NSInteger index = 0; index < types.count; index++) {
        if ([types[index] isEqualToString:kArgumentsTypeString]) {
            if ([arguments[index] isKindOfClass:[NSString class]]) {
                continue;
            }
            NSString *reson = [NSString stringWithFormat:@"The argument for method `%@` at `%ld` expect to a string value", method, index];
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reson userInfo:nil];
        }
        if ([types[index] isEqualToString:kArgumentsTypeNumber]) {
            if ([arguments[index] isKindOfClass:[NSNumber class]]) {
                continue;
            }
            NSString *reson = [NSString stringWithFormat:@"The argument for method `%@` at `%ld` expect to a number/bool value", method, index];
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reson userInfo:nil];
        }
        if ([types[index] isEqualToString:kArgumentsTypeObject]) {
            continue;
        }
    }
}




@implementation OMApp

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (instancetype)initWithWebView:(id)webView viewController:(UIViewController *)viewController {
    self = [super init];
    if (self != nil) {
        _viewController = viewController;
        _webView = webView;
    }
    return self;
}

+ (OMApp *)handleMessageForWebView:(WKWebView *)webView viewController:(UIViewController *)viewController {
    OMApp *omApp = [[OMApp alloc] initWithWebView:webView viewController:viewController];
    [webView.configuration.userContentController addScriptMessageHandler:omApp name:@"omApp"];
    NSString *js = @"OMApp.current.delegate = function(message){ window.webkit.messageHandlers.omApp.postMessage(message); }";
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:(WKUserScriptInjectionTimeAtDocumentEnd) forMainFrameOnly:false];
    [webView.configuration.userContentController addUserScript:script];
    return omApp;
}

- (void)removeFromWebView {
    [_webView evaluateJavaScript:@"OMApp.current.delegate = null;" completionHandler:nil];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"omApp"];
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *messageBody = message.body;
    
    if (![messageBody isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *method = messageBody[@"method"];
    if (![method isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSArray *parameters = messageBody[@"parameters"];
    if (parameters != nil && ![parameters isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSString *callbackID = messageBody[@"callbackID"];
    if (callbackID != nil && ![callbackID isKindOfClass:[NSString class]]) {
        return;
    }
    
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
    
    if ([method isEqualToString:@"push"]) {
        ArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeNumber]);
        [self push:arguments[0] animated:[arguments[1] boolValue]];
        return;
    }
    
    if ([method isEqualToString:@"pop"]) {
        ArgumentsAssert(method, arguments, @[kArgumentsTypeNumber]);
        [self pop:[arguments.firstObject boolValue]];
        return;
    }
    
    if ([method isEqualToString:@"popTo"]) {
        ArgumentsAssert(method, arguments, @[kArgumentsTypeNumber, kArgumentsTypeNumber]);
        [self popTo:[arguments[0] integerValue] animated:[arguments[1] boolValue]];
        return;
    }
    
    if ([method isEqualToString:@"wasClicked"]) {
        ArgumentsAssert(method, arguments, @[kArgumentsTypeString, kArgumentsTypeString, kArgumentsTypeObject]);
        [self document:arguments[0] element:arguments[1] wasClickedWithData:arguments[2] completion:^(BOOL isSelected) {
            if (callbackID == nil) {
                return;
            }
            NSString *js = [NSString stringWithFormat:@"omApp.dispatch('%@', %d)", callbackID, isSelected];
            [webView evaluateJavaScript:js completionHandler:nil];
        }];
        return;
    }
    
    NSLog(@"Unperformed Method: %@, %@, %@.", method, arguments, callbackID);
}



- (void)ready:(void (^)())completion {
    completion();
}


- (void)push:(NSString *)url animated:(BOOL)animated {
    
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


- (void)document:(NSString *)document element:(NSString *)element wasClickedWithData:(id)data completion:(void (^)(BOOL))completion {
    
    if ([element isEqualToString:@"Follow Button"]) {
        completion(![data boolValue]);
        return;
    }
    
    if ([element isEqualToString:@"Comments Load More"]) {
        
        return;
    }
}





@end
