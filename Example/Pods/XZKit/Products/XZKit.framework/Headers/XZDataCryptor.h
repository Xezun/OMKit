//
//  XZDataCryptor.h
//  XZKit
//
//  Created by mlibai on 2018/2/6.
//  Copyright © 2018年 mlibai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 描述 XZDataCryptor 执行的行为。
 
 - XZDataCryptorOperationEncrypt: 加密操作。
 - XZDataCryptorOperationDecrypt: 解密操作。
 */
typedef NS_ENUM(uint32_t/*CCOperation*/, XZDataCryptorOperation) {
    /// 加密操作。
    XZDataCryptorOperationEncrypt = 0 /*kCCEncrypt*/,
    /// 解密操作。
    XZDataCryptorOperationDecrypt /*kCCDecrypt*/
} NS_SWIFT_NAME(DataCryptor.Operation);

/**
 当使用块加密方式时，数据可能不会正好填满块，此枚举值描述了 XZDataCryptor 填充数据的方式。
 
 - XZDataCryptorNoPadding: 不填充。
 - XZDataCryptorPKCS7Padding: PKCS7 填充（数据差n位就填充n到最后一块，块数据正好表示差一个块）。
 */
typedef NS_ENUM(uint32_t/*CCPadding*/, XZDataCryptorPadding) {
    /// 无填充。
    XZDataCryptorNoPadding NS_SWIFT_NAME(none) = 0 /*ccNoPadding*/,
    /// PKCS7 方式填充。
    XZDataCryptorPKCS7Padding NS_SWIFT_NAME(PKCS7) = 1 /*ccPKCS7Padding*/
} NS_SWIFT_NAME(DataCryptor.Padding);

@class XZDataCryptorMode, XZDataCryptorAlgorithm;

NS_ASSUME_NONNULL_BEGIN

/**
 XZDataCryptor 提供了数据的对称加密功能，封装了 CommonCrypto 框架。
 @note XZDataCryptor 对象设计为大型数据加密，小数据（可单次处理）推荐使用静态方法。
 */
NS_SWIFT_NAME(DataCryptor) @interface XZDataCryptor: NSObject

/// 操作类型。
@property (nonatomic, readonly) XZDataCryptorOperation operation;

/// 算法。
@property (nonatomic, copy, readonly) XZDataCryptorAlgorithm *algorithm;

/// 模式。
@property (nonatomic, strong, readonly) XZDataCryptorMode *mode;

/// 填充模式。
@property (nonatomic, readonly) XZDataCryptorPadding padding;


- (instancetype)init NS_UNAVAILABLE;


/**
 构造 XZDataCryptor 的便利方法。 XZDataCryptor 被设计为只处理一种加密/解密任务，从而方便开发者根据具体业务确定是否需要重复利用同一个 Cryptor 来处理需求。
 
 @param operation 加密/解密。
 @param algorithm 加密/解密算法。
 @param mode 加密/解密模式。
 @param padding 补齐方式。
 @param error 如果 XZDataCryptor 创建失败，此处会返回 error 。
 @return XZDataCryptor 对象。
 */
+ (nullable XZDataCryptor *)cryptorWithAlgorithm:(XZDataCryptorAlgorithm *)algorithm operation:(XZDataCryptorOperation)operation mode:(XZDataCryptorMode *)mode padding:(XZDataCryptorPadding)padding error:(NSError *__autoreleasing  _Nullable * _Nullable)error NS_SWIFT_NAME(init(algorithm:operation:mode:padding:));

/**
 执行加密/解密数据。
 
 @param data 待加密/解密的数据。
 @param isFinalData 当前数据是否为待加密/解密的全部数据或最后一块数据。
 @param error 错误信息。
 @return 加密/解密后的数据。
 */
- (nullable NSData *)crypt:(nullable NSData *)data final:(BOOL)isFinalData error:(NSError * _Nullable __autoreleasing * _Nullable)error;

/**
 重置 XZDataCryptor，可以选择是否使用新的 mode 。
 
 @param mode 加密模式，特别是 CBC 模式时，初始化向量可能每次都需要变更。
 @param error 错误信息。
 */
