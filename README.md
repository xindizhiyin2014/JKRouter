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


