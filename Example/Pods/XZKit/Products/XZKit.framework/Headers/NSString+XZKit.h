//
//  NSString+XZKit.h
//  XZKit
//
//  Created by mlibai on 2018/2/7.
//  Copyright © 2018年 mlibai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XZKit/XZDataDigester.h>


/// 字符串字符大小写样式。
typedef NSString * XZCharacterCase NS_STRING_ENUM NS_SWIFT_NAME(CharacterCase);

/// 字符串字母大写，原始值为 @"%02X" 。
FOUNDATION_EXTERN XZCharacterCase const _Nonnull XZCharacterUpperCase NS_SWIFT_NAME(uppercase);
/// 字符串字母小写，原始值为 @"%02x" 。
FOUNDATION_EXTERN XZCharacterCase const _Nonnull XZCharacterLowerCase NS_SWIFT_NAME(lowercase);

@interface NSString (XZKit)

/// 字符串的小写 MD5 值，字符串必须能转换为 utf8 格式，否则返回空字符串。
@property (nonatomic, readonly, nonnull) NSString *xz_md5 NS_SWIFT_NAME(md5);

/// 字符串的大写 MD5 值，字符串必须能转换为 utf8 格式，否则返回空字符串。
@property (nonatomic, readonly, nonnull) NSString *xz_MD5 NS_SWIFT_NAME(MD5);

/// 字符串的小写 SHA1 值，字符串必须能转换为 utf8 格式，否则返回空字符串。
@property (nonatomic, readonly, nonnull) NSString *xz_sha1 NS_SWIFT_NAME(sha1);

/// 字符串的大写 SHA1 值，字符串必须能转换为 utf8 格式，否则返回空字符串。
@property (nonatomic, readonly, nonnull) NSString *xz_SHA1 NS_SWIFT_NAME(SHA1);

/// 计算字符串摘要，默认 utf8。
///
/// @param algorithm 摘要算法。
/// @param encoding 字符编码。
/// @return 字符串摘要。
- (nullable NSData *)xz_dataByDigestingWithAlgorithm:(XZDataDigesterAlgorithm)algorithm usingEncoding:(NSStringEncoding)encoding NS_SWIFT_NAME(digesting(with:using:));

/// 计算字符串摘要，默认字符编码 utf8。
///
/// @param algorithm 摘要算法。
/// @return 字符串摘要。
- (nullable NSData *)xz_dataByDigestingWithAlgorithm:(XZDataDigesterAlgorithm)algorithm NS_SWIFT_NAME(digesting(with:));


/// 计算字符串摘要，并以 String 形式返回。
///
/// @param algorithm 摘要算法。
/// @param encoding 字符编码。
/// @param characterCase 摘要字符串的样式。
/// @return 字符串摘要。
- (nullable NSString *)xz_stringByDigestingWithAlgorithm:(XZDataDigesterAlgorithm)algorithm usingEncoding:(NSStringEncoding)encoding characterCase:(nonnull XZCharacterCase)characterCase NS_SWIFT_NAME(digesting(with:using:characterCase:));

/// 计算字符串摘要，并以 String 形式返回，默认大写。
///
/// @param algorithm 摘要算法。
/// @param encoding 字符编码。
/// @return 字符串摘要。
- (nullable NSString *)xz_stringByDigestingWithAlgorithm:(XZDataDigesterAlgorithm)algorithm usingEncoding:(NSStringEncoding)encoding NS_SWIFT_NAME(digesting(with:using:));

/// 计算字符串摘要，并以 String 形式返回，默认字符编码 utf8。
///
/// @param algorithm 摘要算法。
/// @param characterCase 摘要字符串的样式。
/// @return 字符串摘要。
- (nullable NSString *)xz_stringByDigestingWithAlgorithm:(XZDataDigesterAlgorithm)algorithm characterCase:(nonnull XZCharacterCase)characterCase NS_SWIFT_NAME(digesting(with:characterCase:));

/// 计算字符串摘要，并以 String 形式返回，默认字符编码 utf8，大写字母。
///
/// @param algorithm 摘要算法。
/// @return 字符串摘要。
- (nullable NSString *)xz_stringByDigestingWithAlgorithm:(XZDataDigesterAlgorithm)algorithm NS_SWIFT_NAME(digesting(with:));


@end



