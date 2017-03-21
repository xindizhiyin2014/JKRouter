//
//  JKAccessRightHandler.m
//  Pods
//
//  Created by Jack on 17/3/17.
//
//

#import "JKAccessRightHandler.h"
#import "JKRouter.h"
@implementation JKAccessRightHandler

+ (BOOL)safeValidateURL:(NSString *)url{
//默认都是通过安全性校验的
    return YES;
}

//根据权限等级判断是否需要跳转
+ (BOOL)validateTheRightToOpenVC:(RouterOptions *)options{
    
    //这个方法默认可以进行跳转，如果有特殊权限限制的可以进通过category重载该方法，具体配置权限
    return YES;
}

//根据app运行时用户的情况来配置权限，具体实现要通过category重载来实现
+ (RouterOptions *)configTheAccessRight:(RouterOptions *)options{
    //默认权限为defalut
    options.theAccessRight = JKRouterAccessRightDefalut;
    return options;
    
}


+ (void)handleNoRightToOpenVC:(RouterOptions *)options{
   
    
}

@end
