//
//  OMWebViewHTTPRequest.h
//  OMKit
//
//  Created by mlibai on 2017/10/12.
//

#import <Foundation/Foundation.h>

NS_SWIFT_NAME(WebViewManager.HTTPRequest)
@interface OMWebViewManagerHTTPRequest : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *method;
@property (nonatomic, copy, readonly, nonnull) NSString *url;
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, id> *data;
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, NSString *> *headers;

- (nonnull instancetype)initWithMethod:(nonnull NSString *)method url:(nonnull NSString *)url data:(nullable NSDictionary<NSString *, id> *)data headers:(nullable NSDictionary<NSString *, NSString *> *)headers;

@end
