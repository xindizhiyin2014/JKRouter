//
//  JKViewController.m
//  JKRouter
//
//  Created by HHL110120 on 03/14/2017.
//  Copyright (c) 2017 HHL110120. All rights reserved.
//

#import "JKViewController.h"
#import "JKEViewController.h"
#import "JKGViewController.h"

@interface JKViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_contentTable;
    NSArray *_dataArr;
    NSString *_backStr;
}
@end

@implementation JKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = @[@"正常跳转",@"正常跳转＋参数",@"正常跳转，返回＋参数",@"路由跳转",@"路由跳转+参数",@"跳转＋权限校验",@"present跳转",@"自定义跳转",@"webVC跳转",@"使用storyBoard",@"通过json传输参数跳转",@"createStyleReplace",@"弹框后跳转",@"popWithStep验证"];
    _contentTable = [[UITableView alloc] initWithFrame:self.view.frame];
    [_contentTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    _contentTable.delegate =self;
    _contentTable.dataSource =self;
    [self.view addSubview:_contentTable];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"切换模式" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
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




- (void)viewWillAppear:(BOOL)animated{
    if (_backStr) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:_backStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    _backStr =nil;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self normalJumpWithNoParams];
        }
            break;
        case 1:
        {
            [self normalJumpWithParams];
        }
            break;

        case 2:
        {
            [self normalJumpWithNoParams1];
        }
            break;
        case 3:
        {
            [self userURLJump];
        }
            break;
        case 4:
        {
            [self userURLJumpWithParams];
        }
            break;
        case 5:
        {
            [self userURLJumpWithValidateRight];
        }
            break;
        case 6:
        {
            [self userPresentJump];
        }
            break;
        case 7:
        {
            [self openWithSpecifiedTranform];
        }
            break;
        case 8:
        {
            [self openWebVC];
        }
            break;
        case 9:
        {
            [self useStoryBoard];
        }
            break;
        case 10:
        {
            [self useJson];
        }
            break;
        case 11:
        {
            [self createStyleReplace];
        }
            break;
        case 12:
        {
            [self afterAlertJump];
        }
            break;
        case 13:
        {
            [self verifyPopWithStep];
        }
            break;

        default:
            break;
    }

}


- (void)normalJumpWithNoParams{

    [JKRouter open:@"JKAViewController"];
}

- (void)normalJumpWithParams{
    NSDictionary *params = @{@"testContent":@"Hi, I'm Jack"};
    RouterOptions *options = [RouterOptions optionsWithDefaultParams:params];
    [JKRouter open:@"JKBViewController" options:options];

}

- (void)normalJumpWithNoParams1{

    [JKRouter open:@"JKCViewController"];

}


- (void)userURLJump{

//    [JKRouter URLOpen:@"jkpp://jackApp:10001"];
//    [JKRouter URLOpen:@"https://www.baidu.com?jkRouterAppOpen=1"];
//    [JKRouter URLOpen:@"https://www.baidu.com?jkRouterAppOpen=1" extra:@{@"title":@"123"}];
     [JKRouter URLOpen:@"file:///123.html"];
}


- (void)userURLJumpWithParams{
    
    [JKRouter URLOpen:@"jkpp://www.jack.com/user_profile?testContent=Hi, I'm Jack"];
}

- (void)userURLJumpWithValidateRight{
    
    [JKRouter URLOpen:@"jkpp://www.jack.com/apply_invite_code"];
}

- (void)userPresentJump{

    RouterOptions *options = [RouterOptions options];
    [JKRouter open:@"JKEViewController" options:options];
}

- (void)openWithSpecifiedTranform{
    
    [JKRouter open:@"XWPageCoverController"];
}

- (void)openWebVC{

    //file 协议打开沙河web页面
    
}

- (void)useStoryBoard{
    [JKRouter open:@"JKFViewController"];
}

- (void)useJson{
    NSDictionary *json = @{@"jack": @{@"name" : @"jack",@"sex":@"男"},
                       @"friends": @[@{@"name":@"lili",@"sex":@"女"},@{@"name":@"jack",@"sex":@"女"}]
                           };
    RouterOptions * options = [RouterOptions optionsWithDefaultParams:json];
    [JKRouter open:@"JKGViewController" optionsWithJSON:options];
}

- (void)createStyleReplace{
    [JKRouter open:@"JKHViewController"];
}

- (void)afterAlertJump{
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"弹框后跳转" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action  = [UIAlertAction actionWithTitle:@"跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [JKRouter open:@"JKCViewController"];
//    }];
//    [alertVC addAction:action];
//    [self presentViewController:alertVC animated:YES completion:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"弹框后跳转" delegate:self cancelButtonTitle:@"跳转" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)verifyPopWithStep{
    [JKRouter open:@"JKJViewController"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  [JKRouter open:@"JKCViewController"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
