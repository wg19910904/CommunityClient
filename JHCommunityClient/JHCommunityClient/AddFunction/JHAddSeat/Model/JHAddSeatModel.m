//
//  JHAddSeatModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHAddSeatModel.h"

@implementation JHAddSeatModel
+(JHAddSeatModel *)shareAddSeatModelWithDic:(NSDictionary *)dic{
    return [[JHAddSeatModel alloc]initWithDic:dic];
}
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.timeArray = @[].mutableCopy;
        [self.timeArray addObjectsFromArray:@[@"11:00-14:00",@"17:00-20:00"]];
        self.num = self.timeArray.count;
    }
    return self;
}

@end
