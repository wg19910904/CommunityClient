//
//  AdvModel.m
//  JHCash
//
//  Created by ijianghu on 16/12/9.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "AdvModel.h"

@implementation AdvModel

+(AdvModel *)shareAdvModelWithDic:(NSDictionary*)dic{
    return [[AdvModel alloc]initWithDic:dic];
}
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
