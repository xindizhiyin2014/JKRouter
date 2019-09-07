//
//  JKRouterExtension.h
//  JKRouter
//
//  Created by JackLee on 2017/12/16.
//

#import <Foundation/Foundation.h>
#import "UIViewController+JKRouter.h"

@class JKRouterOptions;
@interface JKRouterExtension : NSObject

/**
 验证是否是白名单的url notice:方法可以通过重写，内部实现正则或者其他的校验策略验证是否是白名单的链接

 @param url 链接
 @return 是否是白名单url
 */
+ (BOOL)isVerifiedOfWhiteName:(NSString *)url;

/**
 验证是否是黑名单的url notice:方法可以通过重写，内部实现正则或者其他的校验策略验证是否是黑名单的链接

 @param url 链接
 @return 是否是黑名单url
 */
+ (BOOL)isVerifiedOfBlackName:(NSString *)url;

/**
 配置web容器从外部获取url的property的字段名
 
 @return property的字段名
 */
+ (NSString *)jkWebURLKey;

/**
 自己app使用的web容器

 @return webVC的className
 */
+ (NSString *)privateWebVCClassName;

/**
 打开外部链接的web容器

 @return webVC的className
 */
+ (NSString *)openWebVCClassName;

/**
 app支持的url协议组成的数组

 @return 协议的数组
 */
+ (NSArray *)urlSchemes;

/**
 app 的target的n名字

 @return AppTargetAName
 */
+ (NSString *)appTargetName;

/**
 app支持的url的特殊的url协议组成的数组

 @return 协议的数组
 */
+ (NSArray *)specialSchemes;

/**
 模块的类型名字key，用来解析模块的ViewController类型

 @return key
 */
+ (NSString *)jkModuleTypeViewControllerKey;

/**
 模块的类型名字key，用来解析模块的Factory类型

 @return key
 */
+ (NSString *)jkModuleTypeFactoryKey;

/**
 用来解析moduleID的key

 @return key default is @"jkModuleID"
 */
+ (NSString *)jkRouterModuleIDKey;

/**
 在url参数后设置 isBrowserOpenKey=1 时通过safari打开网页，其余情况通过appweb容器打开网页

 @return key default is @"browserOpen"
 */
+ (NSString *)jkBrowserOpenKey;

+ (UINavigationController *)jkNaVCInitWithRootVC:(UIViewController *)vc;

/**
 打开特殊scheme的url，主要适用于scheme不变，url内容变化的一些操作。

 @param url url
 @param extra 额外的操作
 @param completeBlock 操作成功后的回调
 @return 跳转成功与否或者操作成功与否的状态
 */
+ (BOOL)openURLWithSpecialSchemes:(NSURL *)url
                            extra:(NSDictionary *)extra
                         complete:(void(^)(id result,NSError *error))completeBlock;

/**
 除了路由跳转以外的操作
 @param actionType 操作的类型
 @param url url
 @param extra 额外传入的参数
 @param completeBlock 操作成功后的回调
 @return 跳转成功与否或者操作成功与否的状态
 */
+ (BOOL)otherActionsWithActionType:(NSString *)actionType
                               URL:(NSURL *)url
                             extra:(NSDictionary *)extra
                          complete:(void(^)(id result,NSError *error))completeBlock;

/**
 进行tab切换，如果用户使用了自定义的tabBar，可以考虑重写该方法
 
 @param targetClass VC的类
 @param options 打开页面的各种配置
 @param completeBlock 操作成功后的回调
@return 跳转成功与否或者操作成功与否的状态
 */
+ (BOOL)jkSwitchTabClass:(Class)targetClass
                 options:(JKRouterOptions *)options
                complete:(void(^)(id result,NSError *error))completeBlock;

@end
