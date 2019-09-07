//
//  JKRouter.m
//  
//
//  Created by nie on 17/1/11.
//  Copyright © 2017年 localadmin. All rights reserved.
//

#import "JKRouter.h"
#import "UINavigationController+JKRouter.h"
#import "JKRouterTool.h"
#import "JKRouterExtension.h"

//**********************************************************************************
//*
//*           JKRouter类
//*
//**********************************************************************************

@interface JKRouter()

@property (nonatomic, strong, readwrite) NSMutableSet * modules;               ///< 存储路由，moduleID信息，权限配置信息
@property (nonatomic, copy) NSArray<NSString *> *routerFileNames;              ///< 路由配置信息的json文件名数组

@property (nonatomic, strong) NSSet *urlSchemes;                               ///< 支持的URL协议集合

@property (nonatomic, copy) NSString *remoteFilePath;                          ///< 从网络上下载的路由配置信息的json文件保存在沙盒中的路径
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, weak, readwrite) UIViewController *topVC;                ///< app的最顶部的控制器
@property (nonatomic, weak) UIViewController *lastTopVC;                       ///< app次顶部的控制器
@property (nonatomic, assign) NSUInteger totalSteps;                           ///< 从rootVC到topVC正常情况总共需要open几次

@end

@implementation JKRouter

static JKRouter *defaultRouter =nil;

/**
 初始化单例
 
 @return JKRouter 的单例对象
 */
+ (instancetype)sharedRouter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultRouter = [[self alloc] init];
        defaultRouter.lock = [[NSLock alloc] init];
    });
    return defaultRouter;
}

- (UIViewController *)topVC
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        UIViewController *vc = tabBarVC.selectedViewController;
        return [self _findTopVC:vc];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return [self _findTopVC:rootVC];
    }
    return rootVC;
}

- (NSUInteger)totalSteps
{
    NSUInteger totalSteps = 0;
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *tmpVC = rootVC;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        UIViewController *tmpVC = tabBarVC.selectedViewController;
        return [self _getTotalStepFromVC:tmpVC originSteps:totalSteps];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return [self _getTotalStepFromVC:tmpVC originSteps:totalSteps];
    }
    return totalSteps;
}

- (UIViewController *)lastTopVC
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *lastTopVC = nil;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        UIViewController *vc = tabBarVC.selectedViewController;
        return [self _findLastTopVC:vc lastTopVC:lastTopVC];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return [self _findLastTopVC:rootVC lastTopVC:lastTopVC];
    }
    return lastTopVC;
}

+ (void)configWithRouterFiles:(NSArray<NSString *> *)routerFileNames
{
    [JKRouter sharedRouter].routerFileNames = routerFileNames;
    NSMutableSet *urlSchemesSet = [NSMutableSet setWithArray:[JKRouterExtension urlSchemes]];
    [urlSchemesSet addObjectsFromArray:[JKRouterExtension specialSchemes]];
    [JKRouter sharedRouter].urlSchemes  = [urlSchemesSet copy];
}

+ (void)updateRouterInfoWithFilePath:(NSString*)filePath
{
    [JKRouter sharedRouter].remoteFilePath = filePath;
    [JKRouter sharedRouter].modules = nil;
}

- (NSMutableSet *)modules
{
    if (!_modules) {
        [_lock lock];
        _modules = [NSMutableSet new];
        if (!_remoteFilePath) {
            NSArray *moudulesArr =[JKJSONHandler getModulesFromJsonFile:[JKRouter sharedRouter].routerFileNames];
            [_modules addObjectsFromArray: moudulesArr];
        }else{
            NSData *data = [NSData dataWithContentsOfFile:_remoteFilePath];
            NSArray *modules = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (modules.count>0) {
                [_modules addObjectsFromArray:modules];
            }
        }
        [_lock unlock];
    }
    return _modules;
}

#pragma mark  - - - - the open functions - - - -
+ (BOOL)open:(NSString *)targetClassName
{
    return [self open:targetClassName params:nil];
}

+ (BOOL)open:(NSString *)targetClassName
      params:(NSDictionary *)params
{
   JKRouterOptions *options = [JKRouterOptions optionsWithDefaultParams:params];
   return [self open:targetClassName options:options];
}

+ (BOOL)open:(NSString *)targetClassName options:(JKRouterOptions *)options
{
    return [self open:targetClassName options:options complete:nil];
}

