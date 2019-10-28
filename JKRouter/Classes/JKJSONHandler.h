//
//  JKJSONHandler.h
//  Pods
//
//  Created by Jack on 17/3/17.
//
//

#import <Foundation/Foundation.h>
#import <JKRouter/JKRouterHeader.h>
@interface JKJSONHandler : NSObject
// 解析JSON文件 获取到所有的Modules
+ (NSArray *)getModulesFromJsonFile:(__kindof NSArray <NSString *>*)files;

/**
 根据读取到的json文件中的内容找到对应的路径

 @param moduleID 对应的module的主页路径
 @return 对应模块的target类名
 */
+ (NSString *)getTargetWithModuleID:(__kindof NSString *)moduleID;


/**
 根据moduleID获取url要跳转的type

 @param moduleID 模块的id
 @return type
 */
+ (NSString *)getTypeWithModuleID:(__kindof NSString *)moduleID;


/**
 获取swift下命名空间的名字，即swift下对应framework的的名字

 @param moduleID 模块的id
 @return 命名空间的名字
 */
+ (NSString *)getSwiftModuleNameWithModuleID:(__kindof NSString *)moduleID;

/**
 获取非路由跳转的func的名字

 @param moduleID 模块的id
 @return 非路由跳转的func的名字
 */
+ (NSString *)getFuncNameWithModuleID:(__kindof NSString *)moduleID;

@end
