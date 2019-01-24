//
//  JHTuanGouDetialCellOneModel.m
//  JHCommunityClient
//
//  Created by xixixi on 16/4/5.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTuanGouDetialCellOneModel.h"
#import "NSDateToString.h"
@implementation JHTuanGouDetialCellOneModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (NSString *)ltime
{
    NSString *timeString;
    timeString = [NSDateToString stringFromUnixTime:_ltime withCharacter:@"."];
    return timeString;
}
- (NSString *)stime
{
    NSString *timeString;
    timeString = [NSDateToString stringFromUnixTime:_stime withCharacter:@"."];
    return timeString;
}
@end