+ (BOOL)open:(NSString *)targetClassName
     options:(JKRouterOptions *)options
    complete:(void(^)(id result,NSError *error))completeBlock
{
    if (!targetClassName || ([targetClassName isKindOfClass:[NSString class]] && targetClassName.length == 0)) {
        NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorClassNameIsNil userInfo:@{@"msg":@"targetClassName is nil or targetClassName is not a string"}];
        if (completeBlock) {
            completeBlock(nil,error);
        }
        return NO;
    }
    if (!options) {
        options = [JKRouterOptions options];
    }
    
    Class targetClass = nil;
    if (options.module && [options.module isKindOfClass:[NSString class]] && options.module.length > 0) {
        targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",options.module,targetClassName]);
    }else{
        targetClass = NSClassFromString(targetClassName);
        if (!targetClass) {
        targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",[JKRouterExtension appTargetName],targetClassName]);
        }
    }
    if (!targetClass) {
        if (completeBlock) {
            NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorClassNil userInfo:@{@"msg":@"targetClass is nil"}];
            completeBlock(nil,error);
        }
        return NO;
    }
   return [self openWithClass:targetClass options:options complete:completeBlock];
}

+ (BOOL)openWithClass:(Class)targetClass
              options:(JKRouterOptions *)options
{
    return [self openWithClass:targetClass options:options complete:nil];
}

+ (BOOL)openWithClass:(Class)targetClass
              options:(JKRouterOptions *)options
             complete:(void(^)(id result,NSError *error))completeBlock
{
    if ([targetClass respondsToSelector:@selector(jkIsTabBarItemVC)] && [targetClass jkIsTabBarItemVC]) {
        return [JKRouterExtension jkSwitchTabClass:targetClass options:options complete:completeBlock];
    }else{
        //根据配置好的VC，options配置进行跳转
        return [self routerViewControllerWithClass:targetClass options:options complete:completeBlock];
    }
}

+ (BOOL)openSpecifiedVC:(UIViewController *)vc
                options:(JKRouterOptions *)options
               complete:(void(^)(id result,NSError *error))completeBlock
{
    if (!options) {
        options = [JKRouterOptions options];
    }
    Class vcClass = [vc class];
    if (![vcClass  validateTheAccessToOpenWithOptions:options]) {//权限不够进行别的操作处理
        //根据具体的权限设置决定是否进行跳转，如果没有权限，跳转中断，进行后续处理
        [vcClass handleNoAccessToOpenWithOptions:options];
        if (completeBlock) {
            NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorNORightToAccess userInfo:@{@"msg":@"do not have  access to open this vc"}];
            completeBlock(nil,error);
        }
        return NO;
    }
    
   return [self _transformVC:vc options:options complete:completeBlock];
}

+ (BOOL)URLOpen:(NSString *)url
{
     return [self URLOpen:url extra:nil];
}

+ (BOOL)URLOpen:(NSString *)url
          extra:(NSDictionary *)extra
{
    return [self URLOpen:url extra:extra complete:nil];
}

