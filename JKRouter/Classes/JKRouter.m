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

@property (nonatomic, strong, readwrite) NSMutableSet * modules; ///< 存储路由，moduleID信息，权限配置信息
@property (nonatomic,copy) NSArray<NSString *> *routerFileNames; ///< 路由配置信息的json文件名数组

@property (nonatomic,strong) NSSet *urlSchemes; ///< 支持的URL协议集合

@property (nonatomic,copy) NSString *remoteFilePath;///< 从网络上下载的路由配置信息的json文件保存在沙盒中的路径
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableArray *moduleNames;///< 已经导入静态路由文件的组件名数组

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
        defaultRouter.moduleNames = [NSMutableArray new];
    });
    return defaultRouter;
}

- (UINavigationController *)topNaVC
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (self.windowRootVCStyle ==RouterWindowRootVCStyleCustom) {
        UITabBarController *tabBarVC = (UITabBarController *)rootVC;
        UIViewController *vc = tabBarVC.selectedViewController;
        if (![vc isKindOfClass:[UINavigationController class]]) {
            NSAssert(NO, @"tabBarViewController's selectedViewController is not a UINavigationController instance");
        }
        if (vc.presentedViewController && [vc.presentedViewController isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)vc.presentedViewController;
        }
        return (UINavigationController *)vc;
    }
    if (![rootVC isKindOfClass:[UINavigationController class]]) {
        NSAssert(NO, @"rootVC is not a UINavigationController instance");
    }
    if (rootVC.presentedViewController && [rootVC.presentedViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC.presentedViewController;
    }
    return (UINavigationController *)rootVC;
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
    if (!JKSafeStr(targetClassName)) {
        NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorClassNameIsNil userInfo:@{@"msg":@"targetClassName is nil or targetClassName is not a string"}];
        if (completeBlock) {
            completeBlock(nil,error);
        }
        return NO;
    }
    if (!options) {
        options = [JKRouterOptions options];
    }
    
    Class targetClass = nil;
    if (!JKIsEmptyStr(options.module)) {
        targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",options.module,targetClassName]);
    }else{
        targetClass = NSClassFromString(targetClassName);
        if (!targetClass) {
        targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",[JKRouterExtension appTargetName],targetClassName]);
        }
    }
    if (!targetClass) {
        if (completeBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorClassNil userInfo:@{@"msg":@"targetClass is nil"}];
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
    if ([targetClass respondsToSelector:@selector(jkRouterFactoryViewControllerWithJSON:)]) {
        UIViewController *vc = [targetClass jkRouterFactoryViewControllerWithJSON:options.defaultParams];
        return [JKRouter routerViewController:vc options:options complete:completeBlock];
    }else if ([targetClass jkIsTabBarItemVC]) {
        return [JKRouterExtension jkSwitchTabClass:targetClass options:options complete:completeBlock];
    }else{
        UIViewController *vc = [targetClass jkRouterViewControllerWithJSON:options.defaultParams];
        //根据配置好的VC，options配置进行跳转
        return [self routerViewController:vc options:options complete:completeBlock];
    }
}

