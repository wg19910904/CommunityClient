//
//  NeighbourModel.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/8/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "NeighbourModel.h"
#import "CommunityHttpTool.h"
#import <MJExtension.h>

@implementation NeighbourModel

+(void)getNeighbourModelListWithPage:(int)page block:(NeighbourBlock)block{
    
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/tieba/items" withParams:@{@"page":@(page)} success:^(id json) {
        NSLog(@"邻里圈  %@",json);
        if ([json[@"error"] intValue]==0) {
            NSArray *arr=[NeighbourModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else  block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}


+(void)likeTiebaWithId:(NSString *)tieba_id block:(NeighbourBlock)block{
    
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/tieba/like" withParams:@{@"tieba_id":tieba_id} success:^(id json) {
        NSLog(@"邻里圈点赞  %@",json);
        if ([json[@"error"] intValue]==0) {
            block(@[],NSLocalizedString(@"点赞成功", nil));
        }else  block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
    
}

+(void)getNeighbourModelDeatilWithId:(NSString *)tieba_id block:(DetailBlock)block{
    
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/tieba/detail" withParams:@{@"tieba_id":tieba_id} success:^(id json) {
        NSLog(@"邻里圈详情  %@",json);
        if ([json[@"error"] intValue]==0) {
            NeighbourModel *model=[NeighbourModel mj_objectWithKeyValues:json[@"data"][@"tieba"]];
            NSArray *arr=[NeighbourCommentModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            model.items=arr;
            block(model,nil);
        }else  block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}

+(void)getNeighbourCommentListWithPage:(int)page tieba_id:(NSString *)tieba_id block:(NeighbourBlock)block{
    
    [CommunityHttpTool postWithAPI:@"client/xiaoqu/tieba/replyItems" withParams:@{@"tieba_id":tieba_id,@"page":@(page)} success:^(id json) {
        NSLog(@"邻里圈评论列表  %@",json);
        if ([json[@"error"] intValue]==0) {
            NSArray *arr=[NeighbourCommentModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else  block(nil,json[@"message"]);
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}

@end
