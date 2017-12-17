//
//  JKFViewController.m
//  JKRouter_Example
//
//  Created by JackLee on 2017/12/17.
//  Copyright © 2017年 HHL110120. All rights reserved.
//

#import "JKFViewController.h"

@interface JKFViewController ()

@end

@implementation JKFViewController

+ (instancetype)jkRouterViewController{
     UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JKFViewController *fVC = [mainStory instantiateViewControllerWithIdentifier:@"JKFViewController"];
    return fVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"使用storyBoard";
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
