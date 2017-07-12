//
//  AppExport.m
//  OCJSCore
//
//  Created by mlibai on 2017/6/16.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import "OMAppExport.h"
@import UIKit;
@import ObjectiveC;

#import "OMAppNavigationExport.h"
#import "OMAppUserExport.h"
#import <OMKit/OMKit-Swift.h>


@interface OMAppHTTPRequest ()
@property (nonatomic, copy, nonnull) NSString *url;
@property (nonatomic, copy, nonnull) NSString *method;
@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *params;
@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *data;
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *headers;
@end


@interface OMAppExport () <OMAppNavigationExportDelegate>
@property (nonatomic, weak) JSContext *context;
@end


@implementation OMAppExport

@synthesize currentUser = _currentUser, currentTheme = _currentTheme, navigation = _navigation;

- (void)dealloc {
#if DEBUG
    NSLog(@"AppExport is dealloc.");
#endif
}

- (instancetype)init {
    return [self initWithNavigation:[[OMAppNavigationExport alloc] init] currentUser:[[OMAppUserExport alloc] init]];
}

- (instancetype)initWithNavigation:(OMAppNavigationExport *)navigation currentUser:(OMAppUserExport *)currentUser {
    self = [super init];
    if (self != nil) {
        _currentUser = currentUser;
        _navigation = navigation;
        _navigation.delegate = self;
    }
    return self;
}

- (void)setCurrentTheme:(NSString *)currentTheme {
    _currentTheme = currentTheme;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate appExport:self currentTheme:currentTheme];
    });
}

- (NSString *)theme {
    return [self currentTheme];
}

- (void)setTheme:(NSString *)theme {
    [self setCurrentTheme:theme];
}

- (void)login:(JSValue *)completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate appExport:self login:^(BOOL success) {
            [completion callWithArguments:@[@(success)]];
        }];
    });
}

- (void)open:(NSString *)page parameters:(nullable NSDictionary<NSString *,id> *)parameters {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate appExport:self open:page parameters:parameters];
    });
}

- (void)present:(NSString *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate appExport:self present:url];
    });
}

- (void)http:(NSDictionary<NSString *,id> *)request completion:(JSValue *)completion {
    // TODO:  不确定 JSValue 在异步请求的过程中是否会被释放。JSManagedValue
    OMAppHTTPRequest *object = [[OMAppHTTPRequest alloc] init];
    object.url      = request[@"url"];
    object.method   = request[@"method"];
    object.headers  = request[@"headers"];
    object.params   = request[@"params"];
    object.data     = request[@"data"] != nil ? request[@"data"] : request[@"params"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate appExport:self http:object completion:^(BOOL success, id _Nullable result) {
            if (completion == nil) {
                return;
            }
            NSMutableArray *arguments = [NSMutableArray arrayWithObject:@(success)];
            if (result != nil) {
                [arguments addObject:result];
            }
            [completion callWithArguments:arguments];
        }];
    });
}

- (void)alert:(NSDictionary<NSString *,id> *)message completion:(JSValue *)completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = message[@"title"];
        if (![title isKindOfClass:[NSString class]]) {
            title = [NSBundle mainBundle].displayName;
        }
        NSString *body = message[@"body"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:body preferredStyle:(UIAlertControllerStyleAlert)];
        NSArray<NSString *> *actions = message[@"actions"];
        if ([actions isKindOfClass:[NSArray class]] && completion != nil) {
            [actions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [completion callWithArguments:@[@(idx)]];
                }];
                [alert addAction:action];
            }];
        } else {
            NSString *title = NSLocalizedString(@"确定", @"HTML 页面显示 alert 的默认 “确定” 按钮，请在国际化文件中适配此文字。");
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:nil];
            [alert addAction:action];
        }
        [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
    });
}


#pragma mark - OMAppNavigationExportDelegate


- (void)navigation:(OMAppNavigationExport *)navigation push:(NSString *)url animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate appExport:self navigationPush:url animated:animated];
    });
}

- (void)navigation:(OMAppNavigationExport *)navigation pop:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate appExport:self navigationPop:animated];
    });
}

- (void)navigation:(OMAppNavigationExport *)navigation popTo:(NSInteger)index animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate appExport:self navigationPopTo:index animated:animated];
    });
}

- (void)navigation:(OMAppNavigationExport *)navigation title:(nullable NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate appExport:self updateNavigationBarTitle:title];
    });
}

- (void)navigation:(OMAppNavigationExport *)navigation titleColor:(NSString *)titleColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIColor *color = [[UIColor alloc] initWithString:titleColor];
        [_delegate appExport:self updateNavigationBarTitleColor:color];
    });
}

- (void)navigation:(OMAppNavigationExport *)navigation isHidden:(BOOL)isHidden {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate appExport:self updateNavigationBarVisibility:isHidden];
    });
}

- (void)navigation:(OMAppNavigationExport *)navigation backgroundColor:(NSString *)backgroundColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIColor *color = [[UIColor alloc] initWithString:backgroundColor];
        [_delegate appExport:self updateNavigationBarBackgroundColor:color];
    });
}

@end











OMAppPage _Nonnull const OMAppPageMall          = @"mall";
OMAppPage _Nonnull const OMAppPageTask          = @"task";
OMAppPage _Nonnull const OMAppPageNewsList      = @"newsList";
OMAppPage _Nonnull const OMAppPageNewsDetail    = @"newsDetail";
OMAppPage _Nonnull const OMAppPageVideoList     = @"videoList";
OMAppPage _Nonnull const OMAppPageVideoDetail   = @"videoDetail";

@implementation OMAppPageExport

- (OMAppPage)mall {
    return OMAppPageMall;
}

- (OMAppPage)task {
    return OMAppPageTask;
}

- (OMAppPage)newsList {
    return OMAppPageNewsList;
}

- (OMAppPage)newsDetail {
    return OMAppPageNewsDetail;
}

- (OMAppPage)videoList {
    return OMAppPageVideoList;
}

- (OMAppPage)videoDetail {
    return OMAppPageVideoDetail;
}

@end




OMAppTheme const _Nonnull OMAppThemeDay = @"day";
OMAppTheme const _Nonnull OMAppThemeNight = @"night";

@implementation OMAppThemeExport

- (NSString *)night {
    return OMAppThemeNight;
}

- (NSString *)day {
    return OMAppThemeDay;
}

@end



@implementation OMAppHTTPRequest

- (NSString *)description {
    return [NSString stringWithFormat:@"url: %@, method: %@, params: %@, headers: %@", self.url, self.method, self.params, self.headers];
}

@end
