//
//  JKMViewController.m
//  JKRouter_Example
//
//  Created by JackLee on 2018/6/12.
//  Copyright © 2018年 HHL110120. All rights reserved.
//

#import "JKMViewController.h"
#import "JKNViewController.h"

@interface JKMViewController ()
@property (nonatomic,copy) NSString *testString;
@end

@implementation JKMViewController

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
    self.testString = @"I'm ！！！!";

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"testString :%@",self.testString);
}

- (void)setTestString:(NSString *)testString{
    _testString =testString;
}

#pragma mark - - - - UIEvent - - - -
- (void)buttonClicked:(UIButton *)button{
    JKRouterOptions *options = [JKRouterOptions optionsWithTransformStyle:RouterTransformVCStylePresent];
    options.createStyle = RouterCreateStyleNewWithNaVC;
    [JKRouter open:@"JKNViewController" options:options];
    
//    [JKRouter open:@"JKNViewController"];
    
}

- (void)back{
//    [JKRouter pop];
    [JKRouter pop:@{@"testString":@"我是李四"} :YES];
//    [JKRouter pop:nil :NO complete:^(id result, NSError *error) {
//
//        [JKRouter open:@"JKNViewController"];
//    }];
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
