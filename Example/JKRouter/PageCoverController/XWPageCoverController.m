//
//  XWPageCoverController.m
//  XWTrasitionPractice
//
//  Created by YouLoft_MacMini on 15/11/24.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import "XWPageCoverController.h"
#import "XWPageCoverPushController.h"
#import "XWInteractiveTransition.h"
#import "XWPageCoverTransition.h"
#import "Masonry.h"

@interface XWPageCoverController ()<XWPageCoverPushControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) XWInteractiveTransition *interactiveTransitionPush;

@property (nonatomic, assign) id<XWPageCoverPushControllerDelegate> delegate;

@end

@implementation XWPageCoverController

- (RouterTransformVCStyle)jkRouterTransformStyle{
    return RouterTransformVCStyleOther;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"翻页效果";
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic2.jpeg"]];
    [self.view addSubview:imageView];
    imageView.frame = self.view.frame;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或向左滑动push" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(74);
    }];
    _interactiveTransitionPush = [XWInteractiveTransition interactiveTransitionWithTransitionType:XWInteractiveTransitionTypePush GestureDirection:XWInteractiveTransitionGestureDirectionLeft];
    typeof(self)weakSelf = self;
    _interactiveTransitionPush.pushConifg = ^(){
        [weakSelf push];
    };
    //此处传入self.navigationController， 不传入self，因为self.view要形变，否则手势百分比算不准确；
    [_interactiveTransitionPush addPanGestureForViewController:self];
}

- (void)push{
    XWPageCoverPushController *pushVC = [XWPageCoverPushController new];
    self.navigationController.delegate = pushVC;
    pushVC.delegate = self;
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPush{
    return _interactiveTransitionPush;
}

- (void)jkRouterSpecialTransformWithNaVC:(UINavigationController *)naVC{
    UIViewController *vc = naVC.topViewController;
    vc.navigationController.delegate = self;
    
    [naVC pushViewController:self animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
        //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    return [XWPageCoverTransition transitionWithType:operation == UINavigationControllerOperationPush ? XWPageCoverTransitionTypePush : XWPageCoverTransitionTypePop];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    XWInteractiveTransition *interactiveTransitionPush = _interactiveTransitionPush;
        return interactiveTransitionPush.interation ? interactiveTransitionPush : nil;
   
}

@end
