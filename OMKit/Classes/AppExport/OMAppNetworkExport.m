//
//  OMAppNetworkExport.m
//  Pods
//
//  Created by mlibai on 2017/8/3.
//
//

#import "OMAppNetworkExport.h"

@implementation OMAppNetworkExport

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = OMAppNetworkTypeUnknown;
    }
    return self;
}

- (BOOL)isViaWiFi {
    return [_type isEqualToString:OMAppNetworkTypeWiFi];
}

- (BOOL)isReachable {
    return ![_type isEqualToString:OMAppNetworkTypeNone];
}

@end







