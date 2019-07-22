//
//  JKPluginA.h
//  JKRouter_Example
//
//  Created by JackLee on 2019/7/22.
//  Copyright © 2019 HHL110120. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKPluginA : NSObject
+ (BOOL)alert:(NSURL *)url :(NSDictionary *)extra :(void(^)(id result,NSError *error))completeBlock;
@end

NS_ASSUME_NONNULL_END
