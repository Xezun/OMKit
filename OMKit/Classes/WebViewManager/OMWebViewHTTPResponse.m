//
//  OMWebViewHTTPResponse.m
//  OMKit
//
//  Created by mlibai on 2017/10/12.
//

#import "OMWebViewHTTPResponse.h"

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

