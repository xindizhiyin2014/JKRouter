//
//  JKRouterSpec.m
//  JKRouter
//
//  Created by JackLee on 2018/12/3.
//  Copyright 2018年 HHL110120. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <JKRouter/JKRouter.h>


SPEC_BEGIN(JKRouterSpec)

describe(@"JKRouter", ^{
    context(@"test", ^{
        it(@"convertUrlStringToDictionary", ^{
            NSString *url = @"https://www.baidu.com";
            [[theValue([JKRouter convertUrlStringToDictionary:url].count) should] equal:theValue(0)];
            NSString *url1 = @"https://www.baidu.com?aaa=1";
             [[theValue([JKRouter convertUrlStringToDictionary:url1].count) should] equal:theValue(1)];
            NSString *url2 = @"https://www.baidu.com?aaa=1&bbb=2";
            [[theValue([JKRouter convertUrlStringToDictionary:url2].count) should] equal:theValue(2)];
            NSString *url3 = @"https://www.baidu.com?aaa=1&bbb=2&";
            [[theValue([JKRouter convertUrlStringToDictionary:url3].count) should] equal:theValue(2)];
        });
        it(@"appendParameter:", ^{
            NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
           url= [JKRouter url:url appendParameter:@{@"aaa":@"1"}];
            [[url.absoluteString should] equal:@"https://www.baidu.com?aaa=1"];
            
            NSString *url1 = @"https://www.baidu.com?aaa=1";
            url1 = [JKRouter urlStr:url1 appendParameter:@{@"bbb":@"2"}];
            [[url1 should] equal:@"https://www.baidu.com?aaa=1&bbb=2"];
            NSString *url2 = @"https://www.baidu.com?aaa=1&";
            url2 = [JKRouter urlStr:url2 appendParameter:@{@"bbb":@"2"}];
            [[url2 should] equal:@"https://www.baidu.com?aaa=1&bbb=2"];
            
        });
        it(@"removeQueryKeys", ^{
          NSString *url1 = @"https://www.baidu.com?aaa=1";
          NSString *testUrl1 = [JKRouter urlStr:url1 removeQueryKeys:@[@"aaa"]];
            [[testUrl1 should] equal:@"https://www.baidu.com"];
            
            NSString *url2 = @"https://www.baidu.com?aaa=1&bbb=2";
            NSString *testUrl2 = [JKRouter urlStr:url2 removeQueryKeys:@[@"aaa",@"bbb"]];
            [[testUrl2 should] equal:@"https://www.baidu.com"];
            
        });
        
    });
});

SPEC_END
