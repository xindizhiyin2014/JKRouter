//
//  JKJSONHandler.h
//  Pods
//
//  Created by Jack on 17/3/17.
//
//

#import <Foundation/Foundation.h>

@interface JKJSONHandler : NSObject
// 解析JSON文件 获取到所有的Modules
+ (NSArray *)getModulesFromJsonFile:(NSString *)fileName;

/**
 从NavigationController导航栏持有的viewControllers中根据moduleID来找到相关的ViewController

 @param moduleID 传入的ViewController标记
 @return 找到的viewController对象
 */
+ (UIViewController *)searchExistViewControllerWithModuleID:(NSString *)moduleID;


/**
 根据MoudleID找到对应的ViewController的className

 @param moduleID 传入的ViewController标记
 @return 找到的ViewController的className
 */
+ (NSString *)searchVcClassNameWithModuleID:(NSInteger)moduleID;

/**
 根据读取到的json文件中的内容找到对应的路径

 @param moduleID 传入的ViewController标记
 @param path 指定的路径
 @return 返回对应的可以在app内打开的路径
 */
+ (NSString *)searchDirectoryWithModuleID:(NSNumber *)moduleID specifiedPath:(NSString *)path;

/**
 根据moduleID验证相关模块是否需要特殊的跳转

 @param module 传入的要解析的数据
 @param moudleID 传入的ViewController标记
 @return 是否需要特殊跳转的BOOL值
 */
+ (BOOL)validateSpecialJump:(NSDictionary *)module moduleID:(NSInteger)moudleID;



@end
