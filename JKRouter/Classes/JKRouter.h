//
//  JKRouter.h
//  
//
//  Created by jack on 17/1/11.
//  Copyright © 2017年 localadmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+JKRouter.h"
#import "JKJSONHandler.h"
#import "JKRouterOptions.h"

//***********************************************************************************
//*
//*           JKRouter类
//*
//***********************************************************************************

@interface JKRouter : NSObject

@property (nonatomic, strong, readonly) NSMutableSet <NSDictionary *>* modules;     ///< 存储路由，moduleID信息，权限配置信息
@property (nonatomic, weak, readonly) UIViewController *topVC;                       ///< app的最顶部的控制器

+ (instancetype) new NS_UNAVAILABLE;

- (instancetype) init NS_UNAVAILABLE;
/**
 初始化单例
 
 @return JKRouter 的单例对象
 */
+ (instancetype)sharedRouter;

/**
 配置router信息
 @param routerFileNames  router的配置信息
 */

+ (void)configWithRouterFiles:(__kindof NSArray<NSString *> *)routerFileNames;

/**
 更新路由信息

 @param filePath 路由配置信息的文件在沙盒中的路径
 */
+ (void)updateRouterInfoWithFilePath:(__kindof NSString*)filePath;

/**
 默认打开方式
 一般由native调用
 @param targetClassName 跳转的target类名
 @return 跳转成功与否的状态
 */
+ (BOOL)open:(__kindof NSString *)targetClassName;

/**
 打开页面，一般由native开发者使用

 @param targetClassName 跳转的target类名
 @param params 参数
 @return 跳转成功与否的状态
 */
+ (BOOL)open:(__kindof NSString *)targetClassName
      params:(__kindof NSDictionary *)params;

/**
 根据options的设置进行跳转
 
 @param targetClassName 跳转的target类名
 @param options 跳转的各种设置
 @return 跳转成功与否的状态
 */
+ (BOOL)open:(__kindof NSString *)targetClassName
     options:(JKRouterOptions *)options;

/**
 根据options的设置进行跳转,并执行相关的回调操作
 通过后台，或者H5交互是携带json参数进行跳转，对应的ViewController内部需要实现
 + (instancetype)jkRouterViewControllerWithJSON:(NSDictionary *)dic 这个方法的重写。
 @param targetClassName 跳转的target类名
 @param options 跳转的各种设置
 @param completeBlock 跳转成功后的回调,或者失败的原因
 @return 跳转成功与否的状态
 */
+ (BOOL)open:(__kindof NSString *)targetClassName
     options:(JKRouterOptions *)options
    complete:(void(^)(id result,NSError *error))completeBlock;

/**
 根据options的设置进行跳转
 
 @param targetClass 跳转的target类
 @param options 跳转的各种设置
 @return 跳转成功与否的状态
 */
+ (BOOL)openWithClass:(Class)targetClass
              options:(JKRouterOptions *)options;

/**
 根据options的设置进行跳转,并执行相关的回调操作
 
 @param targetClass 跳转的target类
 @param options 跳转的各种设置
 @param completeBlock 跳转成功后的回调,或者失败的原因
 @return 跳转成功与否的状态
 */
+ (BOOL)openWithClass:(Class)targetClass
              options:(JKRouterOptions *)options
             complete:(void(^)(id result,NSError *error))completeBlock;

/**
 根据options和已有的vc进行跳转

 @param vc 已经创建的指定的vc
 @param options 跳转的各种设置
 @param completeBlock 跳转成功后的回调,或者失败的原因
 @return 跳转成功与否的状态
 */
+ (BOOL)openSpecifiedVC:(__kindof UIViewController *)vc
                options:(JKRouterOptions *)options
               complete:(void(^)(id result,NSError *error))completeBlock;

/**
 遵守用户指定协议的跳转
 在外部浏览器唤醒app，H5调用相关模块时使用
 适用于携带少量参数，不带参数的跳转
 @param url 跳转的路由 携带参数
 @return 跳转或者操作成功与否的状态

 */
+ (BOOL)URLOpen:(__kindof NSString *)url;

/**
 遵守用户指定协议的跳转

 适用于携带大量参数的跳转,多用于H5页面跳转到native页面
 @param url 跳转的路由，不携带参数
 @param extra 额外传入的参数,注：extra内的参数可以改变web容器的属性
 @return 跳转或者操作成功与否的状态
 */
+ (BOOL)URLOpen:(__kindof NSString *)url
          extra:(__kindof NSDictionary *)extra;

