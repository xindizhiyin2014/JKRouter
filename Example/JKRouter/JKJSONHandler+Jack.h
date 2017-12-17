//
//  JKJSONHandler+Jack.h
//  JKRouter
//
//  Created by Jack on 17/3/19.
//  Copyright © 2017年 HHL110120. All rights reserved.
//

#import <JKRouter/JKRouter.h>

@interface JKJSONHandler (Jack)
// 解析JSON文件 获取到所有的Modules
+ (NSArray *)getModulesFromJsonFile:(NSArray <NSString *>*)files;

@end
