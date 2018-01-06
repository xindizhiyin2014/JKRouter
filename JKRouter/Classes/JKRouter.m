//
//  JKRouter.m
//  
//
//  Created by nie on 17/1/11.
//  Copyright © 2017年 localadmin. All rights reserved.
//

#import "JKRouter.h"
#import <JKDataHelper/JKDataHelper.h>
#ifdef DEBUG
#define JKRouterLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define JKRouterLog(...)
#endif



//******************************************************************************
//*
//*           RouterOptions类
//*           配置跳转时的各种设置
//******************************************************************************

@interface RouterOptions()

//每个页面所对应的moduleID
@property (nonatomic, copy, readwrite) NSString *moduleID;

@end


@implementation RouterOptions

+ (instancetype)options{
    RouterOptions *options = [RouterOptions new];
    options.transformStyle = RouterTransformVCStyleDefault;
    options.animated = YES;
    return options;
}

+ (instancetype)optionsWithModuleID:(NSString *)moduleID{

    RouterOptions *options = [RouterOptions options];
    options.moduleID = moduleID;
    return options;
}


+ (instancetype)optionsWithDefaultParams:(NSDictionary *)params{
    
    RouterOptions *options = [RouterOptions options];
    options.defaultParams = params;
    return options;
}

- (instancetype)optionsWithDefaultParams:(NSDictionary *)params{

    self.defaultParams = params;
    return self;
}

@end


//**********************************************************************************
//*
//*           JKRouter类
//*
//**********************************************************************************



@interface JKRouter()

@property (nonatomic, copy, readwrite) NSSet * modules;     ///< 存储路由，moduleID信息，权限配置信息
@property (nonatomic,copy) NSArray<NSString *> *routerFileNames; // 路由配置信息的json文件名数组

@property (nonatomic,strong) NSSet *urlSchemes;//支持的URL协议集合

@property (nonatomic,strong) NSString *webContainerName;//自定义的URL协议名字


@property (nonatomic,weak) UINavigationController *navigationController; ///< app的导航控制器

@end

@implementation JKRouter


//重写该方法，防止外部修改该类的对象
+ (BOOL)accessInstanceVariablesDirectly{
        
    return NO;
}


static JKRouter *defaultRouter =nil;

/**
 初始化单例
 
 @return JKRouter 的单例对象
 */
+ (instancetype)router{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultRouter = [JKRouter new];
    });
    
    return defaultRouter;
}

- (UINavigationController *)navigationController{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [rootVC isKindOfClass:[UINavigationController class]]?(UINavigationController *)rootVC:nil;
}

+ (void)configWithRouterFiles:(NSArray<NSString *> *)routerFileNames{
    
    [JKRouter router].routerFileNames = routerFileNames;
    [JKRouter router].urlSchemes  =  [NSSet setWithArray:[JKRouterExtension urlSchemes]];
    [JKRouter router].webContainerName = [JKRouterExtension jkWebVCClassName];
}

- (NSSet *)modules{
    if (!_modules) {
        NSArray *moudulesArr =[JKJSONHandler getModulesFromJsonFile:[JKRouter router].routerFileNames];
        _modules = [NSSet setWithArray:moudulesArr];
    }
    return _modules;
}

# pragma mark the open functions - - - - - - - - -
+ (void)open:(NSString *)vcClassName{
    
    RouterOptions *options = [RouterOptions options];
    [self open:vcClassName options:options];
}


+ (void)open:(NSString *)vcClassName options:(RouterOptions *)options{

    [self open:vcClassName options:options CallBack:nil];
}

+ (void)open:(NSString *)vcClassName optionsWithJSON:(RouterOptions *)options{
    if (!JKSafeStr(vcClassName)) {
        NSAssert(NO, @"vcClassName is nil or vcClassName is not a string");
        return;
    }
    if (!options) {
        options = [RouterOptions options];
    }
    UIViewController *vc =[NSClassFromString(vcClassName) jkRouterViewControllerWithJSON:options.defaultParams];
    //根据配置好的VC，options配置进行跳转
    if (![self routerViewController:vc options:options]) {//跳转失败
        return;
    }
   
}


+ (void)openSpecifiedVC:(UIViewController *)vc options:(RouterOptions *)options{
    if (!options) {
        options = [RouterOptions options];
        
    }

     [self routerViewController:vc options:options];
}


+ (void)open:(NSString *)vcClassName options:(RouterOptions *)options CallBack:(void(^)(void))callback{
    
    if (!JKSafeStr(vcClassName)) {
        NSAssert(NO, @"vcClassName is nil or vcClassName is not a string");
        return;
    }
    if (!options) {
        options = [RouterOptions options];
    }
    UIViewController *vc = [self configVC:vcClassName options:options];
    //根据配置好的VC，options配置进行跳转
    if (![self routerViewController:vc options:options]) {//跳转失败
        return;
    }
    if (callback) {
        callback();
    }
    
}

