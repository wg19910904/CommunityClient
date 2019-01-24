//
//  JHMaidanListCellModel.m
//  JHCommunityClient
//
//  Created by xixixi on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHMaiDanModel.h"
 
@implementation JHMaiDanModel

+(void)getMDOrderListPage:(int)page block:(DataBlock)block{
    [HttpTool postWithAPI:@"client/v3/maidan/order/items" withParams:@{@"page":@(page)} success:^(id json) {
        NSLog(@"买单订单列表 =======  %@",json);
        if (ISPostSuccess) {
            NSArray *arr = [JHMaiDanModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"items"]];
            block(arr,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error : %@",error.description);
        block(nil,NOTCONNECT_STR);
    }];
}

+(void)getMDOrderDetail:(NSString *)order_id block:(ModelBlock)block{
    [HttpTool postWithAPI:@"client/v3/maidan/order/detail" withParams:@{@"order_id":order_id} success:^(id json) {
        NSLog(@"买单订单详情 =======  %@",json);
        if (ISPostSuccess) {
            JHMaiDanModel *model = [JHMaiDanModel mj_objectWithKeyValues:json[@"data"]];
            block(model,nil);
        }else{
            block(nil,Error_Msg);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error : %@",error.description);
        block(nil,NOTCONNECT_STR);
    }];
}

@end
