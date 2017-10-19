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
typedef NSString *OMWebViewManagerUserType NS_STRING_ENUM NS_SWIFT_NAME(WebViewManager.UserType);
FOUNDATION_EXTERN OMWebViewManagerUserType const _Nonnull OMWebViewManagerUserTypeVisitor;
FOUNDATION_EXTERN OMWebViewManagerUserType const _Nonnull OMWebViewManagerUserTypeGoogle;
FOUNDATION_EXTERN OMWebViewManagerUserType const _Nonnull OMWebViewManagerUserTypeFacebook;
FOUNDATION_EXTERN OMWebViewManagerUserType const _Nonnull OMWebViewManagerUserTypeTwitter;
FOUNDATION_EXTERN OMWebViewManagerUserType const _Nonnull OMWebViewManagerUserTypeWhatsapp;


NS_SWIFT_NAME(WebViewManager.User)
@interface OMWebViewManagerUser : NSObject

@property (nonatomic, copy, nonnull) NSString *id;
@property (nonatomic, copy, nonnull) NSString *name;
@property (nonatomic, copy, nonnull) OMWebViewManagerUserType type;
@property (nonatomic) NSInteger coin;

- (nonnull instancetype)init NS_UNAVAILABLE;
- (nonnull instancetype)initWithID:(nonnull NSString *)id name:(nonnull NSString *)name type:(nonnull OMWebViewManagerUserType)type coin:(NSInteger)coin NS_DESIGNATED_INITIALIZER;

- (void)webViewWasReady:(nonnull WKWebView *)webView;

@end
