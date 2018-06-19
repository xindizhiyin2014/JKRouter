//
//  JKDataHelperMacro.h
//  JKDataHelper
//
//  Created by JackLee on 2018/6/19.
//

#ifndef JKDataHelperMacro_h
#define JKDataHelperMacro_h

#define JKDataHelperDebug

#import "NSArray+JKDataHelper.h"
#import "NSMutableArray+JKDataHelper.h"
#import "NSDictionary+JKDataHelper.h"
#import "JKDataHelper.h"


#define JKSafeArray(array)   [JKDataHelper safeArray:array]

#define JKSafeMutableArray(mutableArray)   [JKDataHelper safeMutableArray:mutableArray]

#define JKSafeDic(dict)   [JKDataHelper safeDictionary:dict]


#define JKSafeMutableDic(mutableDict)   [JKDataHelper safeMutableDictionary:mutableDict]

#define JKSafeStr(str)   [JKDataHelper safeStr:str]

#define JKSafeStr1(str, defaultStr)   [JKDataHelper safeStr:str defaultStr:defaultStr]

#define JKSafeObj(obj)   [JKDataHelper safeObj:obj]

#endif /* JKDataHelperMacro_h */
