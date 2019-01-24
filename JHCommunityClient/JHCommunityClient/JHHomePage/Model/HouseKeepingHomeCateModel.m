//
//  HouseKeepingModel.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/15.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "HouseKeepingHomeCateModel.h"

@implementation HouseKeepingHomeCateModel
- (id)init
{
    if(self = [super init])
    {
        self.productArray = [NSMutableArray array];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@",key);
}
@end
