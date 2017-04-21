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
#import "JKAccessRightHandler.h"

typedef NS_ENUM(NSInteger, JKAccessRight){ // 这个是app根据功能模块权限打开的时候，权限设置等级
    JKRouterAccessRightDefalut =0,
    JKRouterAccessRight1,
    JKRouterAccessRight2,
    JKRouterAccessRight3,
    JKRouterAccessRight4,
    JKRouterAccessRight5,
    JKRouterAccessRight6,
    JKRouterAccessRight7,
    JKRouterAccessRight8,
    JKRouterAccessRight9,
    JKRouterAccessRight10,
    JKRouterAccessRight11,
    JKRouterAccessRight12,
    JKRouterAccessRight13,
    JKRouterAccessRight14,
    JKRouterAccessRight15,
    JKRouterAccessRight16,
    JKRouterAccessRight17,
    JKRouterAccessRight18,
    JKRouterAccessRight19,
    JKRouterAccessRight20
    
};




//**********************************************************************************
//*
//*           RouterOptions类
//*           配置跳转时的各种设置
//**********************************************************************************

@interface RouterOptions : NSObject

//普通的present,push 跳转方式
@property (nonatomic, readwrite) BOOL isModal;

//跳转时是否有动画
@property (nonatomic, readwrite) BOOL animated;

//每个页面所对应的moduleID
@property (nonatomic, copy, readonly) NSString *moduleID;

//当前状态下用户所具有的 access 权限
@property (nonatomic) JKAccessRight theAccessRight;

//跳转时传入的参数，默认为nil
@property (nonatomic,copy,readwrite) NSDictionary *defaultParams;


/**
 创建默认配置的options对象

 @return RouterOptions 实例对象
 */
+ (instancetype)options;

/**
 创建options对象，并配置moduleID

 @param moduleID 模块的ID
 @return RouterOptions 实例对象
 */
+ (instancetype)optionsWithModuleID:(NSString *)moduleID;


/**
 创建单独配置的options对象,其余的是默认配置
 
 @param params 跳转时传入的参数
 @return RouterOptions 实例对象
 */
+ (instancetype)optionsWithDefaultParams:(NSDictionary *)params;


/**
 已经创建的option对象传入参数

 @param params 跳转时传入的参数
 @return RouterOptions 实例对象
 */
- (instancetype)optionsWithDefaultParams:(NSDictionary *)params;

@end

//******************************************************************************
//*
//*           JKouterConfig 类
//*
//******************************************************************************



@interface JKouterConfig : NSObject

@property (nonatomic,strong) NSArray<NSString *>*modulesInfoFiles; // 路由配置信息的json文件名数组
@property (nonatomic,strong) NSString *sepcialJumpListFileName; //跳转时有特殊动画的plist文件名
@property (nonatomic,strong) NSString *webContainerName;// app中web容器的className
@property (nonatomic,strong) NSString *URLScheme;//自定义的URL协议名字

@property (nonatomic,weak) UINavigationController * navigationController; //app的导航控制器

@end

//***********************************************************************************
//*
//*           JKRouter类
//*
//***********************************************************************************

@interface JKRouter : NSObject

@property (nonatomic, copy, readonly) NSSet <NSDictionary *>* modules;     ///< 存储路由，moduleID信息，权限配置信息
@property (nonatomic, copy, readonly) NSSet <NSDictionary *>* specialOptionsSet;     ///< 特殊跳转的页面信息的集合

/**
 初始化单例
 
 @return JKRouter 的单例对象
 */
+ (instancetype)router;
/**
 配置router信息
 @param config  router的配置信息
 */

+ (void)routerWithConfig:(JKouterConfig *)config;


/**
 默认打开方式
 一般由native调用
 @param vcClassName 跳转的控制器类名
 */
+ (void)open:(NSString *)vcClassName;


/**
 根据options的设置进行跳转
 
 @param vcClassName 跳转的控制器类名
 @param options 跳转的各种设置
 */
+ (void)open:(NSString *)vcClassName options:(RouterOptions *)options;


/**
 根据options的设置进行跳转,并执行相关的回调操作

 @param vcClassName 跳转的控制器类名
 @param options 跳转的各种设置
 @param callback 回调
 */
+ (void)open:(NSString *)vcClassName options:(RouterOptions *)options CallBack:(void(^)())callback;


/**
 遵守用户指定协议的跳转
 在外部浏览器唤醒app，H5调用相关模块时使用
 适用于携带少量参数，不带参数的跳转
 @param url 跳转的路由 携带参数
 */
+ (void)URLOpen:(NSString *)url;


/**
 遵守用户指定协议的跳转

 适用于携带大量参数的跳转,多用于H5页面跳转到native页面
 @param url 跳转的路由，不携带参数
 @param params 传入的参数
 */
+ (void)URLOpen:(NSString *)url params:(NSDictionary *)params;


/**
 适用于访问基于http协议／https协议的路由跳转

 @param url 跳转的路由，可以携带少量参数
 */
+ (void)httpOpen:(NSString *)url;

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
 默认情况下的pop，或者dismiss animated

 @param params 返回时携带的参数
 @param animated 是否有动画
 */
+ (void)pop:(NSDictionary *)params :(BOOL)animated;

/**
 pop到指定的页面
默认animated为YES，如果需要 dismiss，也会执行
 @param vc 指定的vc对象
 */
+ (void)popToSpecifiedVC:(UIViewController *)vc;

/**
 pop到指定的页面
 如果需要 dismiss，也会执行
 @param vc 指定的vc对象
 @param animated 是否有动画
 */
+ (void)popToSpecifiedVC:(UIViewController *)vc animated:(BOOL)animated;

/**
 根据moduleID pop回指定的模块

 @param moduleID 指定要返回的moduleID
 */
+ (void)popWithSpecifiedModuleID:(NSString *)moduleID;


/**
  根据moduleID pop回指定的模块
 并指定动画模式
 @param moduleID 指定要返回的moduleID
 @param params 返回时携带的参数
 @param animated 是否有动画
 */
+ (void)popWithSpecifiedModuleID:(NSString *)moduleID :(NSDictionary *)params :(BOOL)animated;


/**
 通过浏览器跳转到相关的url或者唤醒相关的app

 @param url 路由信息
 */
- (void)openExternal:(NSString *)url;


@end