+ (BOOL)URLOpen:(NSString *)url
          extra:(NSDictionary *)extra
       complete:(void(^)(id result,NSError *error))completeBlock
{
    if(!url){
        if(completeBlock){
            NSError * error = [NSError errorWithDomain:JKRouterErrorDomain code:JKRouterErrorURLIsNil userInfo:@{@"message":@"url can not be nil"}];
            completeBlock(nil,error);
        }
        return NO;
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *targetURL = [NSURL URLWithString:url];
    NSString *scheme =targetURL.scheme;
    if (![[JKRouter sharedRouter].urlSchemes containsObject:scheme]) {
        if(completeBlock){
            NSError * error = [NSError errorWithDomain:JKRouterErrorDomain code:JKRouterErrorSystemUnSupportURLScheme userInfo:@{@"message":@"do not support this scheme of the url"}];
            completeBlock(nil,error);
        }
        return NO;
    }
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        return [self httpOpen:targetURL extra:extra complete:completeBlock];
    }
    if ([scheme isEqualToString:@"file"]) {
        return [self jumpToSandBoxWeb:url extra:extra complete:completeBlock];
    }
    if ([scheme isEqualToString:@"itms-apps"] || [scheme isEqualToString:@"app-settings"] || [scheme isEqualToString:@"tel"]) {
       return [self openExternal:targetURL complete:completeBlock];
        
    }
    if ([[JKRouterExtension specialSchemes] containsObject:scheme]) {
       return [JKRouterExtension openURLWithSpecialSchemes:targetURL extra:extra complete:completeBlock];
    }
    NSString *moduleID = [targetURL.path substringFromIndex:1];
    NSString *type = [JKJSONHandler getTypeWithModuleID:moduleID];
    
    if ([type isEqualToString:[JKRouterExtension jkModuleTypeViewControllerKey]]) {
        NSString *swiftModuleName = [JKJSONHandler getSwiftModuleNameWithModuleID:moduleID];
        NSString *targetClassName = [JKJSONHandler getTargetWithModuleID:moduleID];
        JKRouterOptions *options = [JKRouterOptions options];
        options.module = swiftModuleName;
        
        Class targetClass = nil;
        if (options.module && [options.module isKindOfClass:[NSString class]] && options.module.length > 0) {
            targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",options.module,targetClassName]);
        }else{
            targetClass = NSClassFromString(targetClassName);
            if (!targetClass) {
            targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",[JKRouterExtension appTargetName],targetClassName]);
           }
        }
        if (!targetClass) {
            if (completeBlock) {
                NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorClassNil userInfo:@{@"msg":@"targetClass is nil"}];
                completeBlock(nil,error);
            }
            return NO;
        }
        if ([targetClass isSubclassOfClass:[UIViewController class]]) {
            NSString *parameterStr = [[targetURL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *dic = nil;
            if (parameterStr && [parameterStr isKindOfClass:[NSString class]] && parameterStr.length > 0) {
                dic = [JKRouterTool convertUrlStringToDictionary:parameterStr];
                [dic addEntriesFromDictionary:extra];
            }else{
                dic = [NSMutableDictionary dictionaryWithDictionary:extra];
            }
            JKRouterOptions *options = [JKRouterOptions options];
            options.defaultParams = [dic copy];
            //执行页面的跳转
            return [self openWithClass:targetClass options:options complete:completeBlock];
        }else{//进行特殊路由跳转的操作
            return [JKRouterExtension otherActionsWithActionType:type URL:targetURL extra:extra complete:completeBlock];
        }
    }else if ([type isEqualToString:[JKRouterExtension  jkModuleTypeFactoryKey]]){
       NSString *factoryClassName = [JKJSONHandler getTargetWithModuleID:moduleID];
        NSString *swiftModuleName = [JKJSONHandler getSwiftModuleNameWithModuleID:moduleID];
        JKRouterOptions *options = [JKRouterOptions options];
        options.module = swiftModuleName;
        Class targetClass = nil;
        if (options.module && [options.module isKindOfClass:[NSString class]] && options.module.length > 0) {
            targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",options.module,factoryClassName]);
        }else{
            targetClass = NSClassFromString(factoryClassName);
            if (!targetClass) {
                targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",[JKRouterExtension appTargetName],factoryClassName]);
            }
        }
        if (!targetClass) {
            if (completeBlock) {
                NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorClassNil userInfo:@{@"msg":@"targetClass is nil"}];
                completeBlock(nil,error);
            }
            return NO;
        }
        
        NSString *parameterStr = [[targetURL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *dic = nil;
        if (parameterStr && [parameterStr isKindOfClass:[NSString class]] && parameterStr.length > 0) {
            dic = [JKRouterTool convertUrlStringToDictionary:parameterStr];
            [dic addEntriesFromDictionary:extra];
        }else{
            dic = [NSMutableDictionary dictionaryWithDictionary:extra];
        }
        options.defaultParams = [dic copy];
        if ([targetClass respondsToSelector:@selector(jkRouterFactoryViewControllerWithJSON:)]) {
            
            return [JKRouter routerViewControllerWithClass:targetClass options:options complete:completeBlock];
        }
    }
    else{
        //进行非路由跳转的操作
       return [JKRouterExtension otherActionsWithActionType:type URL:targetURL extra:extra complete:completeBlock];
    }
    return NO;
}

+ (BOOL)httpOpen:(NSURL *)url
           extra:(NSDictionary *)extra
        complete:(void(^)(id result,NSError *error))completeBlock
{
    if ([JKRouterExtension isVerifiedOfBlackName:url.absoluteString]) {
        if (completeBlock) {
            NSError * error = [NSError errorWithDomain:JKRouterErrorDomain code:JKRouterErrorBlackNameURL userInfo:@{@"message":@"the url is in blacklist"}];
            completeBlock(nil,error);
        }
        return NO;
    }
    NSString *webContainerName = nil;
    if ([JKRouterExtension isVerifiedOfWhiteName:url.absoluteString]) {
        webContainerName = [JKRouterExtension privateWebVCClassName];
    }else{
        webContainerName = [JKRouterExtension openWebVCClassName];
    }
    NSString *parameterStr = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (parameterStr && parameterStr.length > 0) {
        NSMutableDictionary *dic = [JKRouterTool convertUrlStringToDictionary:parameterStr];
        if (dic && [dic isKindOfClass:[NSDictionary class]] && [[dic objectForKey:[JKRouterExtension jkBrowserOpenKey]] isEqualToString:@"1"]) {//在safari打开网页
            [self openExternal:[JKRouterTool url:url removeQueryKeys:@[[JKRouterExtension jkBrowserOpenKey]]]];
        } else {
            NSString *key1 = [JKRouterExtension jkBrowserOpenKey];
            url = [JKRouterTool url:url removeQueryKeys:@[key1]];
            NSDictionary *tempParams = @{[JKRouterExtension jkWebURLKey]:url.absoluteString};
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:tempParams];
            [params addEntriesFromDictionary:extra];
            JKRouterOptions *options = [JKRouterOptions optionsWithDefaultParams:[params copy]];
            return [self open:webContainerName options:options complete:completeBlock];
        }
    }else{
        NSDictionary *tempParams = @{[JKRouterExtension jkWebURLKey]:url.absoluteString};
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:tempParams];
        [params addEntriesFromDictionary:extra];
        JKRouterOptions *options = [JKRouterOptions optionsWithDefaultParams:[params copy]];
        return [self open:webContainerName options:options complete:completeBlock];
    }
    return NO;
}

