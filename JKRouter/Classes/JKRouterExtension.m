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

+ (NSString *)jkWebVCClassName{
    return @"";
}

+ (NSArray *)urlSchemes{
    return @[@"http",
             @"https",
             @"file",
             @"itms-apps"];
    
}

+ (NSString *)jkModuleTypeKey{
    return @"ViewController";
}

+ (NSString *)sandBoxBasePath{
    return [[NSBundle mainBundle] pathForResource:nil ofType:nil];
}

+ (NSString *)JKRouterModuleIDKey{
    return @"jkModuleID";
}

+ (NSString *)JKRouterHttpOpenStyleKey{
    return @"jkRouterAppOpen";
}

+ (void)otherActionsWithActionType:(NSString *)actionType URL:(NSURL *)url extra:(NSDictionary *)extra complete:(void(^)(id result,NSError *error))completeBlock{
}

+ (void)jkSwitchTabWithVC:(NSString *)vcClassName{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        if ([tabBarVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
            NSArray *vcArray = tabBarVC.viewControllers;
            for (NSInteger i = 0; i< vcArray.count; i++) {
                UINavigationController *naVC = vcArray[i];
                UIViewController *targetVC = naVC.viewControllers[0];
                if ([targetVC  isKindOfClass:NSClassFromString(vcClassName)] ) {
                    [naVC popToRootViewControllerAnimated:YES];
                    tabBarVC.selectedIndex = i;
                    return;
                }
            }
        }else{
            NSArray *vcArray = tabBarVC.viewControllers;
            for (NSInteger i = 0; i< vcArray.count; i++) {
                UIViewController *targetVC = vcArray[i];
                if ([targetVC  isKindOfClass:NSClassFromString(vcClassName)] ) {
                    tabBarVC.selectedIndex = i;
                    return;
                }
            }
        }
    }
}

@end
