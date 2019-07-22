//
//  JKJSONHandler.m
//  Pods
//
//  Created by Jack on 17/3/17.
//
//

#import "JKJSONHandler.h"
#import "JKRouter.h"

@implementation JKJSONHandler
// 解析JSON文件 获取到所有的Modules
+ (NSArray *)getModulesFromJsonFile:(NSArray <NSString *>*)files {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (NSString *fileName in files) {
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *modules = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [mutableArray addObjectsFromArray:modules];
    }
    return [mutableArray copy];
}

+ (NSString *)getTargetWithModuleID:(NSString *)moduleID{
    NSString *vcClassName = nil;
    for (NSDictionary *module in [JKRouter sharedRouter].modules) {
        NSString *tempModuleID =[NSString stringWithFormat:@"%@",module[@"moduleID"]];
        if ([tempModuleID isEqualToString:moduleID]) {
            vcClassName = module[@"target"];
            break;
        }
    }
    return vcClassName;
}

+ (NSString *)getTypeWithModuleID:(NSString *)moduleID{
    NSString *type = nil;
    for (NSDictionary *module in [JKRouter sharedRouter].modules) {
        NSString *tempModuleID =[NSString stringWithFormat:@"%@",module[@"moduleID"]];
        if ([tempModuleID isEqualToString:moduleID]) {
            type = module[@"type"];
            break;
        }
    }
    return type;
}

+ (NSString *)getSwiftModuleNameWithModuleID:(NSString *)moduleID{
    NSString *moduleName = nil;
    for (NSDictionary *module in [JKRouter sharedRouter].modules) {
        NSString *tempModuleID =[NSString stringWithFormat:@"%@",module[@"moduleID"]];
        if ([tempModuleID isEqualToString:moduleID]) {
            moduleName = module[@"module"];
            break;
        }
    }
    return moduleName;

}

+ (NSString *)getFuncNameWithModuleID:(NSString *)moduleID{
    NSString *func = nil;
    for (NSDictionary *module in [JKRouter sharedRouter].modules) {
        NSString *tempModuleID =[NSString stringWithFormat:@"%@",module[@"moduleID"]];
        if ([tempModuleID isEqualToString:moduleID]) {
            func = module[@"func"];
            break;
        }
    }
    return func;
}

@end
