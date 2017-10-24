//
//  OMWebViewManagerAlert.m
//  OMKit
//
//  Created by mlibai on 2017/10/24.
//

#import "OMWebViewManagerAlert.h"

@implementation OMWebViewManagerAlert

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body actions:(NSArray *)actions {
    self = [super init];
    if (self != nil) {
        _title = [title copy];
        _body = [body copy];
        _actions = [actions copy];
    }
    return self;
}

@end
