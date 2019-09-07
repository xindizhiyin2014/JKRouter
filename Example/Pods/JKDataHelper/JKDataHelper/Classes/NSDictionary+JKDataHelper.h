//
//  NSDictionary+JKDataHelper.h
//  Pods
//
//  Created by Jack on 17/3/28.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JKDataHelper)

- (BOOL)jk_hasKey:(NSString *)key;

- (NSString*)jk_stringForKey:(NSString *)key;

- (NSNumber*)jk_numberForKey:(NSString *)key;

- (NSDecimalNumber *)jk_decimalNumberForKey:(NSString *)key;

- (NSArray*)jk_arrayForKey:(NSString *)key;

- (NSDictionary*)jk_dictionaryForKey:(NSString *)key;

- (NSInteger)jk_integerForKey:(NSString *)key;

- (NSUInteger)jk_unsignedIntegerForKey:(NSString *)key;

- (BOOL)jk_boolForKey:(NSString *)key;

- (int16_t)jk_int16ForKey:(NSString *)key;

- (int32_t)jk_int32ForKey:(NSString *)key;

- (int64_t)jk_int64ForKey:(NSString *)key;

- (char)jk_charForKey:(NSString *)key;

- (short)jk_shortForKey:(NSString *)key;

- (float)jk_floatForKey:(NSString *)key;

- (CGFloat)jk_cgFloatForKey:(NSString *)key;

- (double)jk_doubleForKey:(NSString *)key;

- (long long)jk_longLongForKey:(NSString *)key;

- (unsigned long long)jk_unsignedLongLongForKey:(NSString *)key;

- (NSDate *)jk_dateForKey:(NSString *)key dateFormat:(NSString *)dateFormat;

- (CGPoint)jk_pointForKey:(NSString *)key;

- (CGSize)jk_sizeForKey:(NSString *)key;

- (CGRect)jk_rectForKey:(NSString *)key;

@end
