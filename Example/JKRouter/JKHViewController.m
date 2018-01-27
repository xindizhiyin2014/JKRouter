//
//  JKHViewController.m
//  JKRouter_Example
//
//  Created by JackLee on 2018/1/27.
//  Copyright © 2018年 HHL110120. All rights reserved.
//

#import "JKHViewController.h"

@interface JKHViewController ()

@end

@implementation JKHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the
self.view.backgroundColor = [UIColor whiteColor];
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
button.frame = CGRectMake(0, 0, 69, 30);
[button setTitle:@"点击" forState:UIControlStateNormal];
[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
button.center = self.view.center;
[button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:button];

}

- (void)buttonClicked{
    RouterOptions *options = [RouterOptions options];
    options.createStyle = RouterCreateStyleReplace;
    [JKRouter open:@"JKIViewController" options:options];
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