- (BOOL)resetWithMode:(nullable XZDataCryptorMode *)mode error:(NSError * _Nullable __autoreleasing * _Nullable)error;

@end


@interface XZDataCryptor (XZExtendedDataCryptor)

/**
 构造加密的 XZDataCryptor 便利方法。
 
 @param algorithm 加密/解密算法。
 @param mode 加密/解密模式。
 @param padding 补齐方式。
 @param error 如果 XZDataCryptor 创建失败，此处会返回 error 。
 @return XZDataCryptor 对象。
 */
+ (nullable XZDataCryptor *)encryptorWithAlgorithm:(XZDataCryptorAlgorithm *)algorithm mode:(XZDataCryptorMode *)mode padding:(XZDataCryptorPadding)padding error:(NSError * _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(init(encryptor:mode:padding:));

/**
 构造解密的 XZDataCryptor 便利方法。
 
 @param algorithm 加密/解密算法。
 @param mode 加密/解密模式。
 @param padding 补齐方式。
 @param error 如果 XZDataCryptor 创建失败，此处会返回 error 。
 @return XZDataCryptor 对象。
 */
+ (nullable XZDataCryptor *)decryptorWithAlgorithm:(XZDataCryptorAlgorithm *)algorithm mode:(XZDataCryptorMode *)mode padding:(XZDataCryptorPadding)padding error:(NSError * _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(init(decryptor:mode:padding:));

/**
 使用 CBC 模式，PKCS7 填充方式，创建的 AES 加/解密的 XZDataCryptor 对象的便利方法。
 
 @param operation 加密/解密。
 @param key 密钥。
 @param vector 初始化向量。
 @param error 如果 XZDataCryptor 创建失败，此处会返回 error 。
 @return XZDataCryptor 对象。
 */
+ (nullable XZDataCryptor *)AESCryptorWithOperation:(XZDataCryptorOperation)operation key:(NSString *)key vector:(NSString *)vector error:(NSError * _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(init(AESCryptor:key:vector:));


/**
 使用 CBC 模式，PKCS7 填充方式，创建 DES 加/解密的 XZDataCryptor 对象的便利方法。

 @param operation 加密/解密。
 @param key 密钥。
 @param error 如果 XZDataCryptor 创建失败，此处会返回 error 。
 @return XZDataCryptor 对象。
 */
+ (nullable XZDataCryptor *)DESCryptorWithOperation:(XZDataCryptorOperation)operation key:(NSString *)key vector:(NSString *)vector error:(NSError * _Nullable __autoreleasing * _Nullable)error NS_SWIFT_NAME(init(DESCryptor:key:vector:));

/**
 加密/解密数据的便利方法。
 
 @note 当数据较小可以单独处理时，使用此方法要比使用实例化 XZDataCryptor 对象效率更好。
 @note 此方法只支持使用 ECB 、CBC（noPadding/PKCS7Padding）模式。

 @param data 待加密/解密的数据。
 @param algorithm 加密/解密算法。
 @param operation 加密/解密。
 @param mode 加密/解密模式。
 @param padding 加密/解密填充模式。
 @param error 错误输出。
 @return 加密/解密后的数据。
 */
+ (nullable NSData *)crypt:(NSData *)data algorithm:(XZDataCryptorAlgorithm *)algorithm operation:(XZDataCryptorOperation)operation mode:(XZDataCryptorMode *)mode padding:(XZDataCryptorPadding)padding error:(NSError *__autoreleasing  _Nullable * _Nullable)error;

/**
 加密数据的便利方法。
 
 @note 当数据较小可以单独处理时，使用此方法要比使用实例化 XZDataCryptor 对象效率更好。
 @note 此方法只支持使用 ECB 、CBC（noPadding/PKCS7Padding）模式。

 @param data 待加密/解密的数据。
 @param algorithm 加密/解密算法。
 @param mode 加密/解密模式。
 @param padding 加密/解密填充模式。
 @param error 错误输出。
 @return 加密/解密后的数据。
 */
+ (nullable NSData *)encrypt:(NSData *)data algorithm:(XZDataCryptorAlgorithm *)algorithm mode:(XZDataCryptorMode *)mode padding:(XZDataCryptorPadding)padding error:(NSError *__autoreleasing  _Nullable * _Nullable)error;

/**
 解密数据的便利方法。
 
 @note 当数据较小可以单独处理时，使用此方法要比使用实例化 XZDataCryptor 对象效率更好。
 @note 此方法只支持使用 ECB 、CBC（noPadding/PKCS7Padding）模式。

 @param data 待加密/解密的数据。
 @param algorithm 加密/解密算法。
 @param mode 加密/解密模式。
 @param padding 加密/解密填充模式。
 @param error 错误输出。
 @return 加密/解密后的数据。
 */
+ (nullable NSData *)decrypt:(NSData *)data algorithm:(XZDataCryptorAlgorithm *)algorithm mode:(XZDataCryptorMode *)mode padding:(XZDataCryptorPadding)padding error:(NSError *__autoreleasing  _Nullable * _Nullable)error;

/**
 AES 加密/解密的便利方法。
 
 @note 当数据较小可以单独处理时，使用此方法要比使用实例化 XZDataCryptor 对象效率更好。
 @note 此方法使用 CBC 模式加密，PKCS7 方式填充。

 @param data 待加密/解密的数据。
 @param operation 加密/解密。
 @param key 密钥。
 @param vector 初始化向量。
 @param error 错误输出。
 @return 加密/解密后的数据。
 */
+ (nullable NSData *)AES:(NSData *)data operation:(XZDataCryptorOperation)operation key:(NSString *)key vector:(NSString *)vector error:(NSError *__autoreleasing  _Nullable * _Nullable)error NS_SWIFT_NAME(AES(_:operation:key:vector:));

/**
 DES 加密/解密的便利方法。

 @note 当数据较小可以单独处理时，使用此方法要比使用实例化 XZDataCryptor 对象效率更好。
 @note 此方法使用 CBC 模式加密，PKCS7 方式填充。
 
 @param data 待加密/解密的数据。
 @param operation 加密/解密。
 @param key 密钥。
 @param vector 初始化向量。
 @param error 错误输出。
 @return 加密/解密后的数据。
 */
+ (nullable NSData *)DES:(NSData *)data operation:(XZDataCryptorOperation)operation key:(NSString *)key vector:(NSString *)vector error:(NSError *__autoreleasing  _Nullable * _Nullable)error NS_SWIFT_NAME(DES(_:operation:key:vector:));

@end








/// 加密/解密模式。
/// @note 对称加密的模式决定了是否需要额外的参数：初始化向量或可调整值。
/// @note 不同模式提供了不同的构造方法，
/// @note 在加/解密时，实际参与计算对 vector/tweak 的长度与块大小相同，如果不足补 `\0` 。
NS_SWIFT_NAME(DataCryptor.Mode) @interface XZDataCryptorMode: NSObject

/** 加密/解密模式的原始值。 */
@property (nonatomic, readonly) uint32_t /*CCMode*/ mode;

/** 初始化向量，只有在部分模式下可用。 */
@property (nonatomic, copy, readonly, nullable) NSString *vector;

/** AES-XTS 模式下的可调整值。 */
@property (nonatomic, copy, readonly, nullable) NSString *tweak;

- (instancetype)init NS_UNAVAILABLE;

/**
 ECB 电码本加密模式，将整个明文分成若干段相同的小段，然后对每一小段进行加密。
 @note 不建议使用。
 */
@property (class, nonatomic, readonly) XZDataCryptorMode *ECBMode NS_SWIFT_NAME(ECB);

/**
 CBC 密码分组链接模式。先将明文切分成若干小段，然后每一小段与初始块或者上一段的密文段进行异或运算后，再与密钥进行加密。
。
 
 @note 向量长度一般与块大小相同，请参考 XZDataCryptorAlgorithm 中的说明。
 @note 初始化向量在使用时，如果长度小于块大小，末尾自动补 \0 。
 
 @param vector 初始化向量。
 @return 加密/解密模式。
 */
+ (XZDataCryptorMode *)CBCModeWithVector:(nullable NSString *)vector NS_SWIFT_NAME(CBC(_:));

/**
 CFB 密码反馈模式。
 
 @note 向量长度一般与块大小相同，请参考 XZDataCryptorAlgorithm 中的说明。
 @note 初始化向量在使用时，如果长度小于块大小，末尾自动补 \0 。
 
 @param vector 初始化向量。
 @return 加密/解密模式。
 */
+ (XZDataCryptorMode *)CFBModeWithVector:(nullable NSString *)vector NS_SWIFT_NAME(CFB(_:));

/**
 CTR 计算器模式。计算器模式不常见，在CTR模式中， 有一个自增的算子，这个算子用密钥加密之后的输出和明文异或的结果得到密文，相当于一次一密。这种加密方式简单快速，安全可靠，而且可以并行加密，但是在计算器不能维持很长的情况下，密钥只能使用一次。
 
 @note 向量长度一般与块大小相同，请参考 XZDataCryptorAlgorithm 中的说明。
 @note 初始化向量在使用时，如果长度小于块大小，末尾自动补 \0 。
 
 @param vector 初始化向量。
 @return 加密/解密模式。
 */
+ (XZDataCryptorMode *)CTRModeWithVector:(nullable NSString *)vector NS_SWIFT_NAME(CTR(_:));

@property (class, nonatomic, readonly) XZDataCryptorMode *F8Mode NS_UNAVAILABLE;
@property (class, nonatomic, readonly) XZDataCryptorMode *LRWMode NS_UNAVAILABLE;

/**
 OFB 输出反馈模式。
 
 @note 向量长度一般与块大小相同，请参考 XZDataCryptorAlgorithm 中的说明。
 @note 初始化向量在使用时，如果长度小于块大小，末尾自动补 \0 。
 
 @param vector 初始化向量。
 @return 加密/解密模式。
 */
+ (XZDataCryptorMode *)OFBModeWithVector:(nullable NSString *)vector NS_SWIFT_NAME(OFB(_:));

/**
 XTS 基于XEX(XOR-ENCRYPT-XOR)的密文窃取算法的可调整的密码本模式。
 
 @note 向量长度一般与块大小相同，请参考 XZDataCryptorAlgorithm 中的说明。
 @note 可调整值在使用时，如果长度小于块大小，末尾自动补 \0 。
 
 @param tweak 可调整值。
 @return 加密/解密模式。
 */
+ (XZDataCryptorMode *)XTSModeWithTweak:(nullable NSString *)tweak NS_SWIFT_NAME(XTS(_:));

/** RC4 模式。 */
@property (class, nonatomic, readonly) XZDataCryptorMode *RC4Mode NS_SWIFT_NAME(RC4);

/**
 CFB8 模式。
 
 @note 向量长度一般与块大小相同，请参考 XZDataCryptorAlgorithm 中的说明。
 @note 初始化向量在使用时，如果长度小于块大小，末尾自动补 \0 。
 
 @param vector 初始化向量。
 @return 加密/解密模式。
 */
+ (XZDataCryptorMode *)CFB8ModeWithVector:(nullable NSString *)vector NS_SWIFT_NAME(CFB8(_:));

/// 相同的构造方法创建的 XZDataCryptorMode 都相等。
- (BOOL)isEqual:(nullable id)object;

/// 算法名称。
- (NSString *)description;

@end









/// 加密/解密算法。
/// @note 算法决定了密钥的长度。
NS_SWIFT_NAME(DataCryptor.Algorithm) @interface XZDataCryptorAlgorithm : NSObject <NSCopying>

/// 算法加密/解密块的大小。
@property (nonatomic, readonly) size_t blockSize;

/// 仅供参考，XZCryptor 核心 CCCryptor 所需的最小内存。
@property (nonatomic, readonly) size_t contextSize;

/// 加密轮数。默认 0，使用算法默认轮数。
@property (nonatomic) int numberOfRounds;

/// 加密/解密的密钥，密钥自动修正，可能与实际输入的不同。
@property (nonatomic, readonly) NSString *key;

/**
 AES 算法，密钥长度 16/24/32 字节，块大小 16 字节。
 
 @note 根据密钥长度自动确定算法 AES128/AES192/AES256 。
 @note 密钥长度 <= 16 时，使用 AES128 算法。
 @note 密钥长度 <= 24 时，使用 AES192 算法。
 @note 密钥长度  > 24 时，使用 AES256 算法。
 
 @param key 密钥字符串。
 @return XZDataCryptorAlgorithm 对象ß
 */
+ (XZDataCryptorAlgorithm *)AESAlgorithmWithKey:(NSString *)key NS_SWIFT_NAME(AES(_:));

/**
 DES 算法，密钥长度 8 字节，块大小 8 字节。
 
 @note 如果密钥长度不是 8，则默认为 0 ，超出截取，不足补 \0 。
 
 @param key 密钥字符串。
 @return XZDataCryptorAlgorithm 对象
 */
+ (XZDataCryptorAlgorithm *)DESAlgorithmWithKey:(NSString *)key NS_SWIFT_NAME(DES(_:));

/**
 3DES 算法，密钥长度 24 字节，块大小 8 字节。
 
 @note 如果密钥长度不是 24，则默认为 24 ，超出截取，不足补 \0 。
 
 @param key 密钥字符串。
 @return XZDataCryptorAlgorithm 对象
 */
+ (XZDataCryptorAlgorithm *)TripleDESAlgorithmWithKey:(NSString *)key NS_SWIFT_NAME(TripleDES(_:));

/**
 CAST 算法，密钥长度 5-16 字节，块大小 8 字节。
 
 @note 如果密钥长度不足 5，则末尾补 \0 到 5 位，如果大于 16，将截取前 16 位。
 
 @param key 密钥字符串。
 @return XZDataCryptorAlgorithm 对象
 */
+ (XZDataCryptorAlgorithm *)CASTAlgorithmWithKey:(NSString *)key NS_SWIFT_NAME(CAST(_:));

/**
 RC4 算法，密钥长度 1-512 字节，块大小 8 字节。
 
 @note 如果密钥长度不足 1，则末尾补 \0 到 1 位，如果大于 512，将截取前 512 位。
 
 @param key 密钥字符串。
 @return XZDataCryptorAlgorithm 对象
 */
+ (XZDataCryptorAlgorithm *)RC4AlgorithmWithKey:(NSString *)key NS_SWIFT_NAME(RC4(_:));

/**
 RC2 算法，密钥长度 1-128 字节，块大小 8 字节。
 
 @note 如果密钥长度不足 1，则末尾补 \0 到 1 位，如果大于 128，将截取前 128 位。
 
 @param key 密钥字符串。
 @return XZDataCryptorAlgorithm 对象
 */
+ (XZDataCryptorAlgorithm *)RC2AlgorithmWithKey:(NSString *)key NS_SWIFT_NAME(RC2(_:));

/**
 Blowfish 算法，密钥长度 8-56 字节，块大小 8 字节。
 
 @note 如果密钥长度不足 8，则末尾补 \0 到 8 位，如果大于 56，将截取前 56 位。
 
 @param key 密钥字符串。
 @return XZDataCryptorAlgorithm 对象
 */
+ (XZDataCryptorAlgorithm *)BlowfishAlgorithmWithKey:(NSString *)key NS_SWIFT_NAME(Blowfish(_:));

- (instancetype)init NS_UNAVAILABLE;

/**
 同一构造方法创建的 XZDataCryptorAlgorithm 使用此方法相同（因此可以在 Swift 中可以当做枚举使用）。
 */
- (BOOL)isEqual:(nullable id)object;

/// 模式名称。
- (NSString *)description;

@end






NS_ASSUME_NONNULL_END

