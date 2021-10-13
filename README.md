# JKRouter

[![CI Status](http://img.shields.io/travis/HHL110120/JKRouter.svg?style=flat)](https://travis-ci.org/HHL110120/JKRouter)
[![Version](https://img.shields.io/cocoapods/v/JKRouter.svg?style=flat)](http://cocoapods.org/pods/JKRouter)
[![License](https://img.shields.io/cocoapods/l/JKRouter.svg?style=flat)](http://cocoapods.org/pods/JKRouter)
[![Platform](https://img.shields.io/cocoapods/p/JKRouter.svg?style=flat)](http://cocoapods.org/pods/JKRouter)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JKRouter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JKRouter"
```

## Author

HHL110120, 929097264@qq.com

## QQ Contact group
if you use QQ you can use this Qrcode to contact with us
![](https://github.com/xindizhiyin2014/JKRouter/blob/master/JKRouter.png?raw=true)

## License

JKRouter is available under the MIT license. See the LICENSE file for more info.

# guide
you can use the pod with the steps
## config JKRouter
```
 [JKRouter configWithRouterFiles:@[@"modules.json",@"modules123.json"]];

```
## configRootViewController
### do not use TabBarViewController

```
JKViewController *vc = [JKViewController new];
self.window.rootViewController = vc;
```
### if you use TabBarViewController
#### step1
```
self.rootTabBarController = [[RootTabbarViewController alloc] init];

UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController: self.rootTabBarController];
self.window.rootViewController = naVC;

```
#### step2  override the viewWillAppear of tabBarViewController
```
- (void)viewWillAppear:(BOOL)animated{
[super viewWillAppear:animated];
[self.navigationController setNavigationBarHidden:YES animated:animated];

}
```

## use viewController className to open the specified ViewController
```
 [JKRouter open:@"JKAViewController"];
```
## use the scheme defined by yourself such as "jkpp"
### step1
in JKRouterExtension+Jack.m  file
```
+ (NSArray *)urlSchemes{

return @[@"http",@"https",@"jkpp"];
}
```
### step2
```
 [JKRouter URLOpen:@"jkpp://jackApp:10001"];
 [JKRouter URLOpen:@"jkpp://jackApp:10002?testContent=Hi, I'm Jack"];
 [JKRouter URLOpen:@"jkpp://jackApp:10004/abc/mn/qq"];
````
## use special transform animation
### step1
in the target ViewController
```
- (RouterTransformVCStyle)jkRouterTransformStyle{
return RouterTransformVCStyleOther;
}
```
### step2
config the animation in  the function
```
- (void)jkRouterSpecialTransformWithNaVC:(UINavigationController *)naVC{
UIViewController *vc = naVC.topViewController;
vc.navigationController.delegate = self;

[naVC pushViewController:self animated:YES];
}

```
## use access judge
if your app pages have access judgement  please follow the next step in the target viewController
```
+ (BOOL)validateTheAccessToOpen{
//with the judment code
return YES;
}

+ (void)handleNoAccessToOpen{

//do the action if has no access
}
```

## 实现历程博客
[《iOS路由跳转（一）之初识URL》](https://blog.csdn.net/hanhailong18/article/details/60570071?spm=1001.2014.3001.5501)

[《iOS路由跳转（二）之需求分析》](https://blog.csdn.net/hanhailong18/article/details/61925286?spm=1001.2014.3001.5501)

[《iOS路由跳转（三）之JKRouter基础教程1》](https://blog.csdn.net/hanhailong18/article/details/64124008?spm=1001.2014.3001.5501)

[《iOS路由跳转（三）之JKRouter基础教程2》](https://blog.csdn.net/hanhailong18/article/details/64440324?spm=1001.2014.3001.5501)

[《iOS路由跳转（四）之JKRouter持续更新1》](https://blog.csdn.net/hanhailong18/article/details/71756758?spm=1001.2014.3001.5501)

[《iOS路由跳转（五）之JKRouter 2.0 脱胎换骨》](https://blog.csdn.net/hanhailong18/article/details/78828457?spm=1001.2014.3001.5501)

[《JKRouter路由跳转解决了哪些问题》](https://blog.csdn.net/hanhailong18/article/details/79511261?spm=1001.2014.3001.5501)

[《JKRouter路由跳转中文使用手册》](https://blog.csdn.net/hanhailong18/article/details/79513720?spm=1001.2014.3001.5501)

[《JKRouter更新之present带导航栏的控制器》](https://blog.csdn.net/hanhailong18/article/details/80680800?spm=1001.2014.3001.5501)

[《JKRouter完美实现微信小程序的跳转》](https://blog.csdn.net/hanhailong18/article/details/83543123?spm=1001.2014.3001.5501)

[《JKRouter实现通过url切换web容器》](https://blog.csdn.net/hanhailong18/article/details/84141939?spm=1001.2014.3001.5501)

[《JKRouter路由跳转 实现对工厂方法的支持》](https://blog.csdn.net/hanhailong18/article/details/85231553?spm=1001.2014.3001.5501)

[《JKRouter路由跳转 实现对工厂方法的支持》](https://blog.csdn.net/hanhailong18/article/details/85231553?spm=1001.2014.3001.5501)

[《JKRouter路由跳转实现对swift的支持》](https://blog.csdn.net/hanhailong18/article/details/85242221?spm=1001.2014.3001.5501)

[《JKRouter增加黑白名单制度啦》](https://blog.csdn.net/hanhailong18/article/details/94376170?spm=1001.2014.3001.5501)


