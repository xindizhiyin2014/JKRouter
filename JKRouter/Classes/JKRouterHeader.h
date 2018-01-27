//
//  JKRouterHeader.h
//  JKRouter
//
//  Created by JackLee on 2017/12/11.
//

#ifndef JKRouterHeader_h
#define JKRouterHeader_h

typedef NS_ENUM(NSInteger,RouterTransformVCStyle){
    RouterTransformVCStyleDefault =-1, ///< 不指定转场方式，使用自带的转场方式
    RouterTransformVCStylePush,        ///< push方式转场
    RouterTransformVCStylePresent,     ///< present方式转场
    RouterTransformVCStyleOther        ///< 用户自定义方式转场
};///< ViewController的转场方式

typedef NS_ENUM(NSInteger,RouterCreateStyle) {
    RouterCreateStyleNew,               ///< 默认创建方式，创建一个新的ViewController对象
    RouterCreateStyleReplace,           ///< 创建一个新的ViewController对象，然后替换navigationController当前的viewController
    RouterCreateStyleRefresh           ///<  当前的viewController就是目标viewController就不创建，而是执行相关的刷新操作。如果当前的viewController不是目标viewController就执行创建操作
};///< ViewController的创建方式
#import<JKRouter/UIViewController+JKRouter.h>
#import<JKRouter/JKRouter.h>
#import<JKRouter/JKJSONHandler.h>
#import<JKRouter/JKRouterExtension.h>


#endif /* JKRouterHeader_h */
