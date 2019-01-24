//
//  WXInfoModel.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "WXInfoModel.h"

@implementation WXInfoModel
+ (WXInfoModel *)shareWXInfoModel
{
    static WXInfoModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^{
        if(model == nil)
        {
            model = [[WXInfoModel alloc] init];
        }
            
    });
    return model;

}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@",key);
}
@end