+ (void)URLOpen:(NSString *)url{
    
    [self URLOpen:url params:nil];
}


+ (void)URLOpen:(NSString *)url params:(NSDictionary *)params{
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *targetURL = [NSURL URLWithString:url];
    NSString *scheme =targetURL.scheme;
    if (![[JKRouter router].urlSchemes containsObject:scheme]) {
        return;
    }
    if (![JKRouterExtension safeValidateURL:url]) {
        return;
    }
    
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        
        [self httpOpen:targetURL];
        return;
        
    }
    //URL的端口号作为moduleID
    NSNumber *moduleID = targetURL.port;
    if (moduleID) {
        NSString *homePath = [JKJSONHandler getHomePathWithModuleID:moduleID];
        if ([NSClassFromString(homePath) isSubclassOfClass:[UIViewController class]]) {
            NSString *parameterStr = [[targetURL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *dic = nil;
            if (JKSafeStr(parameterStr)) {
                
                dic = [self convertUrlStringToDictionary:parameterStr];
                [dic addEntriesFromDictionary:params];
            }else{
                dic = [NSMutableDictionary dictionaryWithDictionary:params];
            }
            NSString *vcClassName = homePath;
            RouterOptions *options = [RouterOptions optionsWithModuleID:[NSString stringWithFormat:@"%@",moduleID]];
            options.defaultParams = [dic copy];
            //执行页面的跳转
            [self open:(NSString *)vcClassName options:options];
            
        }else{
          NSString *subPath = targetURL.resourceSpecifier;
          NSString *path = [NSString stringWithFormat:@"%@/%@",homePath,subPath];
          RouterOptions *options = [RouterOptions optionsWithModuleID:[NSString stringWithFormat:@"%@",moduleID]];
          [self jumpToHttpWeb:path options:options];
            
        }
    }else{
        NSString *path = targetURL.path;
        if ([NSClassFromString(path) isKindOfClass:[UIViewController class]]) {
            NSString *parameterStr = [[targetURL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *dic = nil;
            if (JKSafeStr(parameterStr)) {
                
                dic = [self convertUrlStringToDictionary:parameterStr];
                [dic addEntriesFromDictionary:params];
            }else{
                dic = [NSMutableDictionary dictionaryWithDictionary:params];
            }
            NSString *vcClassName = path;
            RouterOptions *options = [RouterOptions optionsWithModuleID:[NSString stringWithFormat:@"%@",moduleID]];
            options.defaultParams = [dic copy];
            //执行页面的跳转
            [self open:(NSString *)vcClassName options:options];
        }else{
            RouterOptions *options = [RouterOptions optionsWithModuleID:[NSString stringWithFormat:@"%@",moduleID]];
            [self jumpToHttpWeb:path options:options];
        }
    }
    
}


+ (void)httpOpen:(NSURL *)targetURL{
    NSString *parameterStr = [[targetURL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (JKSafeStr(parameterStr)) {
      NSMutableDictionary *dic = [self convertUrlStringToDictionary:parameterStr];
        NSDictionary *params = [dic copy];
        if (JKSafeDic(params) && [[params objectForKey:JKRouterHttpOpenStyleKey] isEqualToString:@"1"]) {//判断是否是在app内部打开网页
            RouterOptions *options = [RouterOptions options];
            [self jumpToHttpWeb:targetURL.absoluteString options:options];
            return;
        }
    }
    [self openExternal:targetURL];
}

/**
 根据路径跳转到指定的httpWeb页面
 
 @param directory 指定的路径
 */
+ (void)jumpToHttpWeb:(NSString *)directory options:(RouterOptions *)options{
    if (!JKSafeStr(directory)) {
        JKRouterLog(@"路径不存在");
        return;
    }
    
    NSString *path =[NSString stringWithFormat:@"%@/%@",[JKRouterExtension sandBoxBasePath],directory];
    NSDictionary *params = @{[JKRouterExtension jkWebURLKey]:path};
    options.defaultParams =params;
    [self open:[JKRouter router].webContainerName options:options];
    
}

+ (void)openExternal:(NSURL *)targetURL {
    if ([targetURL.scheme isEqualToString:@"http"] ||[targetURL.scheme isEqualToString:@"https"]) {
        [[UIApplication sharedApplication] openURL:targetURL];
    }else{
        NSAssert(NO, @"请打开http／https协议的url地址");
    }
}

#pragma mark  the pop functions - - - - - - - - - -

+ (void)pop{

    [self pop:YES];
}

+ (void)pop:(BOOL)animated{

    [self pop:nil :animated];
}

+ (void)pop:(NSDictionary *)params :(BOOL)animated{
    
    NSArray *vcArray = [JKRouter router].navigationController.viewControllers;
    NSUInteger count = vcArray.count;
    UIViewController *vc= nil;
    if (vcArray.count>1) {
        vc = vcArray[count-2];
    }else{
        //已经是根视图，不再执行pop操作  可以执行dismiss操作
        [self popToSpecifiedVC:nil animated:animated];

        return;
    }
    RouterOptions *options = [RouterOptions optionsWithDefaultParams:params];
    [self configTheVC:vc options:options];
    [self popToSpecifiedVC:vc animated:animated];

}


+ (void)popToSpecifiedVC:(UIViewController *)vc{

    [self popToSpecifiedVC:vc animated:YES];
}

+ (void)popToSpecifiedVC:(UIViewController *)vc animated:(BOOL)animated{

    if ([JKRouter router].navigationController.presentedViewController) {
        
        [[JKRouter router].navigationController dismissViewControllerAnimated:animated completion:nil];
    }
    else {
        
        [[JKRouter router].navigationController popToViewController:vc animated:animated];
    }
}

+ (void)popWithSpecifiedModuleID:(NSString *)moduleID{

    [self popWithSpecifiedModuleID:moduleID :nil :YES];
}

+ (void)popWithSpecifiedModuleID:(NSString *)moduleID :(NSDictionary *)params :(BOOL)animated{
    NSArray *vcArray  = [JKRouter router].navigationController.viewControllers;
        for (NSInteger i = vcArray.count-1; i>0; i--) {
            UIViewController *vc = vcArray[i];
            if ([vc.moduleID isEqualToString:moduleID]) {
                RouterOptions *options = [RouterOptions optionsWithDefaultParams:params];
                [self configTheVC:vc options:options];
                [self popToSpecifiedVC:vc animated:animated];
            }
        }
}


#pragma mark  the tool functions - - - - - - - -

//为ViewController 的属性赋值
+ (UIViewController *)configVC:(NSString *)vcClassName options:(RouterOptions *)options {

    Class VCClass = NSClassFromString(vcClassName);
    UIViewController *vc = [VCClass jkRouterViewController];
    [vc setValue:options.moduleID forKey:JKRouterModuleIDKey];
    
    [JKRouter configTheVC:vc options:options];
    
    return vc;
}

/**
 对于已经创建的vc进行赋值操作

 @param vc 对象
 @param options 跳转的各种设置
 */
+ (void)configTheVC:(UIViewController *)vc options:(RouterOptions *)options{

    if (JKSafeDic(options.defaultParams)) {
        NSArray *propertyNames = [options.defaultParams allKeys];
        for (NSString *key in propertyNames) {
            id value =options.defaultParams[key];
            [vc setValue:value forKey:key];
        }
    }
}
   
//将url ？后的字符串转换为NSDictionary对象
+ (NSMutableDictionary *)convertUrlStringToDictionary:(NSString *)string{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *parameterArr = [string componentsSeparatedByString:@"&"];
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

//根据相关的options配置，进行跳转
+ (BOOL)routerViewController:(UIViewController *)vc options:(RouterOptions *)options{
    
    if (![[vc class]  validateTheAccessToOpen]) {//权限不够进行别的操作处理
        //根据具体的权限设置决定是否进行跳转，如果没有权限，跳转中断，进行后续处理
        [[vc class] handleNoAccessToOpen];
        return NO;
    }
    if (!([JKRouter router].navigationController && [[JKRouter router].navigationController isKindOfClass:[UINavigationController class]])) {
        return NO;
    }
    if ([JKRouter router].navigationController.presentationController) {
        
        [[JKRouter router].navigationController dismissViewControllerAnimated:NO completion:nil]; 
    }
    if (options.transformStyle == RouterTransformVCStyleDefault) {
        options.transformStyle =  [vc jkRouterTransformStyle];
    }
    switch (options.transformStyle) {
        case RouterTransformVCStylePush:
            {
                [self _openWithPushStyle:vc options:options];
            }
            break;
            case RouterTransformVCStylePresent:
            {
                [self _openWithPresentStyle:vc options:options];
            }
            break;
            case RouterTransformVCStyleOther:
            {
                [self _openWithOtherStyle:vc options:options];
            }
            break;
            
        default:
            break;
    }
    
    return NO;
}

+ (BOOL)_openWithPushStyle:(UIViewController *)vc options:(RouterOptions *)options{
    [[JKRouter router].navigationController pushViewController:vc animated:options.animated];
    return YES;
}

+ (BOOL)_openWithPresentStyle:(UIViewController *)vc options:(RouterOptions *)options{
    [[JKRouter router].navigationController presentViewController:vc animated:options.animated completion:nil];
    return YES;
}

+ (BOOL)_openWithOtherStyle:(UIViewController *)vc options:(RouterOptions *)options{
    [vc jkRouterSpecialTransformWithNaVC:[JKRouter router].navigationController];
    return YES;
}



@end
