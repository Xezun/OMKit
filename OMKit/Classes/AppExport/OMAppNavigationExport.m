//
//  AppNavigationExport.m
//  OCJSCore
//
//  Created by mlibai on 2017/6/16.
//  Copyright © 2017年 mlibai. All rights reserved.
//

#import "OMAppNavigationExport.h"
#import "OMAppExport.h"


@class OMAppNavigationBarExport;
@protocol OMAppNavigationBarExportDelegate <NSObject>

- (void)bar:(OMAppNavigationBarExport *)bar title:(nullable NSString *)title;
- (void)bar:(OMAppNavigationBarExport *)bar titleColor:(NSString *)titleColor;
- (void)bar:(OMAppNavigationBarExport *)bar isHidden:(BOOL)isHidden;
- (void)bar:(OMAppNavigationBarExport *)bar backgroundColor:(NSString *)backgroundColor;

@end

@interface OMAppNavigationBarExport : NSObject <OMAppNavigationBarExport>
@property (nonatomic, weak, nullable, readonly) id<OMAppNavigationBarExportDelegate> delegate;
- (instancetype)initWithDelegate:(id<OMAppNavigationBarExportDelegate>)delegate;
@end




// ---

@interface OMAppNavigationExport () <OMAppNavigationBarExportDelegate>

@end

@implementation OMAppNavigationExport

@synthesize bar = _bar;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _bar = [[OMAppNavigationBarExport alloc] initWithDelegate:self];
    }
    return self;
}

- (void)push:(NSString *)url animated:(BOOL)animated {
    [_delegate navigation:self push:url animated:animated];
}

- (void)pop:(BOOL)animated {
    [_delegate navigation:self pop:animated];
}

- (void)popTo:(NSInteger)index animated:(BOOL)animated {
    [_delegate navigation:self popTo:index animated:animated];
}

- (void)bar:(OMAppNavigationBarExport *)bar title:(nullable NSString *)title {
    [_delegate navigation:self title:title];
}

- (void)bar:(OMAppNavigationBarExport *)bar titleColor:(NSString *)titleColor {
    [_delegate navigation:self titleColor:titleColor];
}

- (void)bar:(OMAppNavigationBarExport *)bar isHidden:(BOOL)isHidden {
    [_delegate navigation:self isHidden:isHidden];
}

- (void)bar:(OMAppNavigationBarExport *)bar backgroundColor:(NSString *)backgroundColor {
    [_delegate navigation:self backgroundColor:backgroundColor];
}

@end













@implementation OMAppNavigationBarExport

@synthesize isHidden = _isHidden, title = _title, titleColor = _titleColor, backgoundColor = _backgoundColor;

- (instancetype)initWithDelegate:(id<OMAppNavigationBarExportDelegate>)delegate {
    self = [super init];
    if (self != nil) {
        _delegate = delegate;
    }
    return self;
}

- (void)setIsHidden:(BOOL)isHidden {
    _isHidden = isHidden;
    [_delegate bar:self isHidden:_isHidden];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_delegate bar:self title:_title];
}

- (void)setTitleColor:(NSString *)titleColor {
    _titleColor = titleColor;
    [_delegate bar:self titleColor:titleColor];
}

- (void)setBackgoundColor:(NSString *)backgoundColor {
    _backgoundColor = backgoundColor;
    [_delegate bar:self backgroundColor:backgoundColor];
}

@end
