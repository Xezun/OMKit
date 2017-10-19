//
//  OMWebViewHTTPRequest.m
//  OMKit
//
//  Created by mlibai on 2017/10/12.
//

#import "OMWebViewManagerHTTPRequest.h"

@implementation OMWebViewManagerHTTPRequest

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
