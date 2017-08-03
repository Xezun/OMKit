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


@implementation OMAppNetworkTypeExport

- (NSString *)none {
    return  OMAppNetworkTypeNone;
}

- (NSString *)WiFi {
    return OMAppNetworkTypeWiFi;
}

- (NSString *)WWan2G {
    return OMAppNetworkType2G;
}

- (NSString *)WWan3G {
    return  OMAppNetworkType3G;
}

- (NSString *)WWan4G {
    return OMAppNetworkType4G;
}

- (NSString *)unknown {
    return OMAppNetworkTypeUnknown;
}

@end


OMAppNetworkType const _Nonnull OMAppNetworkTypeNone    = @"none";
OMAppNetworkType const _Nonnull OMAppNetworkTypeWiFi    = @"WiFi";
OMAppNetworkType const _Nonnull OMAppNetworkType2G      = @"2G";
OMAppNetworkType const _Nonnull OMAppNetworkType3G      = @"3G";
OMAppNetworkType const _Nonnull OMAppNetworkType4G      = @"4G";
OMAppNetworkType const _Nonnull OMAppNetworkTypeUnknown = @"unknown";

