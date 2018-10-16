//
//  UINavigationController+JKRouter.h
//  JKRouter
//
//  Created by JackLee on 2018/10/16.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (JKRouter)
//是否作为一个vc，被别的导航栏presented显示出来
@property (nonatomic,assign) BOOL isPresented;
@end
