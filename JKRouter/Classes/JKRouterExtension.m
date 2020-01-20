//
//  JKRouterExtension.m
//  JKRouter
//
//  Created by JackLee on 2017/12/16.
//

#import "JKRouterExtension.h"
#import "JKRouterHeader.h"
#import "JKRouterTool.h"
#import "JKJSONHandler.h"
#import "JKRouterEmptyObject.h"
#import <objc/runtime.h>


@implementation JKRouterExtension

+ (BOOL)isVerifiedOfWhiteName:(__kindof NSString *)url
{
    return YES;
}

+ (BOOL)isVerifiedOfBlackName:(__kindof NSString *)url
{
    return NO;
}
+ (NSString *)jkWebURLKey
{
    
    return @"url";
}

+ (NSString *)privateWebVCClassName
{
    return nil;
}

+ (NSString *)openWebVCClassName
{
    return nil;
}

+ (NSArray *)urlSchemes
{
    return @[@"http",
             @"https",
             @"file",
             @"itms-apps",
             @"app-settings",
             @"tel"];
    
}

+ (NSString *)appTargetName
{
    return nil;
}

+ (NSArray *)specialSchemes
{
    return @[];
}

+ (NSString *)jkModuleTypeViewControllerKey
{
    return @"ViewController";
}

+ (NSString *)jkModuleTypeFactoryKey
{
    return @"Factory";
}

+ (NSString *)jkRouterModuleIDKey
{
    return @"jkModuleID";
}

+ (NSString *)jkBrowserOpenKey
{
    return @"browserOpen";
}

+ (UINavigationController *)jkNaVCInitWithRootVC:(__kindof UIViewController *)vc
{
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    return naVC;
}

+ (BOOL)openURLWithSpecialSchemes:(NSURL *)url
                            extra:(NSDictionary *)extra
                         complete:(void(^)(id result,NSError *error))completeBlock
{
    if (completeBlock) {
        NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorSystemUnSupportURLScheme userInfo:@{@"msg":@"do not support this scheme of the url"}];
        completeBlock(nil,error);
    }
    return NO;
}

+ (BOOL)otherActionsWithActionType:(__kindof NSString *)actionType
                               URL:(NSURL *)url
                             extra:(__kindof NSDictionary *)extra
                          complete:(void(^)(id result,NSError *error))completeBlock
{
    NSString *moduleID = [url.path substringFromIndex:1];
    NSString *swiftModuleName = [JKJSONHandler getSwiftModuleNameWithModuleID:moduleID];
    NSString *targetClassName = [JKJSONHandler getTargetWithModuleID:moduleID];
    JKRouterOptions *options = [JKRouterOptions options];
    options.module = swiftModuleName;
    Class targetClass = nil;
    if (options.module && [options.module isKindOfClass:[NSString class]] && options.module.length > 0) {
        targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",options.module,targetClassName]);
    }else{
        targetClass = NSClassFromString(targetClassName);
        if (!targetClass) {
            targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",[JKRouterExtension appTargetName],targetClassName]);
        }
    }
    if (!targetClass) {
        return NO;
    }
    NSString *funcName = [JKJSONHandler getFuncNameWithModuleID:moduleID];
    funcName = [NSString stringWithFormat:@"%@:::",funcName];
    SEL selector = NSSelectorFromString(funcName);
    
    if ([targetClass respondsToSelector:selector]) {
        NSMutableArray *params = [NSMutableArray new];
        if (url) {
            [params addObject:url];
        }else{
            [params addObject:[JKRouterEmptyObject class]];
        }
        
        if (extra) {
            [params addObject:extra];
        }else{
            [params addObject:[JKRouterEmptyObject class]];
        }
        
        if (completeBlock) {
            [params addObject:completeBlock];
        }else{
            [params addObject:[JKRouterEmptyObject class]];
        }
        return [JKRouterTool jkPerformWithPlugin:targetClass selector:selector params:params];
    }
    if (completeBlock) {
        NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorUnSupportAction userInfo:@{@"msg":@"do not support this action"}];
        completeBlock(nil,error);
    }
    return NO;
    
}

+ (BOOL)jkSwitchTabClass:(Class)targetClass
                 options:(JKRouterOptions *)options
                complete:(void(^)(id result,NSError *error))completeBlock
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        NSInteger index = [targetClass jkTabIndex];
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
        NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorUnSupportSwitchTabBar userInfo:@{@"msg":@"do not support switch tabbar"}];
        completeBlock(nil,error);
    }
    return NO;
}

@end