+ (BOOL)openSpecifiedVC:(UIViewController *)vc
                options:(JKRouterOptions *)options
{
    if (!options) {
        options = [JKRouterOptions options];
    }
    return [self routerViewController:vc options:options complete:nil];
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
            NSError * error = [NSError errorWithDomain:@"JKRouter" code:JKRouterErrorURLIsNil userInfo:@{@"message":@"url不存在"}];
            completeBlock(nil,error);
        }
        return NO;
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *targetURL = [NSURL URLWithString:url];
    NSString *scheme =targetURL.scheme;
    if (![[JKRouter sharedRouter].urlSchemes containsObject:scheme]) {
        if(completeBlock){
            NSError * error = [NSError errorWithDomain:@"JKRouter" code:JKRouterErrorSystemUnSupportURLScheme userInfo:@{@"message":@"app不支持该协议的跳转"}];
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
    if ([scheme isEqualToString:@"itms-apps"] || [scheme isEqualToString:@"app-settings"]) {
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
        if (!JKIsEmptyStr(options.module)) {
            targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",options.module,targetClassName]);
        }else{
            targetClass = NSClassFromString(targetClassName);
            if (!targetClass) {
            targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",[JKRouterExtension appTargetName],targetClassName]);
           }
        }
        if (!targetClass) {
            if (completeBlock) {
                NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorClassNil userInfo:@{@"msg":@"targetClass is nil"}];
                completeBlock(nil,error);
            }
            return NO;
        }
        if ([targetClass isSubclassOfClass:[UIViewController class]]) {
            NSString *parameterStr = [[targetURL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *dic = nil;
            if (JKSafeStr(parameterStr)) {
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
        if (!JKIsEmptyStr(options.module)) {
            targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",options.module,factoryClassName]);
        }else{
            targetClass = NSClassFromString(factoryClassName);
            if (!targetClass) {
                targetClass = NSClassFromString([NSString stringWithFormat:@"%@.%@",[JKRouterExtension appTargetName],factoryClassName]);
            }
        }
        if (!targetClass) {
            if (completeBlock) {
                NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorClassNil userInfo:@{@"msg":@"targetClass is nil"}];
                completeBlock(nil,error);
            }
            return NO;
        }
        
        NSString *parameterStr = [[targetURL query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *dic = nil;
        if (JKSafeStr(parameterStr)) {
            dic = [JKRouterTool convertUrlStringToDictionary:parameterStr];
            [dic addEntriesFromDictionary:extra];
        }else{
            dic = [NSMutableDictionary dictionaryWithDictionary:extra];
        }
        options.defaultParams = [dic copy];
        if ([targetClass respondsToSelector:@selector(jkRouterFactoryViewControllerWithJSON:)]) {
            UIViewController *vc =   [targetClass jkRouterFactoryViewControllerWithJSON:options.defaultParams];
           return [JKRouter routerViewController:vc options:options complete:completeBlock];
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
            NSError * error = [NSError errorWithDomain:@"JKRouter" code:JKRouterErrorBlackNameURL userInfo:@{@"message":@"黑名单链接"}];
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
    if (JKSafeStr(parameterStr)) {
        NSMutableDictionary *dic = [JKRouterTool convertUrlStringToDictionary:parameterStr];
        if (JKSafeDic(dic) &&[[dic objectForKey:[JKRouterExtension jkBrowserOpenKey]] isEqualToString:@"1"]) {//在safari打开网页
            [self openExternal:[JKRouterTool url:url removeQueryKeys:@[[JKRouterExtension jkBrowserOpenKey]]]];
        }else{
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

    if (!JKSafeStr(url)) {
        NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorSandBoxPathIsNil userInfo:@{@"msg":@"沙盒路径不存在"}];
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
    if ([targetURL.scheme isEqualToString:@"http"] ||[targetURL.scheme isEqualToString:@"https"] || [targetURL.scheme isEqualToString:@"itms-apps"]) {
        if (@available(ios 10.0,*)) {
            [[UIApplication sharedApplication] openURL:targetURL options:@{} completionHandler:^(BOOL success) {
                if (completeBlock) {
                    NSError *error = nil;
                    if (!success) {
                        error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorSystemUnSupportURL userInfo:@{@"msg":@"系统不能打开这个url"}];
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
                    NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorSystemUnSupportURL userInfo:@{@"msg":@"系统不能打开这个url"}];
                    completeBlock(nil,error);
                }
                return NO;
            }
        }
    }else{
        
        if (completeBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorSystemUnSupportURLScheme userInfo:@{@"msg":@"不支持该URL协议"}];
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
    [self pop:nil :animated];
}

+ (void)pop:(NSDictionary *)params
           :(BOOL)animated
{
    [self pop:params :animated complete:nil];
}

+ (void)pop:(NSDictionary *)params
           :(BOOL)animated
   complete:(void(^)(id result,NSError *error))completeBlock
{
    NSArray *vcArray = [JKRouter sharedRouter].topNaVC.viewControllers;
    NSUInteger count = vcArray.count;
    UIViewController *vc= nil;
    JKRouterOptions *options = nil;
    if (params) {
        options = [JKRouterOptions optionsWithDefaultParams:params];
    }
    if (vcArray.count>1) {
        vc = vcArray[count-2];
    }else{
        //已经是根视图，不再执行pop操作  可以执行dismiss操作
        if ([JKRouter sharedRouter].topNaVC.isPresented) {
            [[JKRouter sharedRouter].topNaVC dismissViewControllerAnimated:animated completion:^{
                UIViewController *newVC= [JKRouter sharedRouter].topNaVC.topViewController;
                [JKRouterTool configTheVC:newVC options:options];
                [newVC viewWillAppear:animated];
                if (completeBlock) {
                    completeBlock(nil,nil);
                }
            }];
        }else{
            if (!options) {
                options = [JKRouterOptions options];
            }
            options.animated = animated;
            [self popToSpecifiedVC:nil options:options complete:completeBlock];
        }
        
        return;
    }
    if (!options) {
        options = [JKRouterOptions options];
    }
    options.animated = animated;
    [self popToSpecifiedVC:vc options:options complete:completeBlock];
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
    options.animated = animated;
    [self popToSpecifiedVC:vc options:options complete:nil];
}

+ (void)popToSpecifiedVC:(UIViewController *)vc
                 options:(JKRouterOptions *)options
                complete:(void(^)(id result,NSError *error))completeBlock
{
    if (!vc) {
        if ([JKRouter sharedRouter].topNaVC.presentationController &&[JKRouter sharedRouter].topNaVC.presentedViewController) {
            [[JKRouter sharedRouter].topNaVC dismissViewControllerAnimated:options.animated completion:^{
                [JKRouterTool configTheVC:[JKRouter sharedRouter].topNaVC.topViewController options:options];
                if (completeBlock) {
                    completeBlock(nil,nil);
                }
            }];
        }
        return;
    }
    else {
        if (vc) {
            [JKRouterTool configTheVC:vc options:options];
            [[JKRouter sharedRouter].topNaVC popToViewController:vc animated:options.animated];
            if (completeBlock) {
                completeBlock(nil,nil);
            }
        }
    }
}

+ (void)popWithSpecifiedModuleID:(NSString *)moduleID{
    [self popWithSpecifiedModuleID:moduleID :nil :YES];
}

+ (void)popWithSpecifiedModuleID:(NSString *)moduleID
                                :(NSDictionary *)params
                                :(BOOL)animated
{
    NSArray *vcArray  = [JKRouter sharedRouter].topNaVC.viewControllers;
        for (NSInteger i = vcArray.count-1; i>0; i--) {
            UIViewController *vc = vcArray[i];
            if ([vc.moduleID isEqualToString:moduleID]) {
                JKRouterOptions *options = [JKRouterOptions optionsWithDefaultParams:params];
                [JKRouterTool configTheVC:vc options:options];
                [self popToSpecifiedVC:vc animated:animated];
            }
        }
}

+ (void)popWithStep:(NSInteger)step
{
    [self popWithStep:step :YES];
}

+ (void)popWithStep:(NSInteger)step :(BOOL)animated
{
    [self popWithStep:step params:nil animated:animated];
}

+ (void)popWithStep:(NSInteger)step
             params:(NSDictionary *)params
           animated:(BOOL)animated
{
    NSArray *vcArray = [JKRouter sharedRouter].topNaVC.viewControllers;
    UIViewController *vc= nil;
    if (step>0) {
        if([JKRouter sharedRouter].topNaVC.viewControllers.count>step){
            NSUInteger count = vcArray.count;
            vc = vcArray[(count-1) - step];
            JKRouterOptions *options = [JKRouterOptions optionsWithDefaultParams:params];
            [JKRouterTool configTheVC:vc options:options];
            [self popToSpecifiedVC:vc animated:animated];
        }else if([JKRouter sharedRouter].topNaVC.viewControllers.count == step){
            UIViewController *vc= nil;
            vc = vcArray[0];
            JKRouterOptions *options = [JKRouterOptions optionsWithDefaultParams:params];
            [JKRouterTool configTheVC:vc options:options];
            [self popToSpecifiedVC:vc animated:animated];
        }else{
            JKRouterLog(@"step不在正常范围 执行popToRootViewController操作");
            //已经是根视图，不再执行pop操作  可以执行dismiss操作
            vc = vcArray[0];
            [self popToSpecifiedVC:vc animated:animated];
        }
    }
}


#pragma mark  - - - - the tool functions - - - -

+ (void)replaceCurrentViewControllerWithTargetVC:(UIViewController *)targetVC
{
    if ([[NSThread currentThread] isMainThread]) {
        NSArray *viewControllers = [JKRouter sharedRouter].topNaVC.viewControllers;
        NSMutableArray *vcArray = [NSMutableArray arrayWithArray:viewControllers];
        [vcArray replaceObjectAtIndex:viewControllers.count-1 withObject:targetVC];
        [[JKRouter sharedRouter].topNaVC setViewControllers:[vcArray copy] animated:YES];
        [[JKRouter sharedRouter].topNaVC setViewControllers:[vcArray copy] animated:YES];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *viewControllers = [JKRouter sharedRouter].topNaVC.viewControllers;
            NSMutableArray *vcArray = [NSMutableArray arrayWithArray:viewControllers];
            [vcArray replaceObjectAtIndex:viewControllers.count-1 withObject:targetVC];
            [[JKRouter sharedRouter].topNaVC setViewControllers:[vcArray copy] animated:YES];
            [[JKRouter sharedRouter].topNaVC setViewControllers:[vcArray copy] animated:YES];
        })
    }
}


//根据相关的options配置，进行跳转
+ (BOOL)routerViewController:(UIViewController *)vc
                     options:(JKRouterOptions *)options
                    complete:(void(^)(id result,NSError *error))completeBlock
{
    if (![[vc class]  validateTheAccessToOpenWithOptions:options]) {//权限不够进行别的操作处理
        //根据具体的权限设置决定是否进行跳转，如果没有权限，跳转中断，进行后续处理
        [[vc class] handleNoAccessToOpenWithOptions:options];
        if (completeBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorNORightToAccess userInfo:@{@"msg":@"没有权限打开该页面"}];
            completeBlock(nil,error);
        }
        return NO;
    }
    if ([JKRouter sharedRouter].topNaVC.presentationController &&[JKRouter sharedRouter].topNaVC.presentedViewController && ![[JKRouter sharedRouter].topNaVC.presentedViewController isKindOfClass:[UINavigationController class]]) {
        [[JKRouter sharedRouter].topNaVC dismissViewControllerAnimated:NO completion:nil];
    }
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
        NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorUnSupportTransform userInfo:@{@"msg":@"不支持的跳转方式"}];
        completeBlock(nil,error);
    }
    return NO;
}

+ (BOOL)_openWithPushStyle:(UIViewController *)vc
                   options:(JKRouterOptions *)options
                  complete:(void(^)(id result,NSError *error))completeBlock
{
    if (options.createStyle==RouterCreateStyleNew) {
        [[JKRouter sharedRouter].topNaVC pushViewController:vc animated:options.animated];
        if (completeBlock) {
            completeBlock(nil,nil);
        }
        return YES;
    }else if (options.createStyle==RouterCreateStyleReplace) {
        [self replaceCurrentViewControllerWithTargetVC:vc];
        if (completeBlock) {
            completeBlock(nil,nil);
        }
        return YES;
    }else if (options.createStyle==RouterCreateStyleRefresh) {
        UIViewController *currentVC = [JKRouter sharedRouter].topNaVC.topViewController;
        if ([[currentVC class] isKindOfClass:[vc class]]) {//需要优化
            [currentVC jkRouterRefresh];
            if (completeBlock) {
                completeBlock(nil,nil);
            }
            return YES;
        }else{
             [[JKRouter sharedRouter].topNaVC pushViewController:vc animated:options.animated];
            if (completeBlock) {
                completeBlock(nil,nil);
            }
            return YES;
        }
    }
    if (completeBlock) {
        NSError *error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorUnSupportTransform userInfo:@{@"msg":@"不支持的跳转方式"}];
        completeBlock(nil,error);
    }
    return NO;
}

+ (BOOL)_openWithPresentStyle:(UIViewController *)vc
                      options:(JKRouterOptions *)options
                     complete:(void(^)(id result,NSError *error))completeBlock
{
    if (options.createStyle == RouterCreateStyleNewWithNaVC) {
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
        naVC.isPresented = YES;
        [[JKRouter sharedRouter].topNaVC presentViewController:naVC animated:options.animated completion:nil];
        if (completeBlock) {
            completeBlock(nil,nil);
        }
        return YES;
    }else{
      [[JKRouter sharedRouter].topNaVC presentViewController:vc animated:options.animated completion:nil];
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
    BOOL success = [vc jkRouterSpecialTransformWithNaVC:[JKRouter sharedRouter].topNaVC];
    if (completeBlock) {
        NSError *error = nil;
        if (!success) {
            error = [[NSError alloc] initWithDomain:@"JKRouter" code:JKRouterErrorUnSupportTransform userInfo:@{@"msg":@"没有支持自定义专场动画"}];
        }
        completeBlock(nil,error);
    }
    return success;
}

@end