+ (BOOL)jumpToSandBoxWeb:(NSString *)url
                   extra:(NSDictionary *)extra
                complete:(void(^)(id result,NSError *error))completeBlock
{

    if (!url || (url && ![url isKindOfClass:[NSString class]])) {
        NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorSandBoxPathIsNil userInfo:@{@"msg":@"the sandbox filepath is not exist"}];
        if (completeBlock) {
            completeBlock(nil,error);
        }
        return NO;
    }
    NSDictionary *params = @{[JKRouterExtension jkWebURLKey]:url};
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [dic addEntriesFromDictionary:extra];
     JKRouterOptions *options = [JKRouterOptions optionsWithDefaultParams:[dic copy]];
    NSString *webContainerName = [JKRouterExtension privateWebVCClassName];
    return [self open:webContainerName options:options complete:completeBlock];
}

+ (BOOL)openExternal:(NSURL *)targetURL
{
    return [self openExternal:targetURL complete:nil];
}

+ (BOOL)openExternal:(NSURL *)targetURL
            complete:(void(^)(id result,NSError *error))completeBlock
{
    if ([targetURL.scheme isEqualToString:@"http"] ||[targetURL.scheme isEqualToString:@"https"] || [targetURL.scheme isEqualToString:@"itms-apps"] || [targetURL.scheme isEqualToString:@"tel"]) {
        if (@available(iOS 10.0,*)) {
                [[UIApplication sharedApplication] openURL:targetURL options:@{} completionHandler:^(BOOL success) {
                    if (completeBlock) {
                        NSError *error = nil;
                        if (!success) {
                            error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorSystemUnSupportURL userInfo:@{@"msg":@"the  app system can not open this url"}];
                        }
                        completeBlock(nil,error);
                        
                    }
                }];
            return YES;
        }else{
            if ([[UIApplication sharedApplication] canOpenURL:targetURL]) {
                [[UIApplication sharedApplication] openURL:targetURL];
                if (completeBlock) {
                    completeBlock(nil,nil);
                }
                return YES;
            }else{
                
                if (completeBlock) {
                    NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorSystemUnSupportURL userInfo:@{@"msg":@"the  app system can not open this url"}];
                    completeBlock(nil,error);
                }
                return NO;
            }
        }
    }else{
        
        if (completeBlock) {
            NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorSystemUnSupportURLScheme userInfo:@{@"msg":@"do not support this scheme"}];
            completeBlock(nil,error);
        }
        return NO;
        
    }
}

#pragma mark  - - - - the pop functions - - - -

+ (void)pop
{
    [self pop:YES];
}

+ (void)pop:(BOOL)animated
{
    JKRouterOptions *options = [JKRouterOptions options];
    options.animated = animated;
    [self popWithOptions:options];
}

+ (void)popWithOptions:(JKRouterOptions *)options
{
    [self popWithOptions:options complete:nil];
}

+ (void)popWithOptions:(JKRouterOptions *)options
              complete:(void(^)(id result,NSError *error))completeBlock
{
    if (!options) {
        options = [JKRouterOptions options];
    }
    [self popToSpecifiedVC:nil options:options complete:completeBlock];
}

+ (void)popToSpecifiedVC:(UIViewController *)vc
{
    [self popToSpecifiedVC:vc animated:YES];
}

+ (void)popToSpecifiedVC:(UIViewController *)vc
                animated:(BOOL)animated
{
    [self popToSpecifiedVC:vc options:nil animated:YES];
}

