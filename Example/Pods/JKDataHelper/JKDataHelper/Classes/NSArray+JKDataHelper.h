//
//  NSArray+JKDataHelper.h
//  Pods
//
//  Created by Jack on 17/3/28.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (JKDataHelper)

-(id)jk_objectWithIndex:(NSInteger)index;

- (NSString*)jk_stringWithIndex:(NSInteger)index;

- (NSNumber*)jk_numberWithIndex:(NSInteger)index;

- (NSDecimalNumber *)jk_decimalNumberWithIndex:(NSInteger)index;

- (NSArray*)jk_arrayWithIndex:(NSInteger)index;

- (NSDictionary*)jk_dictionaryWithIndex:(NSInteger)index;

- (NSInteger)jk_integerWithIndex:(NSInteger)index;

- (NSUInteger)jk_unsignedIntegerWithIndex:(NSInteger)index;

- (BOOL)jk_boolWithIndex:(NSInteger)index;

- (int16_t)jk_int16WithIndex:(NSInteger)index;

- (int32_t)jk_int32WithIndex:(NSInteger)index;

- (int64_t)jk_int64WithIndex:(NSInteger)index;

- (char)jk_charWithIndex:(NSInteger)index;

- (short)jk_shortWithIndex:(NSInteger)index;

- (float)jk_floatWithIndex:(NSInteger)index;

- (CGFloat)jk_cgFloatWithIndex:(NSInteger)index;

- (double)jk_doubleWithIndex:(NSInteger)index;

- (NSDate *)jk_dateWithIndex:(NSInteger)index dateFormat:(NSString *)dateFormat;

/**
 当前array的元素为NSDictionary类型

 @param key key
 @return key对应的value组成的数组
 */
- (NSMutableArray *)jk_valueArrayWithKey:(NSString *)key;

/**
 升序

 @return 排序后的数组
 */
- (NSMutableArray *)jk_ascSort;

/**
 降序

 @return 排序后的数组
 */
- (NSMutableArray *)jk_descSort;

- (CGPoint)jk_pointWithIndex:(NSInteger)index;

- (CGSize)jk_sizeWithIndex:(NSInteger)index;

- (CGRect)jk_rectWithIndex:(NSInteger)index;

@end
