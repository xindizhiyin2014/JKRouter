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
#import <JKDataHelper/JKDataHelperMacro.h>
#import "JKRouterEmptyObject.h"

@implementation JKRouterExtension

+ (BOOL)isVerifiedOfWhiteName:(NSString *)url{
    return YES;
}

+ (BOOL)isVerifiedOfBlackName:(NSString *)url{
    return NO;
}
+ (NSString *)jkWebURLKey{
    
    return @"url";
}

+ (NSString *)privateWebVCClassName{
    return nil;
}

+ (NSString *)openWebVCClassName{
    return nil;
}

+ (NSArray *)urlSchemes{
    return @[@"http",
             @"https",
             @"file",
             @"itms-apps",
             @"app-settings",
             @"tel"];
    
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
    NSString *moduleID = [url.path substringFromIndex:1];
    NSString *swiftModuleName = [JKJSONHandler getSwiftModuleNameWithModuleID:moduleID];
    NSString *targetClassName = [JKJSONHandler getTargetWithModuleID:moduleID];
    JKRouterOptions *options = [JKRouterOptions options];
    options.module = swiftModuleName;
    Class targetClass = nil;
    if (!JKIsEmptyStr(options.module)) {
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
        NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorUnSupportAction userInfo:@{@"msg":@"不支持该操作"}];
        completeBlock(nil,error);
    }
    return NO;
    
    
}

+ (BOOL)jkSwitchTabClass:(Class)targetClass options:(JKRouterOptions *)options complete:(void(^)(id result,NSError *error))completeBlock{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    
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