+ (void)popToSpecifiedVC:(UIViewController *)vc
                 options:(JKRouterOptions *)options
                animated:(BOOL)animated
{
    if (!options) {
        options = [JKRouterOptions options];
    }
    options.animated = animated;
    [self popToSpecifiedVC:vc options:options complete:nil];
}

+ (void)popToSpecifiedVC:(UIViewController *)vc
                 options:(JKRouterOptions *)options
                complete:(void(^)(id result,NSError *error))completeBlock
{
    if (!vc) {
        UIViewController *currentVC = [JKRouter sharedRouter].topVC;
        UIViewController *lastTopVC = [JKRouter sharedRouter].lastTopVC;
        [JKRouterTool configTheVC:lastTopVC options:options];
        if (currentVC.navigationController && currentVC.navigationController.viewControllers.count > 1) {
            [currentVC.navigationController popViewControllerAnimated:options.animated];
            if (completeBlock) {
                completeBlock(nil,nil);
            }
        }else if (currentVC.navigationController && currentVC.navigationController.isPresented) {
            UINavigationController *naVC = (UINavigationController *)currentVC;
            [naVC dismissViewControllerAnimated:options.animated completion:^{
                if (completeBlock) {
                    completeBlock(nil,nil);
                }
            }];
        }else if (!currentVC.navigationController) {
            [currentVC dismissViewControllerAnimated:options.animated completion:^{
                if (completeBlock) {
                    completeBlock(nil,nil);
                }
            }];
        } else {
            if (completeBlock) {
                NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorUnSupportPopAtcion userInfo:@{@"msg":@"do not support this pop action"}];
                completeBlock(nil,error);
            }
        }
    }
    else {
        if ([self _isRouterContainVC:vc]) {
            [JKRouterTool configTheVC:vc options:options];
            UIViewController *currentVC = nil;
            while (![[JKRouter sharedRouter].lastTopVC isEqual:vc]) {
                currentVC = [JKRouter sharedRouter].topVC;
                [self pop:NO];
            }
            [self popWithOptions:options complete:completeBlock];
        } else {
            if (completeBlock) {
                NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorNoVCInRouter userInfo:@{@"msg":@"no vc is router"}];
                completeBlock(nil,error);
            }
        }
    }
}

+ (void)popWithSpecifiedModuleID:(NSString *)moduleID
{
    [self popWithSpecifiedModuleID:moduleID :YES];
}

+ (void)popWithSpecifiedModuleID:(NSString *)moduleID
                                :(BOOL)animated
{
    JKRouterOptions *options = [JKRouterOptions options];
    options.animated = animated;
    [self popWithSpecifiedModuleID:moduleID options:options complete:nil];
}

+ (void)popWithSpecifiedModuleID:(NSString *)moduleID
                         options:(JKRouterOptions *)options
                        complete:(void(^)(id result,NSError *error))completeBlock
{
    UIViewController *vc = [self _findVCWithModuleID:moduleID];
    if (vc) {
        if (options) {
            options = [JKRouterOptions options];
        }
        [self popToSpecifiedVC:vc options:options complete:completeBlock];
    } else {
        if (completeBlock) {
            NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorNoVCInRouter userInfo:@{@"msg":@"no vc is router"}];
            completeBlock(nil,error);
        }
    }
}

+ (void)popWithStep:(NSUInteger)step
{
    [self popWithStep:step :YES];
}

+ (void)popWithStep:(NSUInteger)step :(BOOL)animated
{
    JKRouterOptions *options = [JKRouterOptions new];
    options.animated = animated;
    [self popWithStep:step options:options complete:nil];
}

+ (void)popWithStep:(NSUInteger)step
            options:(JKRouterOptions *)options
           complete:(void(^)(id result,NSError *error))completeBlock
{
    NSUInteger totalSteps = [JKRouter sharedRouter].totalSteps;
    if (step > totalSteps) {
        step = totalSteps;
    }
    UIViewController *vc = [self _findVCWithPopStep:step];
    if (vc) {
        if (options) {
            options = [JKRouterOptions options];
        }
        [self popToSpecifiedVC:vc options:options animated:options.animated];
    } else {
        if (completeBlock) {
            NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorNoVCInRouter userInfo:@{@"msg":@"no vc is router"}];
            completeBlock(nil,error);
        }
    }
}

#pragma mark  - - - - the tool functions - - - -

