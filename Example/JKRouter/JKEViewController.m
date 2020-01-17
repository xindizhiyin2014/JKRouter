//
//  JKEViewController.m
//  JKRouter
//
//  Created by Jack on 17/3/23.
//  Copyright © 2017年 HHL110120. All rights reserved.
//

#import "JKEViewController.h"

@interface JKEViewController ()

@end

@implementation JKEViewController

- (RouterTransformVCStyle)jkRouterTransformStyle{
    return RouterTransformVCStylePresent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =@"present跳转，不携带参数";
    UIButton *button =  [UIButton new];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 120, 30);
    button.center = self.view.center;
    [button setTitle:@"clickToBack" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 =  [UIButton new];
    button1.backgroundColor = [UIColor redColor];
    button1.frame = CGRectMake(0, 0, 120, 30);
    button1.center = CGPointMake(100, 150);
    [button1 setTitle:@"sendLastTopVCMsg" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(sendLastTopVCMsg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}



-(void)clickToBack{
    
    [JKRouter pop];
}

- (void)sendLastTopVCMsg
{
    [JKRouter sendMsgToLastTopVC:@{@"mm":@"hello"} complete:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
