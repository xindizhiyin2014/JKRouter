//
//  UIViewController+JKRouter.m
//  
//
//  Created by jack on 17/1/20.
//  Copyright © 2017年 localadmin. All rights reserved.
//

#import "UIViewController+JKRouter.h"
#import <objc/runtime.h>

@implementation UIViewController (JKRouter)


static char moduleID;

- (NSString *)moduleID{

    return objc_getAssociatedObject(self, &moduleID);
}

- (void)setModuleID:(NSString *)moduleID{

    objc_setAssociatedObject(self, &moduleID, moduleID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end