+ (BOOL)replaceCurrentViewControllerWithTargetVC:(UIViewController *)targetVC
{
    UIViewController *currentVC = [JKRouter sharedRouter].topVC;
    if (!currentVC.navigationController) {
        return NO;
    } else {
        UINavigationController *naVC = currentVC.navigationController;
        if ([[NSThread currentThread] isMainThread]) {
            NSArray *viewControllers = naVC.viewControllers;
            NSMutableArray *vcArray = [NSMutableArray arrayWithArray:viewControllers];
            [vcArray replaceObjectAtIndex:viewControllers.count-1 withObject:targetVC];
            [naVC setViewControllers:[vcArray copy] animated:YES];
            [naVC setViewControllers:[vcArray copy] animated:YES];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *viewControllers = naVC.viewControllers;
                NSMutableArray *vcArray = [NSMutableArray arrayWithArray:viewControllers];
                [vcArray replaceObjectAtIndex:viewControllers.count-1 withObject:targetVC];
                [naVC setViewControllers:[vcArray copy] animated:YES];
                [naVC setViewControllers:[vcArray copy] animated:YES];
            });
        }
        return YES;
    }
    
}

+ (BOOL)updateLastTopVC:(JKRouterOptions *)options
{
    UIViewController *lastTopVC = [JKRouter sharedRouter].lastTopVC;
    if (lastTopVC) {
        [JKRouterTool configTheVC:lastTopVC options:options];
        return YES;
    }
    return NO;
}

//根据相关的options配置，进行跳转
+ (BOOL)routerViewControllerWithClass:(Class)vcClass
                     options:(JKRouterOptions *)options
                    complete:(void(^)(id result,NSError *error))completeBlock
{
    UIViewController *vc = nil;
    if (![vcClass isSubclassOfClass:[UIViewController class]]) {
        if ([vcClass respondsToSelector:@selector(jkRouterFactoryViewControllerWithJSON:)]) {
            vc = [vcClass jkRouterFactoryViewControllerWithJSON:options.defaultParams];
            vcClass = [vc class];
        }else{
            NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorUnSupportRouterClass userInfo:@{@"msg":@"do not support the class in JKRouter"}];
            completeBlock(nil,error);
            return NO;
        }
    }
    if (![vcClass validateTheAccessToOpenWithOptions:options]) {//权限不够进行别的操作处理
        //根据具体的权限设置决定是否进行跳转，如果没有权限，跳转中断，进行后续处理
        [vcClass handleNoAccessToOpenWithOptions:options];
        if (completeBlock) {
            NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorNORightToAccess userInfo:@{@"msg":@"do not have  access to open vc"}];
            completeBlock(nil,error);
        }
        return NO;
    }
    if (options.createStyle == RouterCreateStyleRefresh) {
        vc = [JKRouter sharedRouter].topVC;
    } else {
        if (!vc) {
            vc = [vcClass jkRouterViewControllerWithJSON:options.defaultParams];
        }
    }
    
   return [self _transformVC:vc options:options complete:completeBlock];
}

+ (BOOL)_transformVC:(UIViewController *)vc
             options:(JKRouterOptions *)options
            complete:(void(^)(id result,NSError *error))completeBlock
{
    if (options.transformStyle == RouterTransformVCStyleDefault) {
        options.transformStyle =  [vc jkRouterTransformStyle];
    }
    switch (options.transformStyle) {
        case RouterTransformVCStylePush:
        {
            return [self _openWithPushStyle:vc options:options complete:completeBlock];
        }
            break;
        case RouterTransformVCStylePresent:
        {
            return [self _openWithPresentStyle:vc options:options complete:completeBlock];
        }
            break;
        case RouterTransformVCStyleOther:
        {
            return [self _openWithOtherStyle:vc options:options complete:completeBlock];
        }
            break;
            
        default:
            break;
    }
    if (completeBlock) {
        NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorUnSupportTransform userInfo:@{@"msg":@"do not support this transformStyle"}];
        completeBlock(nil,error);
    }
    return NO;
}

