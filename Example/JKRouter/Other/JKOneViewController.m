//
//  JKOneViewController.m
//  JKRouter_Example
//
//  Created by JackLee on 2018/2/6.
//  Copyright © 2018年 HHL110120. All rights reserved.
//

#import "JKOneViewController.h"

@interface JKOneViewController ()

@end

@implementation JKOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"oneVC";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 30);
    [button setTitle:@"点击跳转" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"切换模式" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem =item;
    
}

- (void)buttonClicked:(UIButton *)button{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"RouterWindowRootVCStyle"] integerValue] !=RouterWindowRootVCStyleDefault) {
        [[NSUserDefaults standardUserDefaults] setObject:@(RouterWindowRootVCStyleDefault) forKey:@"RouterWindowRootVCStyle"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@(RouterWindowRootVCStyleCustom) forKey:@"RouterWindowRootVCStyle"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重启切换模式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)buttonClicked{
    [JKRouter open:@"JKAViewController"];
}

+ (BOOL)jkIsTabBarItemVC{
    return YES;
}
+ (NSInteger)jkTabIndex{
    return 0;
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
