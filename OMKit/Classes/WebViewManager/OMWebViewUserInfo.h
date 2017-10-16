//
//  OMWebViewUserInfo.h
//  OMKit
//
//  Created by mlibai on 2017/10/12.
//

#import <Foundation/Foundation.h>

@class WKWebView;

/**
 用户类型枚举。
 对应 js 环境中的 OMApp.UserType 。
 */
typedef NSString *OMWebViewInfoUserType NS_STRING_ENUM NS_SWIFT_NAME(WebViewInfoUserType);
FOUNDATION_EXTERN OMWebViewInfoUserType const OMWebViewInfoUserTypeVisitor;
FOUNDATION_EXTERN OMWebViewInfoUserType const OMWebViewInfoUserTypeGoogle;
FOUNDATION_EXTERN OMWebViewInfoUserType const OMWebViewInfoUserTypeFacebook;
FOUNDATION_EXTERN OMWebViewInfoUserType const OMWebViewInfoUserTypeTwitter;
FOUNDATION_EXTERN OMWebViewInfoUserType const OMWebViewInfoUserTypeWhatsapp;


NS_SWIFT_NAME(WebViewUserInfo)
@interface OMWebViewUserInfo : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) OMWebViewInfoUserType type;
@property (nonatomic) NSInteger coin;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithID:(NSString *)id name:(NSString *)name type:(OMWebViewInfoUserType)type coin:(NSInteger)coin NS_DESIGNATED_INITIALIZER;

- (void)webViewWasReady:(WKWebView *)webView;

@end
