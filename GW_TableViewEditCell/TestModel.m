//
//  TestModel.m
//  TMSwipeCell
//
//  Created by cocomanber on 2018/7/7.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

+ (NSArray *)getAllDatas{
    NSMutableArray *array = @[].mutableCopy;
    
    for (int i = 0; i < 50; i ++) {
        TestModel *model = [TestModel new];
        model.name = [self getNameRand][arc4random()%([[self getNameRand] count])];
        model.message_id = 0;
        if (i % 3 == 0) {
            model.message_id = 1;
        }
        [array addObject:model];
    }
    
    TestModel *model = [TestModel new];
    model.name = @"公众号消息";
    model.message_id = 2;

    
    [array insertObject:model atIndex:2];
    [array insertObject:model atIndex:5];
    return array.copy;
}

+ (NSArray *)getNameRand{
    return @[@"11",@"22",@"33",@"44",@"55"];
}

@end
