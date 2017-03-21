//
//  JKAccessRightHandler.h
//  Pods
//
//  Created by Jack on 17/3/17.
//
//

#import <Foundation/Foundation.h>
@class RouterOptions;

@interface JKAccessRightHandler : NSObject


/**
 对传入的URL进行安全性校验，防止恶意攻击

 @param url 传入的url字符串
 @return 通过验证与否的状态
 */
+ (BOOL)safeValidateURL:(NSString *)url;

/**
 根据权限等级判断是否需要跳转，具体通过category重载来实现
 
 @param options 携带的配置信息
 @return 是否进行正常的跳转
 */
+ (BOOL)validateTheRightToOpenVC:(RouterOptions *)options;

/**
 根据app运行时用户的情况来配置权限，具体通过category重载来实现
 
 @param options 页面跳转的配置信息
 @return 配置好权限的options
 */
+ (RouterOptions *)configTheAccessRight:(RouterOptions *)options;

/**
 对于没有权限打开相关页面时的后续操作，具体通过category重载来实现
 
 @param options 传入的配置信息
 */
+ (void)handleNoRightToOpenVC:(RouterOptions *)options;

@end
