//
//  JKRouterExtension+Jack.m
//  JKRouter_Example
//
//  Created by JackLee on 2017/12/17.
//  Copyright © 2017年 HHL110120. All rights reserved.
//

#import "JKRouterExtension+Jack.h"

@implementation JKRouterExtension (Jack)

+ (NSString *)jkWebVCClassName{
    
    return @"JKWebViewController";
}

+ (NSArray *)urlSchemes{
    
    return @[@"http",@"https",@"jkpp"];
}

@end
