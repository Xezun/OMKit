//
//  AppUserExport.m
//  OCJSCore
//
//  Created by mlibai on 2017/6/16.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import "OMAppUserExport.h"
#import <OMKit/OMAppENUM.h>


@implementation OMAppUserExport

@synthesize id = _id, name = _name, coin = _coin, type = _type, token = _token;

- (instancetype)init {
    self = [super init];
    if (self) {
        _id = nil;
        _name = nil;
        _coin = 0;
        _token = nil;
        _type = OMAppUserTypeVisitor;
    }
    return self;
}

- (BOOL)isOnline {
    return (_type != nil && ![self.type isEqualToString:OMAppUserTypeVisitor]);
}

@end



