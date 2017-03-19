//
//  UIViewController+JKRouter.h
//  
//
//  Created by jack on 17/1/20.
//  Copyright © 2017年 localadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JKRouter)


//每个VC 所属的moduleID，默认为nil
@property (nonatomic,copy) NSString *moduleID;

@end
