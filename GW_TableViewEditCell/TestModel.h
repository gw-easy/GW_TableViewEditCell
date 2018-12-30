//
//  TestModel.h
//  TMSwipeCell
//
//  Created by cocomanber on 2018/7/7.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (nonatomic, copy)NSString *headUrl;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, assign)int message_id;

+ (NSArray *)getAllDatas;

@end
