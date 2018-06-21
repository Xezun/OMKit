//
//  NSData+XZKit.h
//  XZKit
//
//  Created by mlibai on 2018/2/8.
//  Copyright © 2018年 mlibai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XZKit/NSString+XZKit.h>

// NSData 与 Swift.Data 不是自动桥接的。
@interface NSData (XZKit)

/// 返回数据的十六进制字符串形式，默认大写字母。
@property (nonatomic, readonly, nonnull) NSString *xz_hexadecimalEncodedString NS_SWIFT_NAME(hexadecimalEncodedString);

/// 按指定大小写形式，返回数据的十六进制字符串形式。
///
/// @param characterCase 大写或小写。
/// @return 数据的十进制形式。
- (nonnull NSString *)xz_hexadecimalEncodedStringWithCharacterCase:(nonnull XZCharacterCase)characterCase NS_SWIFT_NAME(hexadecimalEncodedString(with:));

/// 用十六进制的数字字符串构造 NSData 对象。
///
/// @note 字符串长度是偶数。
/// @note 为了提高性能，请确保字符串且不能包含除 /0-9A-Fa-f/ 以外的字符。
///
/// @param hexadecimalEncodedString 十六进制数字的字符串。
/// @return NSData
+ (nullable NSData *)xz_dataWithHexadecimalEncodedString:(nonnull NSString *)hexadecimalEncodedString NS_SWIFT_NAME(init(hexadecimalEncoded:));

@end
