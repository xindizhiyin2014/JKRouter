//
//  JKNViewController.m
//  JKRouter_Example
//
//  Created by JackLee on 2018/6/12.
//  Copyright © 2018年 HHL110120. All rights reserved.
//

#import "JKNViewController.h"

@interface JKNViewController ()

@end

@implementation JKNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton new];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton new];
    [button1 setTitle:@"返回" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(200, 500, 100, 30);
    
    [button1 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
}

#pragma mark - - - - UIEvent - - - -
- (void)buttonClicked:(UIButton *)button{
    
    [JKRouter open:@"JKOViewController"];
}

- (void)back{
    [JKRouter pop:@{@"testString":@"我是张三"} :YES];
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
