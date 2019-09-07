//
//  JKFactory.m
//  JKRouter_Example
//
//  Created by JackLee on 2018/12/22.
//  Copyright © 2018年 HHL110120. All rights reserved.
//

#import "JKFactory.h"
#import "FactoryAViewController.h"
#import "FactoryBViewController.h"
#import "FactoryCViewController.h"
#import <JKDataHelper/NSDictionary+JKDataHelper.h>

@implementation JKFactory
+ (UIViewController *)jkRouterFactoryViewControllerWithJSON:(NSDictionary *)dic{
    NSInteger cid = [dic jk_integerForKey:@"cid"];
    return [self factoryControllerWithCid:cid];
}

+ (UIViewController *)factoryControllerWithCid:(NSInteger)cid{
    if (cid ==0) {
        return [FactoryAViewController new];
    }else if (cid ==1){
        return [FactoryBViewController new];
    }else if (cid ==2){
        return [FactoryCViewController new];
    }
    return nil;
}
@end
