//
//  OMAppExport.h
//  OMKit
//
//  Created by mlibai on 2017/9/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OMAppDelegateExport <NSObject, JSExport>

//ready: (callback: () => void) => void;
- (void)ready:(nonnull JSValue *)completion;

//setCurrentTheme: (newValue: OMApp.Theme) => void;
- (void)setCurrentTheme:(nonnull NSString *)theme;

//login: (callback: (success: boolean) => void) => void;
- (void)login:(nonnull JSValue *)completion;

//open: (page: OMApp.Page, parameters?: any) => void;
JSExportAs(open, - (void)open:(nonnull NSString *)page parameters:(nullable NSDictionary *)parameters);

//present: (url: string, animated?: boolean, completion?: () => void) => void;
JSExportAs(present, - (void)present:(nonnull NSString *)url animated:(BOOL)animated completion:(nullable JSValue *)completion);

//push: (url: string, animated?: boolean) => void;
JSExportAs(push, - (void)push:(NSString *)url animated:(BOOL)animated);

//pop: (animated?: boolean) => void;
- (void)pop:(BOOL)animated;

//popTo: (index: number, animated?: boolean) => void;
JSExportAs(popTo, - (void)popTo:(NSInteger)index animated:(BOOL)animated);

//setNavigationBarHidden: (newValue: boolean) => void;
- (void)setNavigationBarHidden:(BOOL)hidden;

//setNavigationBarTitle: (newValue: string) => void;
- (void)setNavigationBarTitle:(NSString *)title;

//setNavigationBarTitleColor: (newValue: string) => void;
- (void)setNavigationBarTitleColor:(NSString *)titleColor;

//setNavigationBarBackgroundColor: (newValue: string) => void;
- (void)setNavigationBarBackgroundColor:(NSString *)backgrondColor;

//analyticsTrack: (event: string, data?: any) => void;
JSExportAs(track, - (void)track:(NSString *)event parameters:(nullable NSDictionary *)parameters);

// Debug
//ajaxSettings: AJAXSettings;
//setAjaxSettings: (newValue: AJAXSettings) => void;
//ajax: (request: HTTPRequest, callback: (response: HTTPResponse) => void) => void;

//http: (request: HTTPRequest, callback: (response: HTTPResponse) => void) => void;
JSExportAs(http, - (void)http:(NSDictionary *)request completion:(JSValue *)completion);

//numberOfRows: (documentName: string, listName: string, callback: (count: number) => void) => void;
JSExportAs(numberOfRows, - (void)document:(NSString *)document list:(NSString *)list numberOfRows:(nullable JSValue *)completion);

//dataForRowAtIndex: (documentName: string, listName: string, index: number, callback: (data: any) => void) => void;
JSExportAs(dataForRowAtIndex, - (void)document:(NSString *)document list:(NSString *)list dataForRowAtIndex:(NSInteger)index completion:(nullable JSValue *)completion);

//cachedResourceForURL: (url: string, automaticallyDownload: boolean, callback: (filePath: string) => void) => void;
JSExportAs(cachedResourceForURL, - (void)cachedResourceForURL:(NSString *)url downloadIfNotExists:(BOOL)download completion:(nullable JSValue *)completion);

//didSelectRowAtIndex: (documentName: string, listName: string, index: number, completion?: () => void) => void;
JSExportAs(didSelectRowAtIndex, - (void)document:(NSString *)document list:(NSString *)list didSelectRowAtIndex:(NSInteger)index completion:(nullable JSValue *)completion);

//wasClicked: (documentName: string, elementName: string, data: any, callback: (isSelected: boolean) => void) => void;
JSExportAs(wasClicked, - (void)document:(NSString *)document element:(NSString *)element wasClickedWithData:(id)data completion:(nullable JSValue *)completion);


@end
