//
//  JKViewController.m
//  JKRouter
//
//  Created by HHL110120 on 03/14/2017.
//  Copyright (c) 2017 HHL110120. All rights reserved.
//

#import "JKViewController.h"
#import "JKEViewController.h"
@interface JKViewController ()<UITableViewDelegate,UITableViewDataSource>
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
    _dataArr = @[@"正常跳转",@"正常跳转＋参数",@"正常跳转，返回＋参数",@"路由跳转",@"路由跳转+参数",@"跳转＋权限校验",@"present跳转",@"自定义跳转",@"webVC跳转",@"使用storyBoard"];
    _contentTable = [[UITableView alloc] initWithFrame:self.view.frame];
    [_contentTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    _contentTable.delegate =self;
    _contentTable.dataSource =self;
    [self.view addSubview:_contentTable];
    
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

    [JKRouter URLOpen:@"jkpp://jackApp:10001"];
}


- (void)userURLJumpWithParams{
    
    [JKRouter URLOpen:@"jkpp://jackApp:10002?testContent=Hi, I'm Jack"];
}

- (void)userURLJumpWithValidateRight{
    
    [JKRouter URLOpen:@"jkpp://jackApp:10003"];
}

- (void)userPresentJump{

    RouterOptions *options = [RouterOptions options];
    [JKRouter open:@"JKEViewController" options:options];
}

- (void)openWithSpecifiedTranform{
    
    [JKRouter open:@"XWPageCoverController"];
}

- (void)openWebVC{

[JKRouter URLOpen:@"jkpp://jackApp:10004/abc/mn/qq"];
}

- (void)useStoryBoard{
    [JKRouter open:@"JKFViewController"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
