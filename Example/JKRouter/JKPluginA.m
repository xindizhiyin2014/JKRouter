//
//  JKPluginA.m
//  JKRouter_Example
//
//  Created by JackLee on 2019/7/22.
//  Copyright © 2019 HHL110120. All rights reserved.
//

#import "JKPluginA.h"

@implementation JKPluginA
+ (BOOL)alert:(NSURL *)url :(NSDictionary *)extra :(void(^)(id result,NSError *error))completeBlock{
    NSLog(@"JKPluginA_alert:::");
    return YES;
}
@end