+ (BOOL)_openWithPushStyle:(UIViewController *)vc
                   options:(JKRouterOptions *)options
                  complete:(void(^)(id result,NSError *error))completeBlock
{
    if (options.createStyle==RouterCreateStyleNew) {
        UIViewController *currentVC = [JKRouter sharedRouter].topVC;
        if ([currentVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *naVC = (UINavigationController *)currentVC;
            [naVC pushViewController:vc animated:options.animated];
            if (completeBlock) {
                completeBlock(nil,nil);
            }
            return YES;
        } else if (currentVC.navigationController) {
          UINavigationController *naVC = (UINavigationController *)currentVC.navigationController;
            [naVC pushViewController:vc animated:options.animated];
            if (completeBlock) {
                completeBlock(nil,nil);
            }
            return YES;
        }
        if (completeBlock) {
            NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorUnSupportPushTransform userInfo:@{@"msg":@"do not support push tranform"}];
            completeBlock(nil,error);
        }
        return NO;
        
    }else if (options.createStyle==RouterCreateStyleReplace) {
      BOOL status = [self replaceCurrentViewControllerWithTargetVC:vc];
        if (completeBlock) {
            if (!status) {
                 NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorUnSupportReplaceTransform userInfo:@{@"msg":@"do not support replace tranform"}];
                completeBlock(nil,error);
            }else{
              completeBlock(nil,nil);
            }
        }
        return status;
    }else if (options.createStyle==RouterCreateStyleRefresh) {
        UIViewController *currentVC = [JKRouter sharedRouter].topVC;
        if ([currentVC isEqual:vc]) {
            [currentVC jkRouterRefresh];
            if (completeBlock) {
                completeBlock(nil,nil);
            }
            return YES;
        }else{
            options.transformStyle = RouterTransformVCStyleDefault;
            return [self _transformVC:vc options:options complete:completeBlock];
        }
    }
    if (completeBlock) {
        NSError *error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorUnSupportTransform userInfo:@{@"msg":@"do not support this create style"}];
        completeBlock(nil,error);
    }
    return NO;
}

+ (BOOL)_openWithPresentStyle:(UIViewController *)vc
                      options:(JKRouterOptions *)options
                     complete:(void(^)(id result,NSError *error))completeBlock
{
    if (options.createStyle == RouterCreateStyleNewWithNaVC) {
        UINavigationController *naVC = [JKRouterExtension jkNaVCInitWithRootVC:vc];
        naVC.isPresented = YES;
        [[JKRouter sharedRouter].topVC presentViewController:naVC animated:options.animated completion:nil];
        if (completeBlock) {
            completeBlock(nil,nil);
        }
        return YES;
    }else{
      [[JKRouter sharedRouter].topVC presentViewController:vc animated:options.animated completion:nil];
        if (completeBlock) {
            completeBlock(nil,nil);
        }
        return YES;
    }
    return NO;
}

+ (BOOL)_openWithOtherStyle:(UIViewController *)vc
                    options:(JKRouterOptions *)options
                   complete:(void(^)(id result,NSError *error))completeBlock
{
    BOOL success = [vc jkRouterSpecialTransformWithTopVC:[JKRouter sharedRouter].topVC];
    if (completeBlock) {
        NSError *error = nil;
        if (!success) {
            error = [[NSError alloc] initWithDomain:JKRouterErrorDomain code:JKRouterErrorUnSupportTransform userInfo:@{@"msg":@"no specified transform animation"}];
        }
        completeBlock(nil,error);
    }
    return success;
}

//找到topVC
- (UIViewController *)_findTopVC:(UIViewController *)vc
{
    UIViewController *tmpVC = vc;
    while ([tmpVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naVC = (UINavigationController *)tmpVC;
        tmpVC = naVC.topViewController;
    }
    while (tmpVC.presentedViewController) {
        tmpVC = tmpVC.presentedViewController;
        tmpVC = [self _findTopVC:tmpVC];
    }
    return tmpVC;
}

//找到topVC前的一个vc
- (UIViewController *)_findLastTopVC:(UIViewController *)vc lastTopVC:(UIViewController *)lastTopVC
{
    UIViewController *tmpVC = vc;
    while ([tmpVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naVC = (UINavigationController *)tmpVC;
        tmpVC = naVC.topViewController;
        if (naVC.viewControllers.count > 1) {
            NSUInteger count = naVC.viewControllers.count;
            lastTopVC = naVC.viewControllers[count -2];
        }
    }
    while (tmpVC.presentedViewController) {
        lastTopVC = tmpVC;
        tmpVC = tmpVC.presentedViewController;
        lastTopVC = [self _findLastTopVC:tmpVC lastTopVC:lastTopVC];
    }
    return lastTopVC;
}

+ (BOOL)_isRouterContainVC:(UIViewController *)vc
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *tmpVC = rootVC;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        UIViewController *tmpVC = tabBarVC.selectedViewController;
        return [self _isEqualFromVC:tmpVC targetVC:vc];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return [self _isEqualFromVC:tmpVC targetVC:vc];
    }
    return [self _isEqualFromVC:tmpVC targetVC:vc];
}

+ (UIViewController *)_findVCWithModuleID:(NSString *)moduleID
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *tmpVC = rootVC;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        UIViewController *tmpVC = tabBarVC.selectedViewController;
        return [self _getTargetVCFromVC:tmpVC moduleID:moduleID];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UIViewController *tmpVC = rootVC;
        return [self _getTargetVCFromVC:tmpVC moduleID:moduleID];
    }
    return [self _getTargetVCFromVC:tmpVC moduleID:moduleID];
}

