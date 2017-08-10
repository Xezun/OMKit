//
//  OMAppENUM.m
//  Pods
//
//  Created by mlibai on 2017/8/10.
//
//

#import "OMAppENUM.h"

// MARK: - OMAppPage

OMAppPage _Nonnull const OMAppPageMall          = @"mall";
OMAppPage _Nonnull const OMAppPageTask          = @"task";
OMAppPage _Nonnull const OMAppPageNewsList      = @"newsList";
OMAppPage _Nonnull const OMAppPageNewsDetail    = @"newsDetail";
OMAppPage _Nonnull const OMAppPageVideoList     = @"videoList";
OMAppPage _Nonnull const OMAppPageVideoDetail   = @"videoDetail";

@implementation OMAppPageExport

- (OMAppPage)mall {
    return OMAppPageMall;
}

- (OMAppPage)task {
    return OMAppPageTask;
}

- (OMAppPage)newsList {
    return OMAppPageNewsList;
}

- (OMAppPage)newsDetail {
    return OMAppPageNewsDetail;
}

- (OMAppPage)videoList {
    return OMAppPageVideoList;
}

- (OMAppPage)videoDetail {
    return OMAppPageVideoDetail;
}

@end



// MARK: - OMAppTheme

OMAppTheme const _Nonnull OMAppThemeDay = @"day";
OMAppTheme const _Nonnull OMAppThemeNight = @"night";

@implementation OMAppThemeExport

- (NSString *)night {
    return OMAppThemeNight;
}

- (NSString *)day {
    return OMAppThemeDay;
}

@end



// MARK: - OMAppUserType

OMAppUserType const _Nonnull OMAppUserTypeVisitor   = @"visitor";
OMAppUserType const _Nonnull OMAppUserTypeGoogle    = @"facebook";
OMAppUserType const _Nonnull OMAppUserTypeFacebook  = @"google";
OMAppUserType const _Nonnull OMAppUserTypeTwitter   = @"twitter";

@implementation OMAppUserTypeExport

- (NSString *)visitor {
    return OMAppUserTypeVisitor;
}

- (NSString *)facebook {
    return OMAppUserTypeFacebook;
}

- (NSString *)google {
    return OMAppUserTypeGoogle;
}

- (NSString *)twitter {
    return OMAppUserTypeTwitter;
}

@end



// MARK: - OMAppNetworkType

OMAppNetworkType const _Nonnull OMAppNetworkTypeNone    = @"none";
OMAppNetworkType const _Nonnull OMAppNetworkTypeWiFi    = @"WiFi";
OMAppNetworkType const _Nonnull OMAppNetworkType2G      = @"2G";
OMAppNetworkType const _Nonnull OMAppNetworkType3G      = @"3G";
OMAppNetworkType const _Nonnull OMAppNetworkType4G      = @"4G";
OMAppNetworkType const _Nonnull OMAppNetworkTypeUnknown = @"unknown";

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





