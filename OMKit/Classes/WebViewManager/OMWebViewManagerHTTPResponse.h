//
//  OMWebViewHTTPResponse.h
//  OMKit
//
//  Created by mlibai on 2017/10/12.
//

#import <Foundation/Foundation.h>

NS_SWIFT_NAME(WebViewManager.HTTPResponse)
@interface OMWebViewManagerHTTPResponse : NSObject

@property (nonatomic, readonly) NSInteger code;
@property (nonatomic, readonly, nonnull) NSString *message;
@property (nonatomic, readonly, nullable) id data;
@property (nonatomic, readonly, nonnull) NSString *contentType;

- (nonnull instancetype)initWithCode:(NSInteger)code message:(nonnull NSString *)message data:(nullable id)data contentType:(nonnull NSString *)contentType;

@end
