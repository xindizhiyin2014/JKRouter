//
//  NSString+JKDataHelper.m
//  JKDataHelper
//
//  Created by JackLee on 2018/11/9.
//

#import "NSString+JKDataHelper.h"

@implementation NSString (JKDataHelper)
- (NSString *)jk_trimWhiteSpace{
    
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)jk_trimWhiteSpaceAndNewLine{
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
