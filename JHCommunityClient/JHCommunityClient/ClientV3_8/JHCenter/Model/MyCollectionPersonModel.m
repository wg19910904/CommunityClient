//
//  MyCollectionPersonModel.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MyCollectionPersonModel.h"

@implementation MyCollectionPersonModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@",key);
}
@end
