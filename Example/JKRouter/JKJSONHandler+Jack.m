//
//  JKJSONHandler+Jack.m
//  JKRouter
//
//  Created by Jack on 17/3/19.
//  Copyright © 2017年 HHL110120. All rights reserved.
//

#import "JKJSONHandler+Jack.h"

@implementation JKJSONHandler (Jack)
// 解析JSON文件 获取到所有的Modules
+ (NSArray *)getModulesFromJsonFile:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *modules = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return modules;
}


+ (UIViewController *)searchExistViewControllerWithModuleID:(NSString *)moduleID{
    
    return nil;
}

+ (NSString *)searchVcClassNameWithModuleID:(NSInteger)moduleID{
    
    NSString *vcClassName = nil;
    for (NSDictionary *module in [JKRouter router].modules) {
        NSNumber *tempModuleID =module[@"moduleID"];
        if ([tempModuleID integerValue] ==moduleID) {
            vcClassName = module[@"targetVC"];
            break;
        }
    }
    return vcClassName;
}


+ (NSString *)searchDirectoryWithModuleID:(NSNumber *)moduleID specifiedPath:(NSString *)path{
    
    return nil;
}


+ (BOOL)validateSpecialJump:(NSDictionary *)module moduleID:(NSInteger)moudleID{
    
    return NO;
}

@end
