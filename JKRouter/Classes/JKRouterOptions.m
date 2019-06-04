//
//  JKRouterOptions.m
//  JKRouter
//
//  Created by JackLee on 2019/6/4.
//

#import "JKRouterOptions.h"

//******************************************************************************
//*
//*           RouterOptions类
//*           配置跳转时的各种设置
//******************************************************************************

@interface JKRouterOptions()
//每个页面所对应的moduleID
@property (nonatomic, copy, readwrite) NSString *moduleID;

@end

@implementation JKRouterOptions

+ (instancetype)options{
    JKRouterOptions *options = [JKRouterOptions new];
    options.transformStyle = RouterTransformVCStyleDefault;
    options.animated = YES;
    return options;
}

+ (instancetype)optionsWithModuleID:(NSString *)moduleID{
    JKRouterOptions *options = [JKRouterOptions options];
    options.moduleID = moduleID;
    return options;
}

+ (instancetype)optionsWithDefaultParams:(NSDictionary *)params{
    JKRouterOptions *options = [JKRouterOptions options];
    options.defaultParams = params;
    return options;
}

+ (instancetype)optionsWithTransformStyle:(RouterTransformVCStyle)tranformStyle{
    JKRouterOptions *options = [JKRouterOptions options];
    options.transformStyle = tranformStyle;
    return options;
}

+ (instancetype)optionsWithCreateStyle:(RouterCreateStyle)createStyle{
    JKRouterOptions *options = [JKRouterOptions options];
    options.createStyle = createStyle;
    return options;
}

- (instancetype)optionsWithDefaultParams:(NSDictionary *)params{
    self.defaultParams = params;
    return self;
}

@end
