//
//  WMCreateOrderModel.m
//  JHCommunityClient_V3
//
//  Created by ios_yangfei on 17/6/10.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "WMCreateOrderModel.h"

//#import "WMShopDBModel.h"
#import <MJRefresh.h>
#import "NSString+Tool.h"

@implementation WMCreateOrderModel

+(WMCreateOrderModel *)shareAdvModelWithDic:(NSDictionary*)dic{
    return [[WMCreateOrderModel alloc]initWithDic:dic];
}

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@",key);
}

-(NSArray *)getTimesArr:(BOOL)is_ziti{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i=0; i<_day_dates.count; i++) {
        
        NSDictionary *dic = _day_dates[i];
        NSMutableDictionary *subDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        if (i == 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:_yy_peitime[@"set_time"]];
            is_ziti ? [arr insertObject:NSLocalizedString(@"立即自提", nil) atIndex:0] : [arr insertObject:NSLocalizedString(@"立即送达", nil) atIndex:0] ;
            subDic[@"times"] = arr;
        }else{
            subDic[@"times"] = _yy_peitime[@"nomal_time"];
        }
        [arr addObject:subDic];
        
    }
    return arr.copy;
}

@end
