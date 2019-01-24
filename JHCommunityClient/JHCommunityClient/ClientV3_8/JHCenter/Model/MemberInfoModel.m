//
//  MemberInfoModel.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "MemberInfoModel.h"

@implementation MemberInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@",key);
}
+ (MemberInfoModel *)shareModel
{
    static MemberInfoModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^{
        if(model == nil)
        {
            model = [[MemberInfoModel alloc] init];
            
        }
    });
    return model;
}
- (NSString *)money{
    if (_money.length) {
        return _money;
    }
    return @"";
}
@end
