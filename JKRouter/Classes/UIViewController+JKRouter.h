//
//  UIViewController+JKRouter.h
//  
//
//  Created by jack on 17/1/20.
//  Copyright © 2017年 localadmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JKRouter/JKRouterHeader.h>


@interface UIViewController (JKRouter)


//每个VC 所属的moduleID，默认为nil
@property (nonatomic,copy) NSString *moduleID;

+ (instancetype)jkRouterViewController;

/**
 根据权限等级判断是否可以打开，具体通过category重载来实现
 
 @return 是否进行正常的跳转
 */
+ (BOOL)validateTheAccessToOpen;

/**
 处理没有权限去打开的情况
 */
+ (void)handleNoAccessToOpen;

/**
 用户自定义转场动画
 
 @param naVC 根部导航栏
 */
- (void)jkRouterSpecialTransformWithNaVC:(UINavigationController *)naVC;


/**
 自定义的转场方式

 @return 转场方式
 */
- (RouterTransformVCStyle)jkRouterTransformStyle;



@end
