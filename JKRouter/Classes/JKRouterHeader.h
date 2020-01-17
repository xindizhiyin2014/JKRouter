//
//  JKRouterHeader.h
//  JKRouter
//
//  Created by JackLee on 2017/12/11.
//

#ifndef JKRouterHeader_h
#define JKRouterHeader_h

#ifdef DEBUG
#define JKRouterLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define JKRouterLog(...)
#endif

static NSString * const JKRouterErrorDomain = @"JKRouterError";

/// ViewController的转场方式
typedef NS_ENUM(NSInteger,RouterTransformVCStyle){
    /// 不指定转场方式，使用自带的转场方式
    RouterTransformVCStyleDefault = -1,
    /// push方式转场
    RouterTransformVCStylePush,
    /// present方式转场
    RouterTransformVCStylePresent,
    /// 用户自定义方式转场
    RouterTransformVCStyleOther
};

/// ViewController的创建方式
typedef NS_ENUM(NSInteger,RouterCreateStyle) {
    /// 默认创建方式，创建一个新的ViewController对象
    RouterCreateStyleNew,
    /// 创建一个新的ViewController对象，然后替换navigationController当前的viewController
    RouterCreateStyleReplace,
    /// 当前的viewController就是目标viewController就不创建，而是执行相关的刷新操作。如果当前的viewController不是目标viewController就执行创建操作
    RouterCreateStyleRefresh,
    /// 用于present转场时目标present的目标是VC也有导航栏
    RouterCreateStyleNewWithNaVC
    
};

typedef NS_ENUM(NSInteger,JKRouterError) {
  /// className is nil
  JKRouterErrorClassNameIsNil = 10000,
  /// class is nil
  JKRouterErrorClassNil,
  /// url is nil
  JKRouterErrorURLIsNil,
  /// sandboxPath is nil
  JKRouterErrorSandBoxPathIsNil,
  /// system unsupport this url
  JKRouterErrorSystemUnSupportURL,
  /// JKRouter unsupport this scheme
  JKRouterErrorSystemUnSupportURLScheme,
  /// unsupport this action
  JKRouterErrorUnSupportAction,
  /// no right to access
  JKRouterErrorNORightToAccess,
  /// unsupport this transform
  JKRouterErrorUnSupportTransform,
  /// unsupport switch tabbar
  JKRouterErrorUnSupportSwitchTabBar,
  /// url is in blackName list
  JKRouterErrorBlackNameURL,
  /// unsupport push transform
  JKRouterErrorUnSupportPushTransform,
  /// unsupport replace transform
  JKRouterErrorUnSupportReplaceTransform,
  /// unsupport pop action
  JKRouterErrorUnSupportPopAtcion,
  /// unsuport class in JKRouter
  JKRouterErrorUnSupportRouterClass,
  /// the vc is not contained in Router
  JKRouterErrorNoVCInRouter,

};



@protocol JKRouterDelegate <NSObject>

@optional
/**
 通过工厂方法初始化viewController
 
 @param dic 工厂方法需要的参数
 @return 初始化的viewController
 */
+ (UIViewController *)jkRouterFactoryViewControllerWithJSON:(NSDictionary *)dic;

@end

#endif /* JKRouterHeader_h */
