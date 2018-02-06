//
//  JKAppDelegate.m
//  JKRouter
//
//  Created by HHL110120 on 03/14/2017.
//  Copyright (c) 2017 HHL110120. All rights reserved.
//

#import "JKAppDelegate.h"
#import "JKViewController.h"
#import <JKRouter/JKRouterHeader.h>
#import "JKOneViewController.h"
#import "JKTwoViewController.h"
#import "JKThreeViewController.h"

@interface WKNavigationController:UINavigationController

@end

@implementation WKNavigationController

@end


@implementation JKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"RouterWindowRootVCStyle"] integerValue] !=RouterWindowRootVCStyleDefault) {
        JKOneViewController *oneVC = [JKOneViewController new];
        UINavigationController *naVC1 = [[UINavigationController alloc] initWithRootViewController:oneVC];
        JKTwoViewController *twoVC = [JKTwoViewController new];
        UINavigationController *naVC2 = [[UINavigationController alloc] initWithRootViewController:twoVC];
        JKThreeViewController *threeVC = [JKThreeViewController new];
        UINavigationController *naVC3 = [[UINavigationController alloc] initWithRootViewController:threeVC];
        UITabBarController *tabBarVC = [[UITabBarController alloc] init];
        tabBarVC.viewControllers = @[naVC1,naVC2,naVC3];
        [JKRouter configWithRouterFiles:@[@"modules.json",@"modules123.json"]];
        [JKRouter router].windowRootVCStyle = RouterWindowRootVCStyleCustom;
        self.window.rootViewController = tabBarVC;
    }else{
        JKViewController *jkVC = [JKViewController new];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:jkVC];
        self.window.rootViewController = naVC;
        [JKRouter configWithRouterFiles:@[@"modules.json",@"modules123.json"]];
        [JKRouter router].windowRootVCStyle = RouterWindowRootVCStyleDefault;
    }
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
