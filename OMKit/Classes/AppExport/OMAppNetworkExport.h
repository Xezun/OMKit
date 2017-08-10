//
//  OMAppNetworkExport.h
//  Pods
//
//  Created by mlibai on 2017/8/3.
//
//

#import <Foundation/Foundation.h>
#import <OMKit/OMAppENUM.h>

@import JavaScriptCore;


NS_SWIFT_NAME(AppNetworkExportProtocol)
@protocol OMAppNetworkExport <NSObject, JSExport>

@property (nonatomic, readonly) BOOL isReachable;
@property (nonatomic, readonly) BOOL isViaWiFi;
@property (nonatomic, readonly, nonnull) OMAppNetworkType type;

@end


NS_SWIFT_NAME(AppNetworkExport)
@interface OMAppNetworkExport : NSObject <OMAppNetworkExport>

@property (nonatomic, nonnull) OMAppNetworkType type;

@end
