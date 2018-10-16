//
//  UINavigationController+JKRouter.m
//  JKRouter
//
//  Created by JackLee on 2018/10/16.
//

#import "UINavigationController+JKRouter.h"
#import <objc/runtime.h>
@implementation UINavigationController (JKRouter)
static char isPresentedKey;

- (BOOL)isPresented{
    return [objc_getAssociatedObject(self, &isPresentedKey) boolValue];
}

- (void)setIsPresented:(BOOL)isPresented{
objc_setAssociatedObject(self, &isPresentedKey, @(isPresented), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
