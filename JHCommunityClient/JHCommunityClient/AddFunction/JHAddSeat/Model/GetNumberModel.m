//
//  GetNumberModel.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "GetNumberModel.h"
 
#import <MJExtension.h>

@implementation GetNumberModel

-(NSString *)wait_time{
    return  [NSString stringWithFormat:@"%d分钟", [_wait_time intValue]];
}

/**
 *  检测是否已有订单
 *
 *  @param shop_id  商家id
 *  @param block 回调的block
 */
+(void)checkOutHaveOrder:(NSString *)shop_id block:(CreatBlock)block{
    
    [HttpTool postWithAPI:@"client/yuyue/paidui/checkpaidui" withParams:@{@"shop_id":shop_id} success:^(NSDictionary* json) {
        if ([json[@"error"] intValue]==0) {
            if ([json[@"data"][@"paidui_id"] integerValue] == 0) {
               block(nil,nil);
            }else{
                block(json[@"data"][@"paidui_id"],nil);
            }
            
        }else block(nil,json[@"message"]);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}


/**
 *  创建排队订单
 *
 *  @param infoDic  排队的信息
 *  @param block 回调的block
 */
+(void)getNumberWithInfo:(NSDictionary *)infoDic block:(CreatBlock)block{
    
    [HttpTool postWithAPI:@"client/yuyue/paidui/create" withParams:infoDic success:^(NSDictionary* json) {
        if ([json[@"error"] intValue]==0) {
            block(json[@"data"][@"paidui_id"],nil);
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
+(void)getNumberListWithPage:(int)page block:(GetNumberBlock)block{

    [HttpTool postWithAPI:@"client/yuyue/paidui/items" withParams:@{@"page":@(page)} success:^(NSDictionary* json) {
        NSLog(@"获取列表信息  %@",json);
        if ([json[@"error"] intValue]==0) {
            NSArray *arr=[GetNumberModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil,[json[@"data"][@"total_count"] intValue]);
        }else block(nil,json[@"message"],0);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil),0);
    }];
}

/**
 *  取消排队
 *
 *  @param paidui_id 排队id
 *  @param reasonStr 取消理由
 *  @param block     回调的block
 */
+(void)cancelPaiDuiWithId:(NSString *)paidui_id reasonStr:(NSString *)reasonStr block:(GetNumberBlock)block{
    
    [HttpTool postWithAPI:@"client/yuyue/paidui/cancel" withParams:@{@"paidui_id":paidui_id,@"reason":reasonStr} success:^(NSDictionary* json) {
        
        if ([json[@"error"] intValue]==0) {
            block(nil,nil,0);
        }else block(nil,json[@"message"],0);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil),0);
    }];
}

/**
 *  删除排号
 *
 *  @param paidui_id 排队id
 *  @param block     回调的block
 */
+(void)deletePaiDuiWithId:(NSString *)paidui_id block:(GetNumberBlock)block{
  
    [HttpTool postWithAPI:@"client/yuyue/paidui/delete" withParams:@{@"paidui_id":paidui_id} success:^(NSDictionary* json) {
        
        if ([json[@"error"] intValue]==0) {
            block(nil,nil,0);
        }else block(nil,json[@"message"],0);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil),0);
    }];
}

/**
 *  获取详情
 *
 *  @param paidui_id 排队id
 *  @param block     回到的block
 */
+(void)getNumberDetail:(NSString *)paidui_id block:(GetNumberDetail)block{
    
    [HttpTool postWithAPI:@"client/yuyue/paidui/detail" withParams:@{@"paidui_id":paidui_id} success:^(NSDictionary* json) {
        NSLog(@"排队详情 %@",json);
        if ([json[@"error"] intValue]==0) {
            GetNumberModel *model=[GetNumberModel mj_objectWithKeyValues:json[@"data"]];
            block(model,nil);
        }else block(nil,json[@"message"]);
        
    } failure:^(NSError *error) {
        block(nil,NSLocalizedString(@"服务器繁忙,请稍后再试!", nil));
    }];
}
@end
