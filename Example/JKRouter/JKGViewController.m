//
//  JKGViewController.m
//  JKRouter_Example
//
//  Created by JackLee on 2018/1/6.
//  Copyright © 2018年 HHL110120. All rights reserved.
//

#import "JKGViewController.h"
#import "YYModel.h"

@implementation Person

@end

@interface JKGViewController ()

@end

@implementation JKGViewController

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"friends" : [Person class]};
}
+ (instancetype)jkRouterViewControllerWithJSON:(NSDictionary *)dic{
    JKGViewController *gVC = [JKGViewController yy_modelWithJSON:dic];
    
    return gVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *string = [NSString stringWithFormat:@"jack %@ %@ friends  %@",self.jack.name,self.jack.sex,self.friends[0].name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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