+ (UIViewController *)_findVCWithPopStep:(NSUInteger)popStep
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *tmpVC = rootVC;
    NSUInteger totalSteps = [JKRouter sharedRouter].totalSteps;
    NSUInteger step = totalSteps - popStep;
    if (step >= 0) {
        NSUInteger originStep = 0;
        if ([rootVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarVC = (UITabBarController *)rootVC;
            UIViewController *tmpVC = tabBarVC.selectedViewController;
            return [self _getTargetVCFromVC:tmpVC originStep:originStep step:step];
        } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
            UIViewController *tmpVC = rootVC;
            return [self _getTargetVCFromVC:tmpVC originStep:originStep step:step];
        }
        return [self _getTargetVCFromVC:tmpVC originStep:originStep step:step];
    }else {
        return tmpVC;
    }
    
}

//通过递归比较router里面是否存在和targetVC相同的vc，从tmpVC开始递归
+ (BOOL)_isEqualFromVC:(UIViewController *)tmpVC targetVC:(UIViewController *)targetVC
{
    if ([tmpVC isEqual:targetVC]) {
        return YES;
    }
    while ([tmpVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naVC = (UINavigationController *)tmpVC;
        if ([naVC.viewControllers containsObject:targetVC]) {
            return YES;
        }
        tmpVC = naVC.topViewController;
    }
    while (tmpVC.presentedViewController) {
        tmpVC = tmpVC.presentedViewController;
        if ([tmpVC isEqual:targetVC]) {
            return YES;
        }
        return [self _isEqualFromVC:tmpVC targetVC:targetVC];
    }
    return NO;
}

//通过递归从tmpVC开始根据moduleID找到对应的vc
+ (UIViewController *)_getTargetVCFromVC:(UIViewController *)tmpVC moduleID:(NSString *)moduleID
{
    if (tmpVC.moduleID && [tmpVC.moduleID isKindOfClass:[NSString class]] && tmpVC.moduleID.length >0 && [tmpVC.moduleID isEqualToString:moduleID]) {
        return tmpVC;
    }
    while ([tmpVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naVC = (UINavigationController *)tmpVC;
        tmpVC = naVC.topViewController;
        if (tmpVC.moduleID && [tmpVC.moduleID isKindOfClass:[NSString class]] && tmpVC.moduleID.length >0 && [tmpVC.moduleID isEqualToString:moduleID]) {
            return tmpVC;
        }
    }
    while (tmpVC.presentedViewController) {
        tmpVC = tmpVC.presentedViewController;
        if (tmpVC.moduleID && [tmpVC.moduleID isKindOfClass:[NSString class]] && tmpVC.moduleID.length >0 && [tmpVC.moduleID isEqualToString:moduleID]) {
            return tmpVC;
        }
        return [self _getTargetVCFromVC:tmpVC moduleID:moduleID];
    }
    return nil;
}

+ (UIViewController *)_getTargetVCFromVC:(UIViewController *)tmpVC originStep:(NSUInteger)originStep step:(NSUInteger)step
{
    while ([tmpVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naVC = (UINavigationController *)tmpVC;
        tmpVC = naVC.topViewController;
        NSUInteger count = naVC.viewControllers.count;
        if (originStep + count > step) {
            NSInteger index = step - originStep;
            index = index >0 ?:0;
            UIViewController *targetVC = naVC.viewControllers[index];
            return targetVC;
        }
        originStep +=count;
    }
    while (tmpVC.presentedViewController) {
        tmpVC = tmpVC.presentedViewController;
        originStep++;
        return [self _getTargetVCFromVC:tmpVC originStep:originStep step:step];
    }
    return nil;
}

//获取从tmpVC到当前vc正常open操作需要的次数
- (NSUInteger)_getTotalStepFromVC:(UIViewController *)tmpVC originSteps:(NSUInteger)originSteps
{
    NSUInteger totalSteps = originSteps;
    while ([tmpVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naVC = (UINavigationController *)tmpVC;
        tmpVC = naVC.topViewController;
        totalSteps = naVC.viewControllers.count > 1 ? (naVC.viewControllers.count - 1) : 1;
    }
    while (tmpVC.presentedViewController) {
        tmpVC = tmpVC.presentedViewController;
        totalSteps++;
        [self _getTotalStepFromVC:tmpVC originSteps:totalSteps];
    }
    return totalSteps;
}

@end
