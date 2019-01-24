//
//  JHHeadLinesModel.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/17.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHHeadLinesModel.h"

@implementation JHHeadLinesModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key)
}
@end
