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
        _type = OMAppNetworkTypeUnkonwn;
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


OMAppNetworkType const _Nonnull OMAppNetworkTypeNone    = @"none";
OMAppNetworkType const _Nonnull OMAppNetworkTypeWiFi    = @"WiFi";
OMAppNetworkType const _Nonnull OMAppNetworkType2G      = @"2G";
OMAppNetworkType const _Nonnull OMAppNetworkType3G      = @"3G";
OMAppNetworkType const _Nonnull OMAppNetworkType4G      = @"4G";
OMAppNetworkType const _Nonnull OMAppNetworkTypeUnkonwn = @"unknown";
