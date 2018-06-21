//
//  XZDataDigester.h
//  XZKit
//
//  Created by M. X. Z. on 16/7/28.
//  Copyright © 2016年 J. W. Z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XZDataDigesterAlgorithm) {
    XZDataDigesterAlgorithmMD2    NS_SWIFT_NAME(MD2) = 1,
    XZDataDigesterAlgorithmMD4    NS_SWIFT_NAME(MD4),
    XZDataDigesterAlgorithmMD5    NS_SWIFT_NAME(MD5),
    XZDataDigesterAlgorithmSHA1   NS_SWIFT_NAME(SHA1),
    XZDataDigesterAlgorithmSHA224 NS_SWIFT_NAME(SHA224),
    XZDataDigesterAlgorithmSHA256 NS_SWIFT_NAME(SHA256),
    XZDataDigesterAlgorithmSHA384 NS_SWIFT_NAME(SHA384),
    XZDataDigesterAlgorithmSHA512 NS_SWIFT_NAME(SHA512)
} NS_SWIFT_NAME(DataDigester.Algorithm);

/**
 XZDataDigester 提供了计算数据摘要的功能。
 @note XZDataDigester 对象设计为大型数据摘要计算，小数据（可单次处理）推荐使用类方法。
 */
NS_SWIFT_NAME(DataDigester) @interface XZDataDigester : NSObject

/**
 *  XZDigestCryptor 使用的算法。
 */
@property (nonatomic, readonly) XZDataDigesterAlgorithm algorithm;

/// XZDataDigester 禁止继承。
- (instancetype)init NS_UNAVAILABLE;

/**
 构造 XZDataDigester 的便利方法。

 @param algorithm 算法。
 @return XZDataDigester 对象。
 */
+ (XZDataDigester *)digesterWithAlgorithm:(XZDataDigesterAlgorithm)algorithm;

/**
 将数据添加到摘要计算中。
 
 @note 此方法被调用多次。
 
 @param data 将 NSData 数据添加到摘要器中进行摘要。
 */
- (void)digest:(NSData *)data;

/**
 获取当前已添加到摘要计算中的数据的摘要的 NSData 形式。
 
 @note 调用此方法后，XZDataDigester 将被重置以进行下一次摘要计算。

 @return NSData
 */
- (nullable NSData *)data;

/**
 *  快速方法，对一个数据直接进行信息摘要，适合对单数据进行信息摘要。对单数据进行摘要时，推荐用此方法，它直接调用系统API进行计算。
 *
 *  @param data      要摘要的数据
 *  @param algorithm 使用的算法
 *
 *  @return 信息的摘要，十六进制的字符串。
 */
+ (nullable NSData *)digest:(NSData *)data algorithm:(XZDataDigesterAlgorithm)algorithm;

@end

NS_ASSUME_NONNULL_END
