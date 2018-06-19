#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JKDataHelper.h"
#import "JKDataHelperMacro.h"
#import "NSArray+JKDataHelper.h"
#import "NSDictionary+JKDataHelper.h"
#import "NSMutableArray+JKDataHelper.h"
#import "NSObject+JK.h"

FOUNDATION_EXPORT double JKDataHelperVersionNumber;
FOUNDATION_EXPORT const unsigned char JKDataHelperVersionString[];

