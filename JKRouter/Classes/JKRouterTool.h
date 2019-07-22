//
//  JKRouterTool.h
//  JKRouter
//
//  Created by JackLee on 2019/6/4.
//

#import <Foundation/Foundation.h>
#import "JKRouterOptions.h"
NS_ASSUME_NONNULL_BEGIN
@class JKRouter;

@interface JKRouterTool : NSObject
//为ViewController 的属性赋值
+ (UIViewController *)configVCWithClass:(Class)vcClass options:(JKRouterOptions *)options;

+ (void)configTheVC:(UIViewController *)vc options:(JKRouterOptions *)options;

/**
 将url的query转换为字典参数
 
 @param urlString url字符串
 @return NSMutableDictionary 对象
 */
+ (NSMutableDictionary *)convertUrlStringToDictionary:(NSString *)urlString;

/**
 url对象添加参数
 
 @param url url对象
 @param parameter 参数
 @return 处理后的url对象
 */
+ (NSURL *)url:(NSURL *)url appendParameter:(NSDictionary *)parameter;
/**
 为url字符串添加参数
 
 @param urlStr url字符串
 @param parameter 参数
 @return url字符串
 */
+ (NSString *)urlStr:(NSString *)urlStr appendParameter:(NSDictionary *)parameter;

/**
 url对象删除参数
 
 @param url url对象
 @param keys 需要删除的参数的key的数组
 @return 处理后的url对象
 */
+ (NSURL *)url:(NSURL*)url removeQueryKeys:(NSArray <NSString *>*)keys;

/**
 url字符串删除参数
 
 @param urlStr url字符串
 @param keys 需要删除的key组成的数组
 @return 处理后的url字符串
 */
+ (NSString *)urlStr:(NSString *)urlStr removeQueryKeys:(NSArray <NSString *>*)keys;

/**
 类方法动态分发

 @param targetClass 插件类
 @param selector 方法
 @param params 参数
 @return 返回值
 */
+ (BOOL)jkPerformWithPlugin:(Class)targetClass selector:(SEL)selector params:(NSArray *)params;
@end

NS_ASSUME_NONNULL_END
