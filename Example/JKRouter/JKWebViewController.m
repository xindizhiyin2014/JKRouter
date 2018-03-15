//
//  JKWebViewController.m
//  JKRouter
//
//  Created by Jack on 17/5/12.
//  Copyright © 2017年 HHL110120. All rights reserved.
//

#import "JKWebViewController.h"
@interface JKWebViewController ()

@end

@implementation JKWebViewController

+ (instancetype)jkRouterViewControllerWithJSON:(NSDictionary *)dic{
    JKWebViewController *gVC = [JKWebViewController yy_modelWithJSON:dic];
    
    return gVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"jkurl: %@",_jkurl);
    NSLog(@"title : %@",self.title);

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
