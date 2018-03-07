//
//  JKDViewController.m
//  JKRouter
//
//  Created by Jack on 17/3/19.
//  Copyright © 2017年 HHL110120. All rights reserved.
//

#import "JKDViewController.h"

@interface JKDViewController ()

@end

@implementation JKDViewController

+ (instancetype)jkRouterViewControllerWithJSON:(NSDictionary *)dic{
    JKDViewController *vc = [self yy_modelWithJSON:dic];
    return vc;
}

+ (BOOL)validateTheAccessToOpen{
    return NO;
}

+ (void)handleNoAccessToOpen{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有权限" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title =@"跳转＋权限校验";
    UIButton *button =  [UIButton new];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 120, 30);
    button.center = self.view.center;
    [button setTitle:@"clickToBack" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

- (void)clickToBack{
    
    [JKRouter pop];
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
