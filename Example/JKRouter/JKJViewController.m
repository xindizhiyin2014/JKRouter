//
//  JKJViewController.m
//  JKRouter_Example
//
//  Created by JackLee on 2018/3/9.
//  Copyright © 2018年 HHL110120. All rights reserved.
//

#import "JKJViewController.h"

@interface JKJViewController ()

@end

@implementation JKJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 120, 30);
    [button setTitle:@"点击跳转" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.title = @"test popWithStep";
    
}

- (void)buttonClicked{
    
    [JKRouter open:@"JKKViewController"];
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
