//
//  PropertyNotifyModel.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "PropertyNotifyModel.h"
#import "CommunityHttpTool.h"
#import <MJExtension.h>
#import "JHShareModel.h"

@implementation PropertyNotifyModel


+(void)getNotifyListWithPage:(int)page block:(NotifyBlock)block{
    
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/news/items" withParams:@{@"page":@(page),@"xiaoqu_id":[JHShareModel shareModel].communityModel.xiaoqu_id} success:^(id json) {
        NSLog(@"物业通知  %@",json);
        if ([json[@"error"] intValue]==0) {
            NSArray *arr=[PropertyNotifyModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else block(nil,json[@"message"]);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}

@end
