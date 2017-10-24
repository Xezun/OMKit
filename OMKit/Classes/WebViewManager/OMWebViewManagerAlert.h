//
//  OMWebViewManagerAlert.h
//  OMKit
//
//  Created by mlibai on 2017/10/24.
//

#import <Foundation/Foundation.h>

@interface OMWebViewManagerAlert : NSObject

@property (nonatomic, copy, nonnull, readonly) NSString *title;
@property (nonatomic, copy, nonnull, readonly) NSString *body;
@property (nonatomic, copy, nonnull, readonly) NSArray<NSString *> *actions;


- (nonnull instancetype)init NS_UNAVAILABLE;
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title body:(nonnull NSString *)body actions:(nonnull NSArray *)actions NS_DESIGNATED_INITIALIZER;

@end
