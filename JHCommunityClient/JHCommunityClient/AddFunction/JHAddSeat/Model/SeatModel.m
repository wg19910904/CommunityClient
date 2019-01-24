//
//  SeatModel.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/23.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "SeatModel.h"
 
#import <MJExtension.h>

@implementation SeatModel

/**
 *  检测是否已有订单
 *
 *  @param shop_id  商家id
 *  @param block 回调的block
 */
+(void)checkOutHaveOrder:(NSString *)shop_id block:(CreatBlock)block{
    
    [HttpTool postWithAPI:@"client/yuyue/dingzuo/checkdingzuo" withParams:@{@"shop_id":shop_id} success:^(NSDictionary* json) {
        if ([json[@"error"] intValue]==0) {
            if ([json[@"data"][@"dingzuo_id"] integerValue] == 0) {
                block(nil,nil);
            }else{
                block(json[@"data"][@"dingzuo_id"],nil);
            }
            
        }else block(nil,json[@"message"]);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}

/**
 *  获取列表信息
 *
 *  @param page  分页
 *  @param block 回调的block
 */
+(void)getSeatListWithPage:(int)page block:(SeatModelBlock)block{
    
    [HttpTool postWithAPI:@"client/yuyue/dingzuo/items" withParams:@{@"page":@(page)} success:^(NSDictionary* json) {
        NSLog(@"%@",json);
        if ([json[@"error"] intValue]==0) {
            NSArray *arr=[SeatModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else block(nil,json[@"message"]);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}

/**
 *  催单
 *
 *  @param dingzuo_id  订座id
 *  @param block     回调的block
 */
+(void)cuiDingZuoWithId:(NSString *)dingzuo_id block:(SeatModelBlock)block{
    
    [HttpTool postWithAPI:@"client/yuyue/dingzuo/cuidan" withParams:@{@"dingzuo_id":dingzuo_id} success:^(NSDictionary* json) {
        
        if ([json[@"error"] intValue]==0) {
            block(nil,nil);
        }else block(nil,json[@"message"]);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}


/**
 *  获取详情
 *
 *  @param dingzuo_id 订座id
 *  @param block     回到的block
 */
+(void)getSeatModelDetail:(NSString *)dingzuo_id block:(SeatModelDetail)block{
    
    [HttpTool postWithAPI:@"client/yuyue/dingzuo/detail" withParams:@{@"dingzuo_id":dingzuo_id} success:^(NSDictionary* json) {
        
        if ([json[@"error"] intValue]==0) {
            NSLog(@"%@",json[@"data"]);
            SeatModel *model=[SeatModel mj_objectWithKeyValues:json[@"data"]];
            block(model,nil);
        }else block(nil,json[@"message"]);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}

/**
 *  取消订座
 *
 *  @param dingzuo_id  订座id
 *  @param block     回调的block
 */
+(void)cancelDingZuoWithId:(NSString *)dingzuo_id reasonStr:(NSString *)reasonStr block:(SeatModelBlock)block{
    
    [HttpTool postWithAPI:@"client/yuyue/dingzuo/cancel" withParams:@{@"dingzuo_id":dingzuo_id,@"reason":reasonStr} success:^(NSDictionary* json) {
        if ([json[@"error"] intValue]==0) {
            block(nil,nil);
        }else block(nil,json[@"message"]);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}

/**
 *  删除订座
 *
 *  @param dingzuo_id  订座id
 *  @param block     回调的block
 */
+(void)deleteDingZuoWithId:(NSString *)dingzuo_id block:(SeatModelBlock)block{
    
    [HttpTool postWithAPI:@"client/yuyue/dingzuo/delete" withParams:@{@"dingzuo_id":dingzuo_id} success:^(NSDictionary* json) {
        
        if ([json[@"error"] intValue]==0) {
            block(nil,nil);
        }else block(nil,json[@"message"]);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}

@end