/**
 遵守用户指定协议的跳转
 
 适用于携带大量参数的跳转,多用于H5页面跳转到native页面
 @param url 跳转的路由，不携带参数
 @param extra 额外传入的参数 注：extra内的参数可以改变web容器的属性
 @param completeBlock 跳转成功后的回调,或者失败的原因
 @return 跳转或者操作成功与否的状态
 */
+ (BOOL)URLOpen:(__kindof NSString *)url
          extra:(__kindof NSDictionary *)extra
       complete:(void(^)(id result,NSError *error))completeBlock;

/**
 默认情况下的pop，或者dismiss ,animated:YES
 */
+ (void)pop;

/**
 默认情况下的pop，或者dismiss，animated:YES

 @param animated 是否有动画
 */
+ (void)pop:(BOOL)animated;

/**
 默认情况下的pop

 @param options 跳转的各种设置
 */
+ (void)popWithOptions:(JKRouterOptions *)options;
/**
 默认情况下的pop，或者dismiss animated
 
 @param options 跳转的各种设置
 @param completeBlock 完成操作后的回调

 */
+ (void)popWithOptions:(JKRouterOptions *)options
              complete:(void(^)(id result,NSError *error))completeBlock;
/**
 pop到指定的页面
 默认animated为YES，如果需要 dismiss，也会执行
 @param vc 指定的vc对象
 */
+ (void)popToSpecifiedVC:(__kindof UIViewController *)vc;

/**
 pop到指定的页面
 如果需要 dismiss，也会执行
 @param vc 指定的vc对象
 @param animated 是否有动画
 */
+ (void)popToSpecifiedVC:(__kindof UIViewController *)vc
                animated:(BOOL)animated;
/**
 pop到指定的页面
 如果需要 dismiss，也会执行
 @param vc 指定的vc对象
 @param options 跳转的各种设置
 @param completeBlock 完成操作后的回调

 */
+ (void)popToSpecifiedVC:(__kindof UIViewController *)vc
                 options:(JKRouterOptions *)options
                complete:(void(^)(id result,NSError *error))completeBlock;

/**
 根据moduleID pop回指定的模块

 @param moduleID 指定要返回的moduleID
 */
+ (void)popWithSpecifiedModuleID:(__kindof NSString *)moduleID;

/**
  根据moduleID pop回指定的模块
 并指定动画模式
 @param moduleID 指定要返回的moduleID
 @param animated 是否有动画
 */
+ (void)popWithSpecifiedModuleID:(__kindof NSString *)moduleID
                                :(BOOL)animated;
/**
 根据moduleID pop回指定的模块

 @param moduleID 指定要返回的moduleID
 @param options 跳转的各种设置
 @param completeBlock 完成操作后的回调
 */
+ (void)popWithSpecifiedModuleID:(__kindof NSString *)moduleID
                 options:(JKRouterOptions *)options
                complete:(void(^)(id result,NSError *error))completeBlock;

/**
 根据step的值pop向前回退几个VC
 如果step大于当前当前naVC.viewController.count,时返回pop to rootViewController
 @param step 回退的vc的数量
 */
+ (void)popWithStep:(NSUInteger)step;

/**
 根据step的值pop向前回退几个VC
 如果step大于当前当前naVC.viewController.count,时返回pop to rootViewController
 
 @param step 回退的vc的数量
 @param animated 是否有动画效果
 */
+ (void)popWithStep:(NSUInteger)step
                   :(BOOL)animated;

/**
 根据step的值pop向前回退几个VC
 如果step大于当前当前naVC.viewController.count,时返回pop to rootViewController
 
 @param step 回退的vc的数量
 @param options 跳转的各种设置
 @param completeBlock 完成操作后的回调
 */
+ (void)popWithStep:(NSUInteger)step
            options:(JKRouterOptions *)options
           complete:(void(^)(id result,NSError *error))completeBlock;

/**
 通过浏览器跳转到相关的url或者唤醒相关的app

 @param targetURL 路由信息
 @return 跳转或者操作成功与否的状态
 */
+ (BOOL)openExternal:(NSURL *)targetURL;
/**
 通过浏览器跳转到相关的url或者唤醒相关的app
 @param completeBlock 跳转成功后的回调,或者失败的原因
 @param targetURL 路由信息
 @return 跳转或者操作成功与否的状态
 */
+ (BOOL)openExternal:(NSURL *)targetURL
            complete:(void(^)(id result,NSError *error))completeBlock;

/**
 使用targetVC替换navigattionController当前的viewController

 @param targetVC 目标viewController
 */
+ (BOOL)replaceCurrentViewControllerWithTargetVC:(__kindof UIViewController *)targetVC;

/**
 更新次顶部视图

 @param options 配置信息
 @return 更新成功与否的状态
 */
+ (BOOL)updateLastTopVC:(JKRouterOptions *)options;

@end
