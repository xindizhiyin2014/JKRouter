//
//  JKGViewController.h
//  JKRouter_Example
//
//  Created by JackLee on 2018/1/6.
//  Copyright © 2018年 HHL110120. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Person:NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *sex;

@end

@interface JKGViewController : UIViewController
@property (nonatomic,strong) Person *jack;
@property (nonatomic,strong) NSArray <Person *> *friends;

@end
