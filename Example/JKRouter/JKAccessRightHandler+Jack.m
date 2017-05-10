//
//  JKAccessRightHandler+Jack.m
//  JKRouter
//
//  Created by Jack on 17/3/19.
//  Copyright © 2017年 HHL110120. All rights reserved.
//

#import "JKAccessRightHandler+Jack.h"

@implementation JKAccessRightHandler (Jack)
//根据权限等级判断是否需要跳转
+ (BOOL)validateTheRightToOpenVC:(RouterOptions *)options{
    for (NSDictionary *module in [JKRouter router].modules) {
        if ([options.moduleID integerValue] ==[module[@"moduleID"] integerValue]) {
            if (JKSafeObj(module[@"accessRight"])) {
                if (options.theRouterRight.accessRight>= [module[@"accessRight"] integerValue]) {
                    return YES;
                }else{
                    return NO;
                }
            }
        }
        
        
    }
    return YES;
}

//根据app运行时用户的情况来配置权限，具体实现要通过category重载来实现
+ (RouterOptions *)configTheAccessRight:(RouterOptions *)options{
    //默认权限为defalut

    return options;
    
}


+ (void)handleNoRightToOpenVC:(RouterOptions *)options{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有权限访问该模块" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}
@end
