//
//  NSArray+JKDataHelper.m
//  Pods
//
//  Created by Jack on 17/3/28.
//
//

#import "NSArray+JKDataHelper.h"
#import "NSObject+JK.h"


@implementation NSArray (JKDataHelper)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = NSClassFromString(@"__NSArrayI");
    
        [self JKswizzleMethod:@selector(objectAtIndex:) withMethod:@selector(JKsafeObjectAtIndex:) withClass:targetClass];
        
         [self JKswizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(JKsafeInitWithObjects:count:) withClass:NSClassFromString(@"__NSPlaceholderArray")];
        
        
    });
    

}


- (id)JKsafeObjectAtIndex:(NSInteger)index{
    if (index >=0 && index < self.count) {
        
        return [self JKsafeObjectAtIndex:index];
        
    }else{
    JKDataHelperLog(@"[__NSDictionaryI dictionaryWithObject:forKey:] key can't be nil");
        JKDataHelperLog(@"[__NSArrayI objectAtIndex:] index is greater than the array.count or the index is less than zero");
        
        return nil;
    }

}

- (instancetype)JKsafeInitWithObjects:(int **)objects count:(NSInteger)count{
    for (int i=0; i<count; i++) {
        
        if (!objects[i]) {
        
            JKDataHelperLog(@"%@", [NSString stringWithFormat:@"[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil to objects[%d]",i]);
            return nil;

            
        }
    }
    
    return [self JKsafeInitWithObjects:objects count:count];
    
}



@end
