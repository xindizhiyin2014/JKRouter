//
//  JKRouterHeader.h
//  JKRouter
//
//  Created by JackLee on 2017/12/11.
//

#ifndef JKRouterHeader_h
#define JKRouterHeader_h

typedef NS_ENUM(NSInteger,RouterTransformVCStyle){///< ViewController的转场方式
    RouterTransformVCStyleDefault =-1, ///< 不指定转场方式，使用自带的转场方式
    RouterTransformVCStylePush,        ///< push方式转场
    RouterTransformVCStylePresent,     ///< present方式转场
    RouterTransformVCStyleOther        ///< 用户自定义方式转场
};

#import<JKRouter/UIViewController+JKRouter.h>
#import<JKRouter/JKRouter.h>
#import<JKRouter/JKJSONHandler.h>
#import<JKRouter/JKRouterExtension.h>


#endif /* JKRouterHeader_h */
