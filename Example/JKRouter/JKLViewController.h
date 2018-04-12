//
//  JKLViewController.h
//  JKRouter_Example
//
//  Created by JackLee on 2018/4/10.
//  Copyright © 2018年 HHL110120. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TestBlock)(NSString *);

@protocol JKLViewControllerDelegate<NSObject>

- (void)getTheTestData:(NSString *)data;

@end

@interface JKLViewController : UIViewController
@property (nonatomic,weak) id<JKLViewControllerDelegate> delegate;
@property (nonatomic,copy) TestBlock testBlock;
@end
