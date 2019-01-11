//
//  JKRouterExtension.m
//  JKRouter
//
//  Created by JackLee on 2017/12/16.
//

#import "JKRouterExtension.h"

@implementation JKRouterExtension

+ (BOOL)safeValidateURL:(NSString *)url{
    //默认都是通过安全性校验的
    return YES;
}

+ (NSString *)jkWebURLKey{
    
    return @"jkurl";
}

+ (NSString *)jkWebTypeKey{
    return @"webType";
}

+ (NSArray *)jkWebVCClassNames{
    return nil;
}

+ (NSArray *)urlSchemes{
    return @[@"http",
             @"https",
             @"file",
             @"itms-apps"];
    
}

+ (NSString *)appTargetName{
    return nil;
}

+ (NSArray *)specialSchemes{
    return @[];
}

+ (NSString *)jkModuleTypeViewControllerKey{
    return @"ViewController";
}

+ (NSString *)jkModuleTypeFactoryKey{
    return @"Factory";
}

+ (NSString *)sandBoxBasePath{
    return NSHomeDirectory();
}

+ (NSString *)JKRouterModuleIDKey{
    return @"jkModuleID";
}

+ (NSString *)jkBrowserOpenKey{
    return @"browserOpen";
}

+ (BOOL)openURLWithSpecialSchemes:(NSURL *)url extra:(NSDictionary *)extra complete:(void(^)(id result,NSError *error))completeBlock{
    if (completeBlock) {
        NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorSystemUnSupportURLScheme userInfo:@{@"msg":@"不支持该协议的url"}];
        completeBlock(nil,error);
    }
    return NO;
}

+ (BOOL)otherActionsWithActionType:(NSString *)actionType URL:(NSURL *)url extra:(NSDictionary *)extra complete:(void(^)(id result,NSError *error))completeBlock{
    if (completeBlock) {
        NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorUnSupportAction userInfo:@{@"msg":@"不支持该操作"}];
        completeBlock(nil,error);
    }
    return NO;
}

+ (BOOL)jkSwitchTabWithVC:(NSString *)vcClassName options:(RouterOptions *)options complete:(void(^)(id result,NSError *error))completeBlock{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    Class targetClass = NSClassFromString(vcClassName);
    if (!targetClass) {
        targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",[JKRouterExtension appTargetName],vcClassName]);
    }
    NSInteger index = [targetClass jkTabIndex];
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        if ([tabBarVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
            NSArray *vcArray = tabBarVC.viewControllers;
            UINavigationController *naVC = vcArray[index];
            [naVC popToRootViewControllerAnimated:YES];
            tabBarVC.selectedIndex = index;

        }else{
            tabBarVC.selectedIndex = index;
        }
        if (completeBlock) {
            completeBlock(nil,nil);
        }
        return YES;
    }
    if (completeBlock) {
        NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorUnSupportSwitchTabBar userInfo:@{@"msg":@"不支持的切换tabBar操作"}];
        completeBlock(nil,error);
    }
    return NO;
}

@end
