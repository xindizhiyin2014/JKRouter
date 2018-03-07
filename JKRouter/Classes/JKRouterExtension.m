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

+ (NSString *)sandBoxBasePath{
    return [[NSBundle mainBundle] pathForResource:nil ofType:nil];
}

+ (NSString *)JKRouterModuleIDKey{
    return @"jkModuleID";
}

+ (NSString *)JKRouterHttpOpenStyleKey{
    return @"jkRouterAppOpen";
}

+ (void)otherActionsWithActionType:(NSString *)actionType URL:(NSURL *)url extra:(NSDictionary *)extra{
}

@end
