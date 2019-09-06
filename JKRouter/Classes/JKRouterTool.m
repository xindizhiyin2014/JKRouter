//
//  JKRouterTool.m
//  JKRouter
//
//  Created by JackLee on 2019/6/4.
//

#import "JKRouterTool.h"
#import "JKRouter.h"
#import "JKRouterHeader.h"
#import "JKRouterExtension.h"
#import "JKRouterEmptyObject.h"

@implementation JKRouterTool
//为ViewController 的属性赋值
+ (UIViewController *)configVCWithClass:(Class)vcClass
                                options:(JKRouterOptions *)options
{
    
    Class targetClass = vcClass;
    UIViewController *vc = [targetClass jkRouterViewController];
    [vc setValue:options.moduleID forKey:[JKRouterExtension JKRouterModuleIDKey]];
    [self configTheVC:vc options:options];
    return vc;
}

/**
 对于已经创建的vc进行赋值操作
 
 @param vc 对象
 @param options 跳转的各种设置
 */
+ (void)configTheVC:(UIViewController *)vc
            options:(JKRouterOptions *)options
{
    if (!options) {
        return;
    }
    if (JKSafeDic(options.defaultParams)) {
        NSArray *propertyNames = [options.defaultParams allKeys];
        for (NSString *key in propertyNames) {
            id value =options.defaultParams[key];
            [vc setValue:value forKey:key];
        }
    }
}

//将url ？后的字符串转换为NSDictionary对象
+ (NSMutableDictionary *)convertUrlStringToDictionary:(NSString *)urlString
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *parameterArr = [urlString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameterArr) {
        NSArray *parameterBoby = [parameter componentsSeparatedByString:@"="];
        if (parameterBoby.count == 2) {
            [dic setObject:parameterBoby[1] forKey:parameterBoby[0]];
        }else
        {
            JKRouterLog(@"参数不完整");
        }
    }
    return dic;
}

+ (NSURL *)url:(NSURL *)url
appendParameter:(NSDictionary *)parameter
{
    NSString *urlString = [self urlStr:url.absoluteString appendParameter:parameter];
    return [NSURL URLWithString:urlString];
}

+ (NSString *)urlStr:(NSString *)urlStr
     appendParameter:(NSDictionary *)parameter
{
    //[urlStr hasSuffix:@"&"]?[urlStr stringByReplacingOccurrencesOfString:@"&" withString:@""]:urlStr;
    if ([urlStr hasSuffix:@"&"]) {
        urlStr = [urlStr substringToIndex:urlStr.length-1];
    }
    if (!([parameter allKeys].count>0)) {
        return urlStr;
    }
    NSString *firstSeperator = @"";
    if (![urlStr containsString:@"?"]) {
        urlStr = [NSString stringWithFormat:@"%@?",urlStr];
    }else if ([urlStr containsString:@"?"] && ![urlStr hasSuffix:@"?"]){
        firstSeperator = @"&";
    }
    NSString *query = firstSeperator;
    for (NSString *key in parameter.allKeys) {
        NSString *value = [parameter jk_stringForKey:key];
        if ([query hasSuffix:@"&"]) {
            query = [NSString stringWithFormat:@"%@%@=%@",query,key,value];
        }else{
            if (query.length>0) {
                query = [NSString stringWithFormat:@"%@&%@=%@",query,key,value];
            }else{
                query = [NSString stringWithFormat:@"%@=%@",key,value];
            }
        }
    }
    
    return [NSString stringWithFormat:@"%@%@",urlStr,query];
}

+ (NSURL *)url:(NSURL*)url
removeQueryKeys:(NSArray <NSString *>*)keys
{
    NSString *urlString = [self urlStr:url.absoluteString removeQueryKeys:keys];
    return [NSURL URLWithString:urlString];
}

+ (NSString *)urlStr:(NSString *)urlStr
     removeQueryKeys:(NSArray <NSString *>*)keys
{
    if (!(keys.count>0)) {
        NSAssert(NO, @"urlStr:removeQueryKeys: keys cannot be nil");
    }
    NSArray *tempArray = [urlStr componentsSeparatedByString:@"?"];
    NSString *query = nil;
    if (tempArray.count==2) {
        query = tempArray.lastObject;
    }
    NSDictionary *tempParameter = [self convertUrlStringToDictionary:query];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] initWithDictionary:tempParameter];
    for (NSString *key in keys) {
        [parameter removeObjectForKey:key];
    }
    
    NSString *baseUrl = tempArray.firstObject;
    if (parameter.count ==0) {
        return baseUrl;
    }
    NSString *urlString= [self urlStr:baseUrl appendParameter:parameter];
    return urlString;
}

+ (BOOL)jkPerformWithPlugin:(Class)targetClass
                   selector:(SEL)selector
                     params:(NSArray *)params
{
    if (params.count != 3) {
        return NO;
    }
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"B@:@@@"];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:targetClass];
    [invocation setSelector:selector];
    
    NSUInteger i = 1;
    for (id object in params) {
        id tempObject = object;
        if (![tempObject isKindOfClass:[NSObject class]]) {
            if ([tempObject isSubclassOfClass:[JKRouterEmptyObject class]]) {
                tempObject = nil;
            }
        }
        [invocation setArgument:&tempObject atIndex:++i];
    }
    BOOL result = NO;
    [invocation invoke];
    if ([signature methodReturnLength]) {
        [invocation getReturnValue:&result];
        return result;
    }
    return result;
}

@end
