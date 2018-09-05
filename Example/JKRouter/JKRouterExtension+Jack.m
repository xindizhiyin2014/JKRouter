//
//  JKRouterExtension+Jack.m
//  JKRouter_Example
//
//  Created by JackLee on 2018/3/7.
//  Copyright © 2018年 HHL110120. All rights reserved.
//

#import "JKRouterExtension+Jack.h"

@implementation JKRouterExtension (Jack)
+ (NSString *)jkWebVCClassName{
    
    return @"JKWebViewController";
}

+ (NSArray *)urlSchemes{
    
    return @[@"http",@"https",@"jkpp",@"file",
             @"itms-apps"];
}

+ (NSArray *)specialSchemes{
    return @[@"socket"];
}

@end
